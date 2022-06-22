//
//  Issue.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import Foundation

struct Issue: Decodable {
    let id: Int
    let number: Int //이슈번호
    let title: String
    let labels: [Label]
    let milestone: Milestone?
    let body: String?
}

struct Label: Decodable {
    let name: String
}

struct Milestone: Decodable {
    let title: String
}
