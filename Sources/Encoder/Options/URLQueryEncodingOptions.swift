import Foundation

internal struct URLQueryEncodingOptions {

    internal let dateEncodingStrategy: URLQueryDateEncodingStrategy
    internal let dataEncodingStrategy: URLQueryDataEncodingStrategy
    internal let nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy
    internal let boolEncodingStrategy: URLQueryBoolEncodingStrategy
    internal let arrayEncodingStrategy: URLQueryArrayEncodingStrategy
    internal let spaceEncodingStrategy: URLQuerySpaceEncodingStrategy
    internal let keyEncodingStrategy: URLQueryKeyEncodingStrategy
}
