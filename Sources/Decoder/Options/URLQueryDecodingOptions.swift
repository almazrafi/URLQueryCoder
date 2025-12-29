import Foundation

internal struct URLQueryDecodingOptions {

    internal var dateDecodingStrategy: URLQueryDateDecodingStrategy
    internal var dataDecodingStrategy: URLQueryDataDecodingStrategy
    internal var nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy
    internal var keyDecodingStrategy: URLQueryKeyDecodingStrategy
}
