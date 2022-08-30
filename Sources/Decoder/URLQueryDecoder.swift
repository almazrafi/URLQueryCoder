import Foundation

public struct URLQueryDecoder {

    public static let `default` = URLQueryDecoder()

    public var dateDecodingStrategy: URLQueryDateDecodingStrategy
    public var dataDecodingStrategy: URLQueryDataDecodingStrategy
    public var nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy
    public var keyDecodingStrategy: URLQueryKeyDecodingStrategy
    public var userInfo: [CodingUserInfoKey: Any]

    public init(
        dateDecodingStrategy: URLQueryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: URLQueryDataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: URLQueryKeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.userInfo = userInfo
    }

    public func decode<T: Decodable>(
        _ type: T.Type,
        from query: String
    ) throws -> T {
        let options = URLQueryDecodingOptions(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy
        )

        let deserializer = URLQueryDeserializer()
        let value = try deserializer.deserialize(query)

        let decoder = URLQuerySingleValueDecodingContainer(
            value: value,
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        return try T(from: decoder)
    }
}
