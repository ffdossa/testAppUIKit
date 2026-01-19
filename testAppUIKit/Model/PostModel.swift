//
//  PostModel.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 15.01.2026.
//

import Foundation
import UIKit

// MARK: - Models

struct PostModel: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

struct PostsResponse: Codable {
    let posts: [PostModel]
}

struct PostDetailModel: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case text
        case postImage
        case likesCount = "likes_count"
    }
}

struct PostDetailResponse: Codable {
    let post: PostDetailModel
}

