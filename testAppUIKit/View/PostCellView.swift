//
//  PostCell.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 15.01.2026.
//

import UIKit

// MARK: - Post Cell View

class PostCell: UITableViewCell {
    static let identifier = "PostCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    lazy var expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Expend", for: .normal)
        button.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        return button
    }()

    var onExpandTapped: (() -> Void)?

    private let mainStack = UIStackView()
    private let metaStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        metaStack.axis = .horizontal
        metaStack.distribution = .fillEqually
        metaStack.addArrangedSubview(likesLabel)
        metaStack.addArrangedSubview(dateLabel)
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(contentLabel)
        mainStack.addArrangedSubview(expandButton)
        mainStack.addArrangedSubview(metaStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with post: PostModel, isExpanded: Bool) {
        titleLabel.text = post.title
        contentLabel.text = post.previewText
        likesLabel.text = "❤️ \(post.likesCount)"
        dateLabel.text = post.timeshamp.toDateString()

        if isExpanded {
            contentLabel.numberOfLines = 0
            expandButton.setTitle("Expend", for: .normal)
            expandButton.isHidden = false
        } else {
            contentLabel.numberOfLines = 2
            expandButton.setTitle("Collapse", for: .normal)

            let isTextLong = shouldShowExpandButton(text: post.previewText)
            expandButton.isHidden = !isTextLong
        }
    }

    private func shouldShowExpandButton(text: String) -> Bool {
        let width = UIScreen.main.bounds.width - 32
        let font = contentLabel.font!
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect,
                                          options: .usesLineFragmentOrigin,
                                          attributes: [.font: font],
                                          context: nil)

        let singleLineHeight = font.lineHeight

        return labelSize.height > (singleLineHeight * 2)
    }

    @objc private func handleExpand() {
        onExpandTapped?()
    }
}
