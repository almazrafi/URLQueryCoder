import Foundation

internal protocol URLQueryValueResolver {

    func resolveValue() -> URLQueryValue?
}
