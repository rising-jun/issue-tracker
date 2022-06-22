//
//  IssueViewTest.swift
//  IssueTrackerTests
//
//  Created by 김동준 on 2022/06/22.
//

import XCTest
import ReactorKit
@testable import IssueTracker

class IssueViewTest: XCTestCase {

    var view: IssueViewController!
    var reactor: IssueReactor!
    
    override func setUpWithError() throws {
        view = IssueViewController(coordinator: IssueCoordinator(navigationController: UINavigationController()))
        reactor = IssueReactor(issueProvider: GithubIssueRepositoryStub())
        view.loadViewIfNeeded()
        view.reactor = reactor
        reactor.isStubEnabled = true
    }

    func test_viewWillAppear() {
        reactor.stub.state.value = IssueReactor.State(setViewProperty: true)
        view.viewWillAppear(true)
        XCTAssertEqual(view.tabBarItem.title, "이슈")
    }
    
    func test_tableViewCell() {
        let cellCount = 5
        reactor.stub.state.value = IssueReactor.State(loadedIssues: [Issue](repeating: Issue(id: 0, number: 0, title: "", labels: [], milestone: nil, body: nil), count: cellCount))
        view.viewWillAppear(true)
        XCTAssertEqual(view.issueView.tableView.numberOfRows(inSection: 0) + 1, cellCount)
    }
}
