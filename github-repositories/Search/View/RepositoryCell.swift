//
//  RepositoryCell.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol RepositoryCellDelegate: class {
    func didTapGetButton(cell: UITableViewCell)
}

class RepositoryCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "RepositoryCell"
    
    weak var delegate: RepositoryCellDelegate?
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton()
        let normalAttributedString = NSAttributedString(string: "Get", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Color.blue
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.addTarget(self, action: #selector(didTapGetButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ repository: Repository) {
        nameLabel.text = repository.name
        getButton.isHidden = repository.isPrivate
    }
    
    // MARK: - Targets
    @objc private func didTapGetButton(_ sender: UIButton) {
        delegate?.didTapGetButton(cell: self)
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [nameLabel, getButton]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        getButton.anchor(top: contentView.topAnchor,
                         right: contentView.rightAnchor,
                         bottom: contentView.bottomAnchor,
                         paddingRight: 18,
                         width: 50)
        getButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        nameLabel.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         right: getButton.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         paddingLeft: 18)
    }
}
