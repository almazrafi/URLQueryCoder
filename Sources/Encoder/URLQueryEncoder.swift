import Foundation

public final class URLQueryEncoder: Sendable {

    public static let `default` = URLQueryEncoder()

    private let optionsMutex: Mutex<URLQueryEncodingOptions>
    private let userInfoMutex: Mutex<[CodingUserInfoKey: Sendable]>

    public var dateEncodingStrategy: URLQueryDateEncodingStrategy {
        get { optionsMutex.withLock { $0.dateEncodingStrategy } }
        set { optionsMutex.withLock { $0.dateEncodingStrategy = newValue } }
    }

    public var dataEncodingStrategy: URLQueryDataEncodingStrategy {
        get { optionsMutex.withLock { $0.dataEncodingStrategy } }
        set { optionsMutex.withLock { $0.dataEncodingStrategy = newValue } }
    }

    public var nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy {
        get { optionsMutex.withLock { $0.nonConformingFloatEncodingStrategy } }
        set { optionsMutex.withLock { $0.nonConformingFloatEncodingStrategy = newValue } }
    }

    public var boolEncodingStrategy: URLQueryBoolEncodingStrategy {
        get { optionsMutex.withLock { $0.boolEncodingStrategy } }
        set { optionsMutex.withLock { $0.boolEncodingStrategy = newValue } }
    }

    public var arrayEncodingStrategy: URLQueryArrayEncodingStrategy {
        get { optionsMutex.withLock { $0.arrayEncodingStrategy } }
        set { optionsMutex.withLock { $0.arrayEncodingStrategy = newValue } }
    }

    public var spaceEncodingStrategy: URLQuerySpaceEncodingStrategy {
        get { optionsMutex.withLock { $0.spaceEncodingStrategy } }
        set { optionsMutex.withLock { $0.spaceEncodingStrategy = newValue } }
    }

    public var keyEncodingStrategy: URLQueryKeyEncodingStrategy {
        get { optionsMutex.withLock { $0.keyEncodingStrategy } }
        set { optionsMutex.withLock { $0.keyEncodingStrategy = newValue } }
    }

    public var userInfo: [CodingUserInfoKey: Sendable] {
        get { userInfoMutex.withLock { $0 } }
        set { userInfoMutex.withLock { $0 = newValue } }
    }

    public init(
        dateEncodingStrategy: URLQueryDateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: URLQueryDataEncodingStrategy = .base64,
        nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy = .throw,
        boolEncodingStrategy: URLQueryBoolEncodingStrategy = .literal,
        arrayEncodingStrategy: URLQueryArrayEncodingStrategy = .enumerated,
        spaceEncodingStrategy: URLQuerySpaceEncodingStrategy = .percentEscaped,
        keyEncodingStrategy: URLQueryKeyEncodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Sendable] = [:]
    ) {
        let options = URLQueryEncodingOptions(
            dateEncodingStrategy: dateEncodingStrategy,
            dataEncodingStrategy: dataEncodingStrategy,
            nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
            boolEncodingStrategy: boolEncodingStrategy,
            arrayEncodingStrategy: arrayEncodingStrategy,
            spaceEncodingStrategy: spaceEncodingStrategy,
            keyEncodingStrategy: keyEncodingStrategy
        )

        self.optionsMutex = Mutex(value: options)
        self.userInfoMutex = Mutex(value: userInfo)
    }

    public func encode<T: Encodable>(_ value: T) throws -> String {
        let options = optionsMutex.withLock { $0 }

        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        try value.encode(to: encoder)

        guard case let .dictionary(urlEncodedForm) = encoder.resolveValue() else {
            let errorContext = EncodingError.Context(
                codingPath: [],
                debugDescription: "Root component cannot be encoded in URL"
            )

            throw EncodingError.invalidValue(value, errorContext)
        }

        let serializer = URLQuerySerializer(
            arrayEncodingStrategy: arrayEncodingStrategy,
            spaceEncodingStrategy: spaceEncodingStrategy
        )

        return serializer.serialize(urlEncodedForm)
    }
}
