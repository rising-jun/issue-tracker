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
    func requestIssues() -> Observable<[Issue]>
}

final class GithubIssueRepository: GitHubIssueRequestable {
    var provider = MoyaProvider<GithubAPI>()
    
    func requestIssues() -> Observable<[Issue]> {
        provider.rx
            .request(.requestIssueList)
            .filterSuccessfulStatusCodes()
            .map([Issue].self)
            .asObservable()
    }
}
