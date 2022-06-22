//
//  DependencyInjector.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/16.
//

import Foundation

final class DependencyInjector {
    static let shared = DependencyInjector()
    
    private lazy var dependencyDictionary: [ObjectIdentifier: Any] = [
        ObjectIdentifier(SceneDelegate.self): SceneDependency(manager: SceneReactor(tokenProvider: GithubTokenRepository())),
        ObjectIdentifier(LoginViewController.self): LoginDependency(manager: LoginReactor()),
        ObjectIdentifier(IssueViewController.self): IssueDependency(manager: IssueReactor(issueProvider: GithubIssueRepository()))
    ]
    
    func injecting<T: DependencySetable>(to compose: T) {
        guard let dependency = dependencyDictionary[ObjectIdentifier(type(of: compose.self))],
              let detailedDependency = dependency as? T.DependencyType else {
            return
        }
        compose.setDependency(dependency: detailedDependency)
    }
}

protocol DependencySetable: AnyObject {
    associatedtype DependencyType
    var dependency: DependencyType? { get set }
}
extension DependencySetable {
    func setDependency(dependency: DependencyType) {
        self.dependency = dependency
    }
}

protocol Dependency {
    associatedtype ManagerType
}
