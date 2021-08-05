//
//  Repository.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct Repository: Codable {
    var id: Int
    var name: String
    var fullName: String
    var htmlURL: String
    var url: String?
    var isPrivate: Bool
    var owner: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case htmlURL = "html_url"
        case url = "url"
        case isPrivate = "private"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.fullName = try values.decode(String.self, forKey: .fullName)
        self.htmlURL = try values.decode(String.self, forKey: .htmlURL)
        self.url = try? values.decode(String.self, forKey: .url)
        self.isPrivate = try values.decode(Bool.self, forKey: .isPrivate)
        self.owner = try values.decode(User.self, forKey: .owner)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(htmlURL, forKey: .htmlURL)
        try? container.encode(url, forKey: .url)
        try container.encode(isPrivate, forKey: .isPrivate)
        try container.encode(owner, forKey: .owner)
    }
}
