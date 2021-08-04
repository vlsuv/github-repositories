//
//  Download.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

class Download {
    var isDownloading: Bool = false
    var progress: Float = 0
    var task: URLSessionDownloadTask?
    var repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
}
