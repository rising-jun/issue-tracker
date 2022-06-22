//
//  IssueTableViewCell.swift
//  IssueTracker
//
//  Created by 김상혁 on 2022/06/21.
//

import SnapKit
import Then

class IssueTableViewCell: UITableViewCell {
    
    private lazy var issueTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private lazy var issueDescriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .systemGray3
    }
    
    private lazy var milestonTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .systemGray3
    }
    
    private lazy var labelTitleLabel = PaddingLabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    static var identifier: String {
        return "\(self)"
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
    
    override func prepareForReuse() {
        //Reuse 처리하기
    }
}

// MARK: - View Layout

private extension IssueTableViewCell {
    func configureContentStackView() {
        [issueTitleLabel, issueDescriptionLabel, milestonTitleLabel, labelTitleLabel].forEach { label in
            contentStackView.addArrangedSubview(label)
        }
    }
    
    func layoutContentStackView() {
        addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Providing Function

extension IssueTableViewCell {
    func configureCell(with issue: Issue) { //ViewModel binding해서 그리는 방식으로 변경
        issueTitleLabel.text = issue.title
        issueDescriptionLabel.text = issue.body
        milestonTitleLabel.text = issue.milestone?.title
        labelTitleLabel.text = issue.labels.first?.name
    }
}

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
