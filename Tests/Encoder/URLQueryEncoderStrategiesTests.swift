import XCTest

@testable import URLQueryCoder

final class URLQueryEncoderStrategiesTests: XCTestCase, URLQueryEncoderTesting {

    private(set) var encoder: URLQueryEncoder!

    func testThatEncoderSucceedsWhenEncodingStructUsingDefaultKeys() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456
        }

        encoder.keyEncodingStrategy = .useDefaultKeys

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructUsingCustomFunctionForKeys() {
        struct EncodableStruct: Encodable {
            let foo = true
            let bar = false
        }

        encoder.keyEncodingStrategy = .custom { codingPath in
            codingPath.last.map { AnyCodingKey("\($0.stringValue).value") } ?? AnyCodingKey("unknown")
        }

        let expectedQuery = "foo.value=true&bar.value=false"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDate() {
        encoder.dateEncodingStrategy = .deferredToDate

        let date = Date(timeIntervalSinceReferenceDate: 123_456.789)
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(date.timeIntervalSinceReferenceDate)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDateToMillisecondsSince1970() {
        encoder.dateEncodingStrategy = .millisecondsSince1970

        let date = Date(timeIntervalSinceReferenceDate: 123_456.789)
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(date.timeIntervalSince1970 * 1000)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDateToSecondsSince1970() {
        encoder.dateEncodingStrategy = .secondsSince1970

        let date = Date(timeIntervalSinceReferenceDate: 123_456.789)
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(date.timeIntervalSince1970)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    func testThatEncoderSucceedsWhenEncodingDateToISO8601Format() {
        encoder.dateEncodingStrategy = .iso8601

        let dateString = "1970-01-02T10:17:36Z"
        let dateFormatter = ISO8601DateFormatter()

        dateFormatter.timeZone = .iso8601

        let date = dateFormatter.date(from: dateString)!
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(dateString.urlQueryEncoded!)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDateUsingFormatter() {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .iso8601

        encoder.dateEncodingStrategy = .formatted(dateFormatter)

        let date = Date(timeIntervalSinceReferenceDate: 123_456.789)
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(dateFormatter.string(from: date).urlQueryEncoded!)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDateUsingCustomFunction() {
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()

            try container.encode("\(date.timeIntervalSince1970)")
        }

        let date = Date(timeIntervalSinceReferenceDate: 123.456)
        let value = ["foobar": date]
        let expectedQuery = "foobar=\(date.timeIntervalSince1970)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingData() {
        encoder.dataEncodingStrategy = .deferredToData

        let data = Data([1, 2, 3])
        let value = ["foobar": data]
        let expectedQuery = "foobar[0]=1&foobar[1]=2&foobar[2]=3"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDataToBase64() {
        encoder.dataEncodingStrategy = .base64

        let data = Data([1, 2, 3])
        let value = ["foobar": data]
        let expectedQuery = "foobar=\(data.base64EncodedString())"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingDataUsingCustomFunction() {
        encoder.dataEncodingStrategy = .custom { data, encoder in
            var container = encoder.singleValueContainer()

            let string = data
                .map { "\($0)" }
                .joined(separator: ", ")

            try container.encode(string)
        }

        let data = Data([1, 2, 3])
        let value = ["foobar": data]
        let expectedQuery = "foobar=\("1, 2, 3".urlQueryEncoded!)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderFailsWhenEncodingPositiveInfinityFloat() {
        encoder.nonConformingFloatEncodingStrategy = .throw

        let number = Float.infinity
        let value = ["foobar": number]

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                return invalidValue == number

            default:
                return false
            }
        }
    }

    func testThatEncoderFailsWhenEncodingNegativeInfinityFloat() {
        encoder.nonConformingFloatEncodingStrategy = .throw

        let number = -Float.infinity
        let value = ["foobar": number]

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                return invalidValue == number

            default:
                return false
            }
        }
    }

    func testThatEncoderFailsWhenEncodingNanFloat() {
        encoder.nonConformingFloatEncodingStrategy = .throw

        let value = ["foobar": Float.nan]

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Float, _):
                return invalidValue.isNaN

            default:
                return false
            }
        }
    }

    func testThatEncoderSucceedsWhenEncodingNonConformingFloatToString() {
        let positiveInfinity = "+∞"
        let negativeInfinity = "-∞"
        let nan = "¬"

        encoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: positiveInfinity,
            negativeInfinity: negativeInfinity,
            nan: nan
        )

        let value = [
            "foo": Float.infinity,
            "bar": -Float.infinity,
            "baz": Float.nan
        ]

        let expectedQuery = """
            foo=\(positiveInfinity.urlQueryEncoded!)&\
            bar=\(negativeInfinity.urlQueryEncoded!)&\
            baz=\(nan.urlQueryEncoded!)
            """

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingEnumeratedArray() {
        encoder.arrayEncodingStrategy = .enumerated

        let value: [String: [Int]] = [
            "foo": [1, 2, 3]
        ]

        let expectedQuery = "foo[0]=1&foo[1]=2&foo[2]=3"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingUnenumeratedArray() {
        encoder.arrayEncodingStrategy = .unenumerated

        let value: [String: [Int]] = [
            "foo": [1, 2, 3]
        ]

        let expectedQuery = "foo[]=1&foo[]=2&foo[]=3"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingLiteralBool() {
        encoder.boolEncodingStrategy = .literal

        let value: [String: Bool] = [
            "foo": true,
            "bar": false
        ]

        let expectedQuery = "foo=true&bar=false"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingNumericBool() {
        encoder.boolEncodingStrategy = .numeric

        let value: [String: Bool] = [
            "foo": true,
            "bar": false
        ]

        let expectedQuery = "foo=1&bar=0"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingPercentEscapedString() {
        encoder.spaceEncodingStrategy = .percentEscaped

        let value = ["foobar": "qwe asd"]
        let expectedQuery = "foobar=qwe%20asd"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingPlusReplacedString() {
        encoder.spaceEncodingStrategy = .plusReplaced

        let value = ["foobar": "qwe asd"]
        let expectedQuery = "foobar=qwe+asd"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    override func setUp() {
        super.setUp()

        encoder = URLQueryEncoder()
    }
}
