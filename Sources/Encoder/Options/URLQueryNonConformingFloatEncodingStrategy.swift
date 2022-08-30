import Foundation

public enum URLQueryNonConformingFloatEncodingStrategy {

    case `throw`
    case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
}
