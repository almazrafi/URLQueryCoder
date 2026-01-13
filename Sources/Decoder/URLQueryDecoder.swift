import Foundation

public final class URLQueryDecoder: Sendable {

    public static let `default` = URLQueryDecoder()

    private let optionsMutex: Mutex<URLQueryDecodingOptions>
    private let userInfoMutex: Mutex<[CodingUserInfoKey: Sendable]>

    public var dateDecodingStrategy: URLQueryDateDecodingStrategy {
        get { optionsMutex.withLock { $0.dateDecodingStrategy } }
        set { optionsMutex.withLock { $0.dateDecodingStrategy = newValue } }
    }

    public var dataDecodingStrategy: URLQueryDataDecodingStrategy {
        get { optionsMutex.withLock { $0.dataDecodingStrategy } }
        set { optionsMutex.withLock { $0.dataDecodingStrategy = newValue } }
    }

    public var nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy {
        get { optionsMutex.withLock { $0.nonConformingFloatDecodingStrategy } }
        set { optionsMutex.withLock { $0.nonConformingFloatDecodingStrategy = newValue } }
    }

    public var keyDecodingStrategy: URLQueryKeyDecodingStrategy {
        get { optionsMutex.withLock { $0.keyDecodingStrategy } }
        set { optionsMutex.withLock { $0.keyDecodingStrategy = newValue } }
    }

    public var userInfo: [CodingUserInfoKey: Sendable] {
        get { userInfoMutex.withLock { $0 } }
        set { userInfoMutex.withLock { $0 = newValue } }
    }

    public init(
        dateDecodingStrategy: URLQueryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: URLQueryDataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: URLQueryNonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: URLQueryKeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Sendable] = [:]
    ) {
        let options = URLQueryDecodingOptions(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy
        )

        self.optionsMutex = Mutex(value: options)
        self.userInfoMutex = Mutex(value: userInfo)
    }

    public func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from query: String
    ) throws -> T {
        let options = optionsMutex.withLock { $0 }

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

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public func decode<T: DecodableWithConfiguration>(
        _ type: T.Type = T.self,
        from query: String,
        configuration: T.DecodingConfiguration
    ) throws -> T {
        let options = optionsMutex.withLock { $0 }

        let deserializer = URLQueryDeserializer()
        let value = try deserializer.deserialize(query)

        let decoder = URLQuerySingleValueDecodingContainer(
            value: value,
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        return try T(from: decoder, configuration: configuration)
    }
}
