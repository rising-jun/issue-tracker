//
//  AppCoordinator.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/17.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [String: Coordinator] { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var childCoordinators = [String: Coordinator]()
    var navigationController: UINavigationController?
    let presentViewController: SceneType
    
    init(navigationController: UINavigationController, presentViewController: SceneType) {
        self.navigationController = navigationController
        self.presentViewController = presentViewController
        
        setChildCoordinators()
    }
    
    func start() {
        var viewController: UIViewController
        guard let navigationController = navigationController else { return }
        switch presentViewController {
        case .login:
            viewController = LoginViewController()
        case .tabbar:
            navigationController.popViewController(animated: false)
            guard let tabBarController = makeTabBarController() else { return }
            viewController = tabBarController
        case .issue: return
        case .label: return
        }
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    private func setChildCoordinators() {
        guard let navigationController = navigationController else { return }
        childCoordinators[IssueViewController.id] = IssueCoordinator(navigationController: navigationController)
        childCoordinators[LabelViewController.id] = LabelCoordinator(navigationController: navigationController)
    }
    
    private func makeTabBarController() -> UITabBarController? {
        let tabBarController = UITabBarController()
        guard let issueCoordinate = childCoordinators[IssueViewController.id] else { return nil }
        guard let issueViewController = SceneType.issue.makeViewController() as? IssueViewController else { return nil }
        issueViewController.coordinator = issueCoordinate

        guard let labelCoordinate = childCoordinators[LabelViewController.id] else { return nil }
        guard let labelViewController = SceneType.label.makeViewController() as? LabelViewController else { return nil }
        labelViewController.coordinator = labelCoordinate
        
        let milestoneViewController = UIViewController()
        milestoneViewController.tabBarItem.title = "마일스톤"
        milestoneViewController.tabBarItem.image = UIImage(systemName: "pencil")

        let accountViewController = UIViewController()
        accountViewController.tabBarItem.title = "내 계정"
        accountViewController.tabBarItem.image = UIImage(systemName: "pencil")

        tabBarController.viewControllers = [
            issueViewController, labelViewController, milestoneViewController, accountViewController
        ]
        return tabBarController
    }
}
