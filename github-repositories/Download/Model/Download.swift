//
//  Download.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

class Download: Codable {
    var isDownloaded: Bool = false
    var task: URLSessionDownloadTask?
    var repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    enum CodingKeys: String, CodingKey {
        case isDownloaded
        case task
        case repository
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.isDownloaded = try values.decode(Bool.self, forKey: .isDownloaded)
        self.repository = try values.decode(Repository.self, forKey: .repository)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isDownloaded, forKey: .isDownloaded)
        try container.encode(repository, forKey: .repository)
    }
}
