//
//  IssueReactor.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/21.
//

import ReactorKit

final class IssueReactor: Reactor {
    var initialState = State()
    private let issueProvider: GitHubIssueRequestable
    
    init(issueProvider: GitHubIssueRequestable) {
        self.issueProvider = issueProvider
    }
    
    enum Action {
        case loadIssues
    }
    
    enum Mutation {
        case fetchIssues([Issue])
        case updateViewProperty(Bool)
    }
    
    struct State {
        var loadedIssues: [Issue]?
        var setViewProperty: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadIssues:
            return Observable.concat( [issueProvider
                                        .requestIssues()
                                        .map { Mutation.fetchIssues($0) },
                                       Observable.just(Mutation.updateViewProperty(true))] )
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchIssues(let issues):
            newState.loadedIssues = issues
        case .updateViewProperty(let setState):
            newState.setViewProperty = setState
        }
        return newState
    }
}
