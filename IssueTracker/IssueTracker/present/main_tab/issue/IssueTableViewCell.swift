//
//  IssueTableViewCell.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/21.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "\(self)"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindViewProperty(issue: Issue) {
        print("issue title in cell \(issue.title)")
    }
}

// MARK: - View Layout

private extension IssueTableViewCell {
    
}

// MARK: - Providing Function

extension IssueTableViewCell {
    
}
