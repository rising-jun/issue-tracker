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
    private var lastContentOffset: CGFloat = 0
    
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
        .bind(to: issueView.tableView.rx.items(cellIdentifier: IssueTableViewCell.identifier,
                                               cellType: IssueTableViewCell.self)) {
            _, issue, cell in
            cell.configureCell(with: issue)
            
            cell.bindViewProperty(issue: issue)
        }
        .disposed(by: disposeBag)
        
        issueView.tableView.rx
            .itemSelected
            // Reactor 바인딩하기
        issueView.tableView.rx
            .didScroll
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.didScroll()
            }
    }
}

extension IssueViewController {
    private func setupUI() {
        tabBarItem.title = "이슈"
        tabBarItem.image = UIImage(systemName: "pencil")
    }
    
    private func didScroll() {
        let scrollView = issueView.tableView
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
                if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < bottomOffset.y {
                    if (self.lastContentOffset > scrollView.contentOffset.y) {
                        // scroll up
                        print("scroll up")
                    }
                    else if (self.lastContentOffset < scrollView.contentOffset.y) {
                        // scroll down
                        print("scroll down")
                    }
                    self.lastContentOffset = scrollView.contentOffset.y
                }
    }
}

struct IssueDependency: Dependency {
    typealias ManagerType = IssueReactor
    let manager: ManagerType
}
