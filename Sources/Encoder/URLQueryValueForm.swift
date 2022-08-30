import Foundation

internal indirect enum URLQueryValueForm {

    case value(URLQueryValue?)
    case resolver(URLQueryValueResolver)

    internal func resolveValue() -> URLQueryValue? {
        switch self {
        case .value(let value):
            return value

        case .resolver(let resolver):
            return resolver.resolveValue()
        }
    }
}
