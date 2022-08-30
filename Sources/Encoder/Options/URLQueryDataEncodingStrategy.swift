import Foundation

public enum URLQueryDataEncodingStrategy {

    case deferredToData
    case base64
    case custom((_ data: Data, _ encoder: Encoder) throws -> Void)
}
