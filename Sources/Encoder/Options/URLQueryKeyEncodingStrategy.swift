import Foundation

public enum URLQueryKeyEncodingStrategy {

    case useDefaultKeys
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
}
