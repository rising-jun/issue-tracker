//
//  IssueView.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import SnapKit
import Then

final class IssueView: UIView {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "Search"
    }
    
    let tableView = UITableView().then {
        let headerView = UILabel()
        headerView.text = "이슈"
        $0.tableHeaderView = headerView
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
        addSubviews(tableView, searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func setSearchBarVisible() {
        searchBar.isHidden = false
        searchBar.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func setSearchBarInVisible() {
        searchBar.isHidden = true
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
