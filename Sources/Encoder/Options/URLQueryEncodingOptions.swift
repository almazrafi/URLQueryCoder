import Foundation

internal struct URLQueryEncodingOptions {

    internal var dateEncodingStrategy: URLQueryDateEncodingStrategy
    internal var dataEncodingStrategy: URLQueryDataEncodingStrategy
    internal var nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy
    internal var boolEncodingStrategy: URLQueryBoolEncodingStrategy
    internal var arrayEncodingStrategy: URLQueryArrayEncodingStrategy
    internal var spaceEncodingStrategy: URLQuerySpaceEncodingStrategy
    internal var keyEncodingStrategy: URLQueryKeyEncodingStrategy
}
