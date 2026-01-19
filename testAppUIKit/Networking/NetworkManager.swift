//
//  NetworkManager.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 15.01.2026.
//

import Foundation

// MARK: - Network Manager

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    enum NetworkError: Error {
        case invalidURL
        case decodingError
        case serverError
    }
    
    func fetchFeed() async throws -> [PostModel] {
        guard let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PostsResponse.self, from: data)
        return response.posts
    }
    
    func fetchDetails(id: Int) async throws -> PostDetailModel {
        guard let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PostDetailResponse.self, from: data)
        return response.post
    }
}
