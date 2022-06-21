//
//  SceneReactorTest.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/20.
//

import XCTest
import Moya
import RxSwift
@testable import IssueTracker

class SceneReactorTest: XCTestCase {
    var reactor: SceneReactor!
    var tokenExchangable: GitHubTokenExchangable!

    override func setUpWithError() throws {
        tokenExchangable = GithubTokenRepositoryStub()
        reactor = SceneReactor(tokenProvider: tokenExchangable)
    }
    
    func testSceneReactor() throws {
        let expectation = XCTestExpectation()
        
        reactor.action
            .onNext(.checkRootViewController)
        
        reactor.action
            .onNext(.inputUserCode("code"))
        
        reactor.state
            .map { $0.rootViewController }
            .bind(onNext: { sceneType in
                XCTAssertEqual(true, (sceneType == .tabbar || sceneType == .login))
            })
            .dispose()
        
        reactor.state
            .map { $0.hasToken }
            .bind {
                XCTAssertEqual(true, $0)
                expectation.fulfill()
            }
            .dispose()
        wait(for: [expectation], timeout: 1.0)
        
    }
    
}
