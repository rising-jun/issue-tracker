//
//  LabelView.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/23.
//

import SnapKit

final class LabelView: UIView {
    
    let tableView = UITableView().then {
        $0.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        $0.scrollsToTop = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        backgroundColor = .white
        addSubviews(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
