//
//  LocalModels.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import Foundation

struct LocalMessage: Codable {
    var senderId: String
    var messageId: String
    var sentDate: Date
    var contentType: ContentType
    var content: String
}

enum ContentType: String, Codable {
    case text
    case image
}
