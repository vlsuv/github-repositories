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
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var downloads: [Download] = []
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        getDownloads()
        configureNavigationController()
        configureTableView()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Configures
    private func getDownloads() {
        downloads = DownloadManager.shared.activeDownloads.map { $0.value }
        
        DownloadManager.shared.didFinishDownload = { [weak self] download in
            
            guard let index = self?.downloads.firstIndex(where: { $0.repository.name == download.repository.name }) else { return }
            
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
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

// MARK: - UITableViewDataSource
extension DownloadsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadCell.identifier, for: indexPath) as? DownloadCell else { return UITableViewCell() }
        cell.configure(downloads[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate
extension DownloadsController: UITableViewDelegate {
    
}
