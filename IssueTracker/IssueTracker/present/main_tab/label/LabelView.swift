//
//  LabelView.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/23.
//

import SnapKit

final class LabelView: UIView {
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
    }
}
