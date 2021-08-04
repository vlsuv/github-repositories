//
//  DownloadManager.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    // MARK: - Properties
    var sessionConfiguration: URLSessionConfiguration
    
    var session: URLSession {
        return URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .main)
    }
    
    var activeDownloads: [URL: Download] = [:]
    
    var didFinishDownload: ((Download) -> ())?
    
    // MARK: - Init
    private init(sessionConfiguration: URLSessionConfiguration = .background(withIdentifier: "github-repositories.background")) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    static var shared = DownloadManager()
    
    // MARK: - Manage
    func getZip(for repository: Repository) {
        guard var url = URL(string: repository.url!) else { return }
        
        let zipPath = "/zipball"
        
        url.appendPathComponent(zipPath)
        
        let download = Download(repository: repository)
        
        download.task = session.downloadTask(with: url)
        
        download.task?.resume()
        
        download.isDownloading = true
        
        activeDownloads[url] = download
    }
}

// MARK: - URLSessionDownloadDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url, let download = activeDownloads[sourceURL] else { return }
        
        download.progress = 1
        
        download.isDownloading = false
        
        didFinishDownload?(download)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let url = downloadTask.originalRequest?.url, let download = activeDownloads[url] else { return }
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        download.progress = progress
    }
}
