//
//  Token.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/16.
//

import Foundation

struct Token: Decodable {
    let accessToken: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
