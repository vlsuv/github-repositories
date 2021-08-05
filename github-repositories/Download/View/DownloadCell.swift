//
//  DownloadCell.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class DownloadCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String = "DownloadCell"
    
    private var repositoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private var userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repositoryNameLabel, userNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
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
    
    func configure(_ download: Download) {
        if download.isDownloaded {
            accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
        } else {
            accessoryView = activityIndicator
            activityIndicator.startAnimating()
        }
        
        repositoryNameLabel.text = download.repository.name
        userNameLabel.text = download.repository.owner.login
    }
    
    // MARK: - Configures
    private func addSubviews() {
        [textStackView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureConstraints() {
        textStackView.anchor(top: contentView.topAnchor,
                             left: contentView.leftAnchor,
                             right: contentView.rightAnchor,
                             bottom: contentView.bottomAnchor,
                             paddingTop: 8,
                             paddingLeft: 18,
                             paddingRight: 18,
                             paddingBottom: 8)
    }
}
