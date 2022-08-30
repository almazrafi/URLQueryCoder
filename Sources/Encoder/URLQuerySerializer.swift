import Foundation

internal final class URLQuerySerializer {

    internal let arrayEncodingStrategy: URLQueryArrayEncodingStrategy
    internal let spaceEncodingStrategy: URLQuerySpaceEncodingStrategy

    internal init(
        arrayEncodingStrategy: URLQueryArrayEncodingStrategy,
        spaceEncodingStrategy: URLQuerySpaceEncodingStrategy
    ) {
        self.arrayEncodingStrategy = arrayEncodingStrategy
        self.spaceEncodingStrategy = spaceEncodingStrategy
    }

    private func escapeString(_ string: String) -> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        allowedCharacters.remove(charactersIn: .urlQueryDelimiters)
        allowedCharacters.insert(charactersIn: .space)

        let escapedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? string

        switch spaceEncodingStrategy {
        case .percentEscaped:
            return escapedString.replacingOccurrences(
                of: String.space,
                with: String.urlPercentEscapedSpace
            )

        case .plusReplaced:
            return escapedString.replacingOccurrences(
                of: String.space,
                with: String.urlPlusReplacedSpace
            )
        }
    }

    private func serializeString(_ string: String, at key: String) -> String {
        "\(key)=\(escapeString(string))"
    }

    private func serializeArray(_ array: [Int: URLQueryValue], at key: String) -> String {
        let array = array.sorted { lhs, rhs in
            lhs.key < rhs.key
        }

        switch arrayEncodingStrategy {
        case .enumerated:
            return array
                .map { serializeValue($0.value, key: "\(key)[\($0.key)]") }
                .joined(separator: .urlQuerySeparator)

        case .unenumerated:
            return array
                .map { serializeValue($0.value, key: "\(key)[]") }
                .joined(separator: .urlQuerySeparator)
        }
    }

    private func serializeDictionary(_ dictionary: [String: URLQueryValue], at key: String) -> String {
        dictionary
            .map { serializeValue($0.value, key: "\(key)[\(escapeString($0.key))]") }
            .joined(separator: .urlQuerySeparator)
    }

    private func serializeValue(_ value: URLQueryValue, key: String) -> String {
        switch value {
        case let .string(string):
            return serializeString(string, at: key)

        case let .array(array):
            return serializeArray(array, at: key)

        case let .dictionary(dictionary):
            return serializeDictionary(dictionary, at: key)
        }
    }

    internal func serialize(_ query: [String: URLQueryValue]) -> String {
        query
            .map { serializeValue($0.value, key: escapeString($0.key)) }
            .joined(separator: .urlQuerySeparator)
    }
}
