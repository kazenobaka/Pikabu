//
//  Post.swift
//  Pikabu
//
//  Created by Танчик on 20.12.2020.
//  Copyright © 2020 Танчик. All rights reserved.
//

import UIKit

struct Post: Codable {
    
    let id: Int
    let title: String
    let body: String?
    let images: [URL]?
}
