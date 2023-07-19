//
//  NetworkRequestError.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/18.
//

import Foundation
import Alamofire

enum SeverError {
    /// General purpose connection error except for timeout, which should be assigned to httpTimeoutError
    case httpGeneric(_ error: AFError)
    case httpTimeout
    /// result or result.code is nil
    case invalidResult
    /// result.code is not 0 nor any accepted
    case invalidCode(_ code: Int)
    case serverGeneric

    public var code: Int {
        switch self {
        case .httpGeneric:
            return -1

        case .httpTimeout:
            return -2

        case .invalidResult:
            return -3

        case .invalidCode(let code):
            return code

        case .serverGeneric:
            return -4
        }
    }
}

// MARK: - NetworkRequestError
enum NetworkRequestError: Error, LocalizedError {

    case noInternetConnection

    case timeOut

    case invalidRequest(errorMessage: String)

    case invalidResponse(httpCode: Int, errorMessage: String)

    /// Client errors (4xx) (e.g. validation errors, insufficient access rights, etc.)
    case clientError(httpCode: Int, errorMessage: String, responseData: Data? = nil)

    /// Server errors (5xx) (e.g. server crash, responses timing out, etc.)
    case serverError(httpCode: Int, errorMessage: String)

    case parseError(errorMessage: String, error: Error)

    case volvoServerError(_ error: SeverError, _ message: String? = nil)

    case volvoRetryError

    case custom(error: Error)

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No connection"
        case .timeOut:
            return "Network timeout"
        case .invalidRequest(let errorMessage):
            return "Invalid request, error: \(errorMessage)"
        case .invalidResponse(_, let errorMessage):
            return "Invalid response, error: \(errorMessage)"
        case .clientError(_, let errorMessage, _):
            return "Network error: \(errorMessage)"
        case .serverError(_, let errorMessage):
            return "\(errorMessage)"
        case .parseError(let errorMessage, _):
            return "Failed to parse response data, error: \(errorMessage)"
        case .volvoServerError(let error, let message):
            return "\(message ?? "''") (Error Code: \(error.code))"
        case .volvoRetryError:
            return "Retry VOLVO server request!"
        case .custom(let error):
            return "\(error.localizedDescription)"
        }
    }
}
