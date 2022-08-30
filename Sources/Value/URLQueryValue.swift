import Foundation

internal enum URLQueryValue {

    case string(String)
    indirect case array([Int: URLQueryValue])
    indirect case dictionary([String: URLQueryValue])

    internal var string: String? {
        switch self {
        case let .string(string):
            return string

        default:
            return nil
        }
    }

    internal var array: [Int: URLQueryValue]? {
        switch self {
        case let .array(array):
            return array

        default:
            return nil
        }
    }

    internal var dictionary: [String: URLQueryValue]? {
        switch self {
        case let .dictionary(dictionary):
            return dictionary

        default:
            return nil
        }
    }
}
