//
//  GithubRepositoryStub.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/14.
//

import Moya
import RxSwift
@testable import IssueTracker

class GithubTokenRepositoryStub: GitHubTokenExchangable {
    var provider = MoyaProvider<GithubAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    func exchangeToken(by code: String) -> Observable<String> {
        provider.rx
            .request(.exchangeToken(code))
            .map(Token.self)
            .map { $0.accessToken }
            .asObservable()
    }
}
