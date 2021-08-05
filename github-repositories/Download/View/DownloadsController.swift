//
//  DownloadsController.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class DownloadsController: UIViewController {
    
    // MARK: - Properties
    var presenter: DownloadPresenter?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
    // MARK: - Configures
    private func configureNavigationController() {
        navigationItem.title = "Downloads"
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DownloadCell.self, forCellReuseIdentifier: DownloadCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         bottom: view.bottomAnchor)
    }
}

// MARK: - DownloadViewProtocol
extension DownloadsController: DownloadViewProtocol {
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension DownloadsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.downloads.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadCell.identifier, for: indexPath) as? DownloadCell else { return UITableViewCell() }
        
        if let download = presenter?.downloads[indexPath.row] {
            cell.configure(download)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate
extension DownloadsController: UITableViewDelegate {
    
}
