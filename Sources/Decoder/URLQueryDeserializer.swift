import Foundation

internal final class URLQueryDeserializer {

    internal init() { }

    private func deserializeKey(_ key: Substring) throws -> [String] {
        guard let percentDecodedKey = key.removingPercentEncoding else {
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: "The key '\(key)' contains an invalid percent-encoding sequence."
            )

            throw DecodingError.dataCorrupted(context)
        }

        return try percentDecodedKey
            .split(separator: .leftSquareBracket)
            .enumerated()
            .map { index, part in
                if part.last == .rightSquareBracket {
                    return String(part.dropLast())
                } else if key.first != .leftSquareBracket, index == .zero {
                    return String(part)
                }

                let context = DecodingError.Context(
                    codingPath: [],
                    debugDescription: "The key '\(key)' does not contain a closing separator ']'."
                )

                throw DecodingError.dataCorrupted(context)
            }
    }

    private func deserializeStringValue(
        _ fragmentValue: Substring,
        path: [String]
    ) throws -> URLQueryValue {
        guard let decodedValue = fragmentValue.removingPercentEncoding else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Unable to remove percent encoding for '\(fragmentValue)'."
                )
            )
        }

        return .string(String(decodedValue))
    }

    private func deserializeArrayValue(
        _ fragmentValue: Substring,
        at keyIndex: Int,
        of path: [String],
        for array: [Int: URLQueryValue]
    ) throws -> URLQueryValue {
        let key = path[keyIndex]

        guard let index = key.isEmpty ? array.count : Int(key) else {
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: "The key '\(path)' does not contain index of the '\(key)' array."
            )

            throw DecodingError.dataCorrupted(context)
        }

        let array = array.updatingValue(
            try deserializeValue(
                fragmentValue,
                at: keyIndex + 1,
                of: path,
                for: array[index]
            ),
            forKey: index
        )

        return .array(array)
    }

    private func deserializeDictionaryValue(
        _ fragmentValue: Substring,
        at keyIndex: Int,
        of path: [String],
        for dictionary: [String: URLQueryValue]
    ) throws -> URLQueryValue {
        let key = path[keyIndex]

        let dictionary = dictionary.updatingValue(
            try deserializeValue(
                fragmentValue,
                at: keyIndex + 1,
                of: path,
                for: dictionary[key]
            ),
            forKey: key
        )

        return .dictionary(dictionary)
    }

    private func deserializeValue(
        _ fragmentValue: Substring,
        at keyIndex: Int,
        of path: [String],
        for value: URLQueryValue?
    ) throws -> URLQueryValue {
        switch value {
        case nil where keyIndex >= path.count:
            return try deserializeStringValue(fragmentValue, path: path)

        case nil where path[keyIndex].isEmpty || Int(path[keyIndex]) != nil:
            return try deserializeArrayValue(
                fragmentValue,
                at: keyIndex,
                of: path,
                for: [:]
            )

        case nil:
            return try deserializeDictionaryValue(
                fragmentValue,
                at: keyIndex,
                of: path,
                for: [:]
            )

        case .array(let array) where keyIndex < path.count:
            return try deserializeArrayValue(
                fragmentValue,
                at: keyIndex,
                of: path,
                for: array
            )

        case .dictionary(let dictionary) where keyIndex < path.count:
            return try deserializeDictionaryValue(
                fragmentValue,
                at: keyIndex,
                of: path,
                for: dictionary
            )

        default:
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: "The key '\(path)' is used for values of different types."
            )

            throw DecodingError.dataCorrupted(context)
        }
    }

    private func deserializeFragment(
        _ fragment: Substring,
        for value: URLQueryValue?
    ) throws -> URLQueryValue {
        let keyValue = fragment.split(
            separator: .equals,
            maxSplits: 1,
            omittingEmptySubsequences: false
        )

        let path = try deserializeKey(keyValue[0])

        guard let fragmentValue = keyValue[safe: 1] else {
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: "Value for key '\(path)' is missing or invalid."
            )

            throw DecodingError.dataCorrupted(context)
        }

        return try deserializeValue(
            fragmentValue,
            at: .zero,
            of: path,
            for: value
        )
    }

    internal func deserialize(_ query: String) throws -> URLQueryValue {
        try query
            .replacingOccurrences(
                of: String.urlPlusReplacedSpace,
                with: String.urlPercentEscapedSpace
            )
            .split(separator: .ampersand)
            .reduce(nil) { query, fragment in
                try deserializeFragment(fragment, for: query)
            } ?? .dictionary([:])
    }
}