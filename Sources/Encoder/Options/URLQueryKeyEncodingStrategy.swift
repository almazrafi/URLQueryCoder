import Foundation

public enum URLQueryKeyEncodingStrategy: Sendable {

    case useDefaultKeys
    case custom(@Sendable (_ codingPath: [CodingKey]) -> CodingKey)
}
