import XCTest

@testable import URLQueryCoder

final class URLQueryEncoderTests: XCTestCase, URLQueryEncoderTesting {

    private(set) var encoder: URLQueryEncoder!

    func testThatEncoderSucceedsWhenEncodingEmptyDictionary() {
        let value: [String: String] = [:]
        let expectedQuery = ""

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToBoolDictionary() {
        let value = [
            "foo": true,
            "bar": false
        ]

        let expectedQuery = "foo=true&bar=false"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToIntDictionary() {
        let value = [
            "foo": 123,
            "bar": -456
        ]

        let expectedQuery = "foo=123&bar=-456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt8Dictionary() {
        let value: [String: Int8] = [
            "foo": 12,
            "bar": -34
        ]

        let expectedQuery = "foo=12&bar=-34"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt16Dictionary() {
        let value: [String: Int16] = [
            "foo": 123,
            "bar": -456
        ]

        let expectedQuery = "foo=123&bar=-456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt32Dictionary() {
        let value: [String: Int32] = [
            "foo": 123,
            "bar": -456
        ]

        let expectedQuery = "foo=123&bar=-456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToInt64Dictionary() {
        let value: [String: Int64] = [
            "foo": 123,
            "bar": -456
        ]

        let expectedQuery = "foo=123&bar=-456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUIntDictionary() {
        let value: [String: UInt] = [
            "foo": 123,
            "bar": 456
        ]

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt8Dictionary() {
        let value: [String: UInt8] = [
            "foo": 12,
            "bar": 34
        ]

        let expectedQuery = "foo=12&bar=34"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt16Dictionary() {
        let value: [String: UInt16] = [
            "foo": 123,
            "bar": 456
        ]

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt32Dictionary() {
        let value: [String: UInt32] = [
            "foo": 123,
            "bar": 456
        ]

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToUInt64Dictionary() {
        let value: [String: UInt64] = [
            "foo": 123,
            "bar": 456
        ]

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToDoubleDictionary() {
        let value = [
            "foo": 1.23,
            "bar": -45.6
        ]

        let expectedQuery = "foo=1.23&bar=-45.6"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToFloatDictionary() {
        let value: [String: Float] = [
            "foo": 1.23,
            "bar": -45.6
        ]

        let expectedQuery = "foo=1.23&bar=-45.6"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToStringDictionary() {
        let value = [
            "foo": "qwe",
            "bar": "asd"
        ]

        let expectedQuery = "foo=qwe&bar=asd"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToURLDictionary() {
        let foo = "https://www.swift.org/getting-started#swift-version"
        let bar = "https://getsupport.apple.com/?locale=en_US&caller=sfaq&PRKEYS=PF9"

        let value = [
            "foo": URL(string: foo)!,
            "bar": URL(string: bar)!
        ]

        let expectedQuery = "foo=\(foo.urlQueryEncoded!)&bar=\(bar.urlQueryEncoded!)"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStringToArrayDictionary() {
        let value: [String: [Int?]] = [
            "foo": [1, 2, 3],
            "bar": [4, nil, 6]
        ]

        let expectedQuery = "foo[0]=1&foo[1]=2&foo[2]=3&bar[0]=4&bar[2]=6"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingNestedStringToIntDictionary() {
        let value = [
            "foo": [
                "bar": 123,
                "baz": -456
            ]
        ]

        let expectedQuery = "foo[bar]=123&foo[baz]=-456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingNestedArrayOfStringToIntDictionaries() {
        let value = [
            "foo": [
                [
                    "bar": 123,
                    "baz": 456
                ]
            ]
        ]

        let expectedQuery = "foo[0][bar]=123&foo[0][baz]=456"

        assertEncoderSucceeds(
            encoding: value,
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingEmptyStruct() {
        struct EncodableStruct: Encodable { }

        let expectedQuery = ""

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithMultipleProperties() {
        struct EncodableStruct: Encodable {
            let foo = true
            let bar: Int? = 123
            let baz: Int? = nil
            let bat = "qwe"
        }

        let expectedQuery = "foo=true&bar=123&bat=qwe"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithNestedStruct() {
        struct EncodableStruct: Encodable {
            struct NestedStruct: Encodable {
                let bar = 123
                let baz = 456
            }

            let foo = NestedStruct()
        }

        let expectedQuery = "foo[bar]=123&foo[baz]=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructWithNestedEnum() {
        struct EncodableStruct: Encodable {
            enum NestedEnum: String, Encodable {
                case qwe
                case asd
            }

            let foo = NestedEnum.qwe
            let bar = NestedEnum.asd
        }

        let expectedQuery = "foo=qwe&bar=asd"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateKeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
            }

            let foo = 123
            let bar = 456

            func encode(to encoder: Encoder) throws {
                var fooContainer = encoder.container(keyedBy: CodingKeys.self)
                var barContainer = encoder.container(keyedBy: CodingKeys.self)

                try fooContainer.encode(foo, forKey: .foo)
                try barContainer.encode(bar, forKey: .bar)
            }
        }

        let expectedQuery = "foo=123&bar=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateUnkeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            let bar = 123
            let baz = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var barContainer = container.nestedUnkeyedContainer(forKey: .foo)
                var bazContainer = container.nestedUnkeyedContainer(forKey: .foo)

                try barContainer.encode(bar)
                try bazContainer.encode(baz)
            }
        }

        let expectedQuery = "foo[0]=123&foo[1]=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateKeyedContainersOfUnkeyedContainer() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            enum BarCodingKeys: String, CodingKey {
                case bar
            }

            enum BazCodingKeys: String, CodingKey {
                case baz
            }

            let bar = 123
            let baz = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .foo)

                var barContainer = unkeyedContainer.nestedContainer(keyedBy: BarCodingKeys.self)
                var bazContainer = unkeyedContainer.nestedContainer(keyedBy: BazCodingKeys.self)

                try barContainer.encode(bar, forKey: .bar)
                try bazContainer.encode(baz, forKey: .baz)
            }
        }

        let expectedQuery = "foo[0][bar]=123&foo[1][baz]=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructInSeparateNestedKeyedContainers() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
            }

            struct NestedStruct {
                enum CodingKeys: String, CodingKey {
                    case bar
                    case baz
                }

                let bar = 123
                let baz = 456
            }

            let foo = NestedStruct()

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var barContainer = container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)
                var bazContainer = container.nestedContainer(keyedBy: NestedStruct.CodingKeys.self, forKey: .foo)

                try barContainer.encode(foo.bar, forKey: .bar)
                try bazContainer.encode(foo.baz, forKey: .baz)
            }
        }

        let expectedQuery = "foo[bar]=123&foo[baz]=456"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructUsingSuperEncoder() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
                case bat
            }

            let foo = "qwe"
            let bar = "asd"
            let baz = 123
            let bat = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)

                let superEncoder = container.superEncoder()
                var superContainer = superEncoder.container(keyedBy: CodingKeys.self)

                try superContainer.encode(foo, forKey: .foo)
                try superContainer.encode(bar, forKey: .bar)
            }
        }

        let expectedQuery = "baz=123&bat=456&super[foo]=qwe&super[bar]=asd"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructUsingSuperEncoderForKeys() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case foo
                case bar
                case baz
                case bat
            }

            let foo = "qwe"
            let bar = "asd"
            let baz = 123
            let bat = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)

                let fooSuperEncoder = container.superEncoder(forKey: .foo)
                let barSuperEncoder = container.superEncoder(forKey: .bar)

                var fooContainer = fooSuperEncoder.container(keyedBy: CodingKeys.self)
                var barContainer = barSuperEncoder.container(keyedBy: CodingKeys.self)

                try fooContainer.encode(foo, forKey: .foo)
                try barContainer.encode(bar, forKey: .bar)
            }
        }

        let expectedQuery = "baz=123&bat=456&foo[foo]=qwe&bar[bar]=asd"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingStructUsingSuperEncoderOfNestedUnkeyedContainer() {
        struct EncodableStruct: Encodable {
            enum CodingKeys: String, CodingKey {
                case baz
            }

            let foo = "qwe"
            let bar = "asd"
            let baz = 123
            let bat = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                var bazContainer = container.nestedUnkeyedContainer(forKey: .baz)
                var batContainer = bazContainer.nestedUnkeyedContainer()

                try bazContainer.encode(baz)
                try batContainer.encode(bat)

                let bazSuperEncoder = bazContainer.superEncoder()

                var fooContainer = bazSuperEncoder.unkeyedContainer()
                var barContainer = bazSuperEncoder.unkeyedContainer()

                try fooContainer.encode(foo)
                try barContainer.encode(bar)
            }
        }

        let expectedQuery = "baz[0][0]=456&baz[1]=123&baz[2][0]=qwe&baz[2][1]=asd"

        assertEncoderSucceeds(
            encoding: EncodableStruct(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderSucceedsWhenEncodingSubclass() {
        class EncodableClass: Encodable {
            let foo = "qwe"
            let bar = "asd"
        }

        class EncodableSubclass: EncodableClass {
            enum CodingKeys: String, CodingKey {
                case baz
                case bat
            }

            let baz = 123
            let bat = 456

            override func encode(to encoder: Encoder) throws {
                try super.encode(to: encoder)

                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(baz, forKey: .baz)
                try container.encode(bat, forKey: .bat)
            }
        }

        let expectedQuery = "foo=qwe&bar=asd&baz=123&bat=456"

        assertEncoderSucceeds(
            encoding: EncodableSubclass(),
            expecting: expectedQuery
        )
    }

    func testThatEncoderFailsWhenEncodingArray() {
        let value = [1, 2, 3]

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as [Int], _):
                return invalidValue == value

            default:
                return false
            }
        }
    }

    func testThatEncoderFailsWhenEncodingSingleValue() {
        let value = 123

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                return invalidValue == value

            default:
                return false
            }
        }
    }

    func testThatEncoderFailsWhenEncodingMultipleSingleValuesForKey() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()

                try container.encode(foo)
                try container.encode(bar)
            }
        }

        let value = EncodableStruct()

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                return invalidValue == value.bar

            default:
                return false
            }
        }
    }

    func testThatEncoderFailsWhenEncodingWithMultipleSingleValueContainers() {
        struct EncodableStruct: Encodable {
            let foo = 123
            let bar = 456

            func encode(to encoder: Encoder) throws {
                var fooContainer = encoder.singleValueContainer()
                var barContainer = encoder.singleValueContainer()

                try fooContainer.encode(foo)
                try barContainer.encode(bar)
            }
        }

        let value = EncodableStruct()

        assertEncoderFails(encoding: value) { error in
            switch error {
            case let EncodingError.invalidValue(invalidValue as Int, _):
                return invalidValue == value.bar

            default:
                return false
            }
        }
    }

    override func setUp() {
        super.setUp()

        encoder = URLQueryEncoder()
    }
}
