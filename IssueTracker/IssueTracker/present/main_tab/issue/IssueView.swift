//
//  IssueView.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/20.
//

import SnapKit
import Then

class IssueView: UIView {
    
    let button = UIButton().then {
        $0.setTitle("불러오기", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
