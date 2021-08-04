//
//  Repository.swift
//  github-repositories
//
//  Created by vlsuv on 04.08.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

struct Repository: Decodable {
    var name: String
    var full_name: String
    var html_url: String
}
