//
//  URLBuilder.swift
//  LXSummary
//
//  Created by LingXiao Dai on 2023/7/18.
//

import Foundation

enum URLEntry {
    case weatherInfo
}

extension URLEntry {
    func idValue() -> String {
        switch self {
        case .weatherInfo:
            return "weather/weatherInfo"
        }
    }
}

struct URLBuilder {
    static func getURLPath(for urlEntry: URLEntry) -> String {
        urlEntry.idValue()
    }

    static func getPercentEncodedText(_ text: String) -> String {
        return text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
