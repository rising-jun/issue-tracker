//
//  LabelReactor.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/23.
//

import ReactorKit

final class LabelReactor: Reactor {
    var initialState = State()
    private let labelProvider: GitHubLabelRequestable
    
    init(labelProvider: GitHubLabelRequestable) {
        self.labelProvider = labelProvider
    }
    
    enum Action {
        case loadLabels
    }
    
    enum Mutation {
        case fetchLabels([Label])
        case updateViewProperty(Bool)
    }
    
    struct State {
        var loadedLabels: [Label]?
        var setViewProperty: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadLabels:
            return labelProvider.requestLabels()
                .flatMap { Observable.concat( [Observable.just(Mutation.updateViewProperty(true)),
                                               Observable.just(Mutation.fetchLabels($0))]) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchLabels(let labels):
            newState.loadedLabels = labels
        case .updateViewProperty(let ready):
            newState.setViewProperty = ready
        }
        return newState
    }
}
