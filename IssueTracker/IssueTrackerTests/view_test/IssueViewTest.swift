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
        view.reactor = reactor
        reactor.isStubEnabled = true
    }

    func test_viewWillAppear() {
        reactor.stub.state.value = IssueReactor.State(loadedIssues: [Issue](repeating: Issue(id: 0, number: 0, title: "", labels: [], milestone: nil, body: nil), count: 0), setViewProperty: true)
        XCTAssertEqual(view.issueView.tableView.numberOfSections, 1)
    }

}
