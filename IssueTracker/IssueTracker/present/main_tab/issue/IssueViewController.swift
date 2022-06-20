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
        case fetchData(Issue)
        case none
    }
    
    struct State {
        var issue: Issue?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .buttonTapped:
            issueProvider.requestIssues()?.subscribe({ singleIssue in
                switch singleIssue {
                case .success(let issue):
                    print("issue success \(issue)")
                case .failure(let error):
                    print("error \(error)")
                }
            })
            
            return Observable.just(Mutation.none)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchData(let issue):
            print("issue \(issue.title)")
            newState.issue = issue
        case .none:
            break
        }
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
