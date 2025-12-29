import Foundation

public enum URLQueryNonConformingFloatEncodingStrategy: Sendable {

    case `throw`
    case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
}
