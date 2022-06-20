//
//  IssueCoordinator.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/17.
//

import UIKit

final class IssueCoordinator: Coordinator {
    var childCoordinators = [String : Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
