import XCTest
import URLQueryCoder

protocol URLQueryEncoderTesting {

    var encoder: URLQueryEncoder! { get }
}

extension URLQueryEncoderTesting {

    func assertEncoderSucceeds<T: Encodable>(
        encoding value: T,
        expecting expectedQuery: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectedQueryComponents = expectedQuery
            .components(separatedBy: "&")
            .sorted()

        do {
            let query = try encoder.encode(value)

            let queryComponents = query
                .components(separatedBy: "&")
                .sorted()

            XCTAssertEqual(
                expectedQueryComponents,
                queryComponents,
                file: file,
                line: line
            )
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func assertEncoderFails<T: Encodable>(
        encoding value: T,
        file: StaticString = #file,
        line: UInt = #line,
        errorValidation: (_ error: Error) -> Bool
    ) {
        do {
            _ = try encoder.encode(value)

            XCTFail("Test encountered unexpected behavior")
        } catch {
            if !errorValidation(error) {
                XCTFail("Test encountered unexpected error: \(error)", file: file, line: line)
            }
        }
    }
}
