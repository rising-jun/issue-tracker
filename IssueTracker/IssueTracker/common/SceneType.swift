//
//  ViewControllerType.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/14.
//

import UIKit

enum SceneType {
    case login
    case tabbar
    case issue
    case label
    
    func makeViewController() -> UIViewController {
        switch self {
        case .login:
            return UIViewController()
        case .tabbar:
            return UIViewController()
        case .issue:
            let issueViewController = IssueViewController()
            issueViewController.tabBarItem.title = "이슈"
            issueViewController.tabBarItem.image = UIImage(systemName: "exclamationmark.circle")
            return issueViewController
        case .label:
            let labelViewController = LabelViewController()
            labelViewController.tabBarItem.title = "레이블"
            labelViewController.tabBarItem.image = UIImage(systemName: "tag")
            return labelViewController
        }
    }
}
