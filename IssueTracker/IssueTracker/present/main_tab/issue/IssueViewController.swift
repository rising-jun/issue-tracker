//
//  IssueViewController.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/14.
//

import ReactorKit

final class IssueReactor: Reactor {
    
    var initialState = State()
    private let issueProvider: GitHubIssueRequestable
    
    init(issueProvider: GitHubIssueRequestable) {
        self.issueProvider = issueProvider
    }
    
    enum Action {
        case buttonTapped
    }
    
    enum Mutation {
        case fetchData
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .buttonTapped:
            issueProvider
                .requestIssues()
                .asObservable()
            return Observable.just(Mutation.fetchData)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .fetchData:
            break
        }
        return state
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
        
        issueView.button.rx
            .tap
            .map { Reactor.Action.buttonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

struct IssueDependency: Dependency {
    typealias ManagerType = IssueReactor
    let manager: ManagerType
}
