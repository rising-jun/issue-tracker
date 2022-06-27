//
//  LabelTableViewCell.swift
//  IssueTracker
//
//  Created by 김동준 on 2022/06/27.
//

import SnapKit
import Then

class LabelTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "\(self)"
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let labelTitleLabel = PaddingLabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = .black
        $0.textColor = .white
        $0.text = "label"
    }

    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.textColor = .gray
        $0.text = "description"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentStackView()
        layoutContentStackView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureContentStackView() {
        [labelTitleLabel, descriptionLabel].forEach { label in
            contentStackView.addArrangedSubview(label)
        }
    }
    
    func layoutContentStackView() {
        addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    override func prepareForReuse() {
    }
 
}

extension LabelTableViewCell {
    func configureCell(with label: Label) {
        labelTitleLabel.text = label.name
        descriptionLabel.text = label.description
    }
}
