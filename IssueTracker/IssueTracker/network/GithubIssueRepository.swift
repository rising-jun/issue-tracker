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
    func requestIssues() -> Single<Issue>?
}

final class GithubIssueRepository: GitHubIssueRequestable {
    var provider = MoyaProvider<GithubAPI>()
    
    func requestIssues() -> Single<Issue>? {
        print("hello")
        provider.rx
            .request(.requestIssueList)
            .filterSuccessfulStatusCodes()
            .map([Issue].self)
            .subscribe { issues in
                issues.forEach { issue in
                    print(issue.title)
                    issue.labels.forEach { label in
                        print(label.name)
                    }
                    print(issue.milestone?.title)
                    print(issue.body)
                }
            } onFailure: { error in
                print(error)
            }
        return nil
    }
}
