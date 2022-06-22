//
//  SceneDelegate.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/13.
//

import UIKit
import ReactorKit
import RxRelay

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, View, DependencySetable {
    typealias DependencyType = SceneDependency
    
    var disposeBag: DisposeBag = DisposeBag()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let sceneInit = PublishRelay<Void>()
    private let takeCode = PublishRelay<String>()
    private var coordinator: AppCoordinator?
    private let rootNavigationController = UINavigationController()
    
    var dependency: SceneDependency? {
        didSet {
            self.reactor = dependency?.manager
        }
    }

    func bind(reactor: SceneReactor) {
        sceneInit
            .map { Reactor.Action.checkRootViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        takeCode
            .map { Reactor.Action.inputUserCode($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.rootViewController }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind { [weak self] viewControllerType in
                guard let self = self else { return }
                self.coordinator = AppCoordinator(navigationController: self.rootNavigationController,
                                                  presentViewController: viewControllerType)
                self.coordinator?.start()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.hasToken }
            .compactMap { $0 }
            .filter { $0 }
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.rootNavigationController.popViewController(animated: false)
                self.coordinator = AppCoordinator(navigationController: self.rootNavigationController,
                                                  presentViewController: .tabbar)
                self.coordinator?.start()
            }
            .disposed(by: disposeBag)
            
    }
    
    var window: UIWindow?
    
    override init() {
        super.init()
        DependencyInjector.shared.injecting(to: self)
        sceneInit.accept(())
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = self.rootNavigationController
            //window.rootViewController = LoginViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let url = URLContexts.first?.url
        let code = url?.absoluteString.components(separatedBy: "code=").last ?? ""
        takeCode.accept(code)
    }
}

struct SceneDependency: Dependency {
    typealias ManagerType = SceneReactor
    let manager: ManagerType
}
 
