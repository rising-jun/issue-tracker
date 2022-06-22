//
//  GithubTokenProvider.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/13.
//

import RxSwift
import Moya

protocol GitHubTokenExchangable {
    var provider: MoyaProvider<GithubAPI> { get }
    func exchangeToken(by code: String) -> Observable<String>
}

final class GithubTokenRepository: GitHubTokenExchangable {
    var provider = MoyaProvider<GithubAPI>()
    
    func exchangeToken(by code: String) -> Observable<String> {
        provider.rx
            .request(.exchangeToken(code))
            .map(Token.self)
            .map { $0.accessToken }
            .asObservable()
    }
}
