//
//  IssueViewController.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/14.
//

import ReactorKit
import RxAppState

enum NetworkError: Error {
    case fetchIssues
}

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
        case fetchIssues(Result<[Issue]?, NetworkError>)
    }
    
    struct State {
        var loadedIssues: [Issue]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadIssues:
            issueProvider
                .requestIssues()
                .subscribe({ response in
                    switch response {
                    case .success(let issues):
                        return Mutation.fetchIssues(.success(issues))
                    case .failure(let error):
                        return Mutation.fetchIssues(.failure(.fetchIssues))
                    }
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchIssue(let issue):
            print("issue \(issue.title)")
            newState.issue = issue
        return newState
    }
    
}

final class IssueViewController: UIViewController, View, DependencySetable {
    
    typealias DependencyType = IssueDependency
    
    var dependency: IssueDependency? {
        didSet {
            self.reactor = dependency?.manager
        }
    }
    
    var disposeBag = DisposeBag()
    static let id = "IssueViewController"
    let coordinator: Coordinator
    private lazy var issueView = IssueView(frame: view.frame)
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        DependencyInjector.shared.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        tabBarItem.title = "이슈"
        tabBarItem.image = UIImage(systemName: "pencil")
    }
    
    func bind(reactor: IssueReactor) {
        view = issueView
        
        rx.viewDidLoad
            .map { Reactor.Action.loadIssues }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

struct IssueDependency: Dependency {
    typealias ManagerType = IssueReactor
    let manager: ManagerType
}
