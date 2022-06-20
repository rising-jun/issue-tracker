//
//  GithubAPI.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/13.
//

import Moya

enum GithubAPI {
    
    private var clientID: String {
        return Bundle.main.object(forInfoDictionaryKey: "Client_ID") as? String ?? ""
    }
    private var clientSecret: String {
        return Bundle.main.object(forInfoDictionaryKey: "Client_Secret") as? String ?? ""
    }
    
    case exchangeToken(String)
    case requestIssueList
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://github.com")!
    }
    
    var path: String {
        switch self {
        case .exchangeToken(_):
            return "/login/oauth/access_token"
        case .requestIssueList:
            return "/repos/rising-jun/issue-tracker/issues"
        }
    }
    
    var method: Method {
        switch self {
        case .exchangeToken(_):
            return .post
        case .requestIssueList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .exchangeToken(let code):
            let params: [String: Any] = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": code
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .requestIssueList:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .exchangeToken(_):
            guard let json = Bundle.main.path(forResource: "MockAccessToken", ofType: "json") else { return Data() }
            guard let jsonString = try? String(contentsOfFile: json) else { return Data() }
            guard let mockData = jsonString.data(using: .utf8) else { return Data() }
            return mockData
        case .requestIssueList: //코드 중복
            guard let json = Bundle.main.path(forResource: "MockIssueList", ofType: "json") else { return Data() }
            guard let jsonString = try? String(contentsOfFile: json) else { return Data() }
            guard let mockData = jsonString.data(using: .utf8) else { return Data() }
            return mockData
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .exchangeToken(_):
//            var header = ["Content-Type": "application/json"]
//            header["Accept"] = "application/json"
//            return header
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        case .requestIssueList:
            return ["Accept": "application/vnd.github.v3+json"]
        }
    }
}
