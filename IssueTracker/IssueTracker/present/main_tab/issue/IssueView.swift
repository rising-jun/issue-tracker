//
//  IssueView.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import SnapKit
import Then

final class IssueView: UIView {
    
    private lazy var tableVieDataSource = IssueTableViewDataSource()
    private lazy var tableViewDelegate = IssueTableViewDelegate()
    let tableView = UITableView().then {
        $0.register(IssueTableViewCell.self, forCellReuseIdentifier: IssueTableViewCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addSubviews(tableView)
        tableView.backgroundColor = .yellow
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
    }
    
}
