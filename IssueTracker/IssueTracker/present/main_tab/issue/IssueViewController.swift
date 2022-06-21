//
//  IssueViewController.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/14.
//

import ReactorKit
import RxAppState

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
    lazy var issueView = IssueView(frame: view.frame)
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        DependencyInjector.shared.injecting(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(reactor: IssueReactor) {
        view = issueView
        issueView.tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.loadIssues }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.setViewProperty }
        .distinctUntilChanged()
        .compactMap { $0 }
        .filter { $0 }
        .bind { [weak self] _ in
            guard let self = self else { return }
            self.setupUI()
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.loadedIssues }
        .compactMap { $0 }
        .take(1)
        .bind(to: issueView.tableView.rx.items(cellIdentifier: IssueTableViewCell.identifier, cellType: IssueTableViewCell.self)) {
            _, issue, cell in
            print("issue \(issue.title)")
            cell.bindViewProperty(issue: issue)
        }
        .disposed(by: disposeBag)
    }
}

extension IssueViewController {
    private func setupUI() {
        print("asdf")
        tabBarItem.title = "이슈"
        tabBarItem.image = UIImage(systemName: "pencil")
    }
}

struct IssueDependency: Dependency {
    typealias ManagerType = IssueReactor
    let manager: ManagerType
}
