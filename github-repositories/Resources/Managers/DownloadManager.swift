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
    
    var downloads: [Download] = []
    
    var didFinishDownload: ((Download) -> ())?
    
    // MARK: - Init
    private init(sessionConfiguration: URLSessionConfiguration = .background(withIdentifier: "github-repositories.background")) {
        self.sessionConfiguration = sessionConfiguration
        
        downloads = UserSettings.shared.downloads
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
        
        downloads.append(download)
    }
}

// MARK: - URLSessionDownloadDelegate
extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let index = downloads.firstIndex(where: { $0.task == downloadTask }) else {
            return
        }
        
        let download = downloads[index]
        
        download.isDownloaded = true
        
        UserSettings.shared.downloads = downloads
        
        didFinishDownload?(download)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            
            completionHandler()
        }
    }
}
