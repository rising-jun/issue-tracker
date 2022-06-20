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
            .debug()
            .subscribe { response in
                print("success \(String(data: response.data, encoding: .utf8))")
            } onFailure: { error in
                print("error \(error)")
            }
        return nil
    }
}
