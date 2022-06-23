//
//  LabelViewController.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/23.
//

import UIKit
import ReactorKit
import RxAppState

final class LabelViewController: UIViewController, View, DependencySetable {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        DependencyInjector.shared.injecting(to: self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var dependency: LabelDependency? {
        didSet {
            self.reactor = dependency?.manager
        }
    }
    
    var disposeBag = DisposeBag()
    static var id: String {
        return "\(self)"
    }
    var coordinator: Coordinator?
    lazy var labelView = LabelView(frame: view.frame)
    
    func bind(reactor: LabelReactor) {
        view = labelView
        
        rx.viewWillAppear.map { _ in return Reactor.Action.loadLabels}
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.setViewProperty }
        .compactMap { $0 }
        .distinctUntilChanged()
        .filter { $0 }
        .bind { [weak self] _ in
            guard let self = self else { return }
            self.setupUI()
        }
        .disposed(by: disposeBag)
    }
}
extension LabelViewController {
    private func setupUI() {
//        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .white
//        navigationBar.standardAppearance = appearance
//        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationBar.topItem?.title = "asdf"
    }
}
struct LabelDependency: Dependency {
    typealias ManagerType = LabelReactor
    var manager: ManagerType
}
