//
//  GithubIssueRepository.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import RxSwift
import Moya

protocol GitHubIssueRequestable {
    var provider: MoyaProvider<GithubAPI> { get }
    func requestIssues() -> Single<Issue>
}

final class GithubIssueRepository: GitHubIssueRequestable {
    var provider = MoyaProvider<GithubAPI>()
    
    func requestIssues() -> Single<Issue> {
        provider.rx
            .request(.requestIssueList)
            .map(Issue.self)
            .do { issue in
                print(issue)
            } onError: { error in
                print(error)
            }
    }
}
