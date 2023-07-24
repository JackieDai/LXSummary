import Foundation

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
/// 用来定义 MoyaProvider 所需要的数据 格式
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// Provides stub data for use in testing. Default is `Data()`.
    /// 样例数据，一般用来测试
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    ///  HTTP 的task
    var task: Task { get }

    /// The type of validation to perform on the request. Default is `.none`.
    /// 状态吗 Represents the status codes to validate through Alamofire.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

public extension TargetType {

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { .none }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data { Data() }
}
