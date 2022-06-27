//
//  Label.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/23.
//

import Foundation

struct Label: Decodable {
    let name: String
    let description: String
    let color: String
}
