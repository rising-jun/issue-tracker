//
//  IssueView.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import SnapKit
import Then

class IssueView: UIView {
    
    private lazy var tableVieDataSource = IssueTableViewDataSource()
    private lazy var tableViewDelegate = IssueTableViewDelegate()
    private lazy var tableView = UITableView().then {
        $0.dataSource = tableVieDataSource
        $0.delegate = tableViewDelegate
        $0.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
