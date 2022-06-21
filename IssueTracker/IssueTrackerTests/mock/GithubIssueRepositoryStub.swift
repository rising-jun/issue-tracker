//
//  GithubRepositoryStub.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/21.
//

import Moya
import RxSwift
@testable import IssueTracker

class GithubIssueRepositoryStub: GitHubIssueRequestable {
    var provider = MoyaProvider<GithubAPI>(stubClosure: MoyaProvider.immediatelyStub)

    func requestIssues() -> Observable<[Issue]> {
        provider.rx
            .request(.requestIssueList)
            .filterSuccessfulStatusCodes()
            .map([Issue].self)
            .asObservable()
    }
}
