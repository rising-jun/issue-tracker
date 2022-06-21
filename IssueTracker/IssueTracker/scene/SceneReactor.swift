//
//  LoginReactor.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/13.
//

import ReactorKit
import RxSwift
import RxCocoa

final class SceneReactor: Reactor {
    var initialState: State = State()
    init (tokenProvider: GitHubTokenExchangable) {
        self.tokenProvider = tokenProvider
    }
    
    private let tokenProvider: GitHubTokenExchangable
    
    enum Action {
        case checkRootViewController
        case inputUserCode(String)
    }
    
    enum Mutating {
        case updateRootViewController(SceneType)
        case updateAccessTokenState(Bool)
    }
    
    struct State {
        var rootViewController: SceneType?
        var hasToken: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutating> {
        switch action {
        case .inputUserCode(let code):
            return tokenProvider
                .exchangeToken(by: code)
                .do { accessToken in
                    UserDefaultManager.shared.save(accessToken: accessToken)
                }
                .map { _ in
                    return Mutating.updateAccessTokenState(!UserDefaultManager.shared.getAccessToken().isEmpty)
                }
            
        case .checkRootViewController:
            return Observable.just(checkRootViewController())
                .map { Mutating.updateRootViewController($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutating) -> State {
        var newState = state
        switch mutation {
        case .updateRootViewController(let viewControllerType):
            newState.rootViewController = viewControllerType
        case .updateAccessTokenState(let tokenResult):
            newState.hasToken = tokenResult
        }
        return newState
    }
}

extension SceneReactor {
    private func checkRootViewController() -> SceneType {
        (UserDefaultManager.shared.getAccessToken().isEmpty) ? SceneType.login : SceneType.tabbar
    }
}
