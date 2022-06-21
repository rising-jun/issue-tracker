//
//  IssueTableViewDataSource.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/21.
//

import UIKit

final class IssueTableViewDataSource: NSObject, UITableViewDataSource {
    
    var issues: [Issue] = []
    
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IssueTableViewCell.identifier, for: indexPath)
                as? IssueTableViewCell else {
            return UITableViewCell()
        }
        
        let item = issues[indexPath.item]
        
        return cell
    }
    
}
