//
//  GithubLabelRepository.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/23.
//

import RxSwift
import Moya

protocol GitHubLabelRequestable {
    var provider: MoyaProvider<GithubAPI> { get }
    func requestLabels() -> Observable<[Label]>
}

final class GithubLabelRepository: GitHubLabelRequestable {
    var provider = MoyaProvider<GithubAPI>()
    
    func requestLabels() -> Observable<[Label]> {
        provider.rx
            .request(.requestLabelList)
            .filterSuccessfulStatusCodes()
            .map([Label].self)
            .asObservable()
    }
}
