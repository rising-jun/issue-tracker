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
    var coordinator: Coordinator?
    lazy var issueView = IssueView(frame: view.frame)
    private var lastContentOffset: CGFloat = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        DependencyInjector.shared.injecting(to: self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(reactor: IssueReactor) {
        view = issueView
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "issue"
        
        issueView.tableView.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.loadIssues }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.setViewProperty }
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
        }.disposed(by: disposeBag)
    
        issueView.tableView.rx
            .didScroll
            .map { [unowned self] _ in
                Reactor.Action.tableDidScroll(self.isScrollTop())
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isTableTop }
        .distinctUntilChanged()
        .compactMap { $0 }
        .bind { [weak self] isTableTop in
            guard let self = self else { return }
            isTableTop ? self.issueView.setSearchBarVisible() : self.issueView.setSearchBarInVisible()
        }
        .disposed(by: disposeBag)
        
    }
}

extension IssueViewController {
    private func isScrollTop() -> Bool {
        return issueView.tableView.contentOffset.y <= 0
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.topItem?.title = "이슈"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
    }
}

struct IssueDependency: Dependency {
    typealias ManagerType = IssueReactor
    let manager: ManagerType
}
