//
//  FeedViewModel.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 15.01.2026.
//

import Foundation

// MARK: - Feed ViewModel

class FeedViewModel {
    private var posts: [PostModel] = []
    private var expandedPostIds: Set<Int> = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func loadData() {
        Task {
            do {
                let posts = try await NetworkManager.shared.fetchFeed()
                self.posts = posts
                await MainActor.run {
                    self.onDataUpdated?()
                }
            } catch {
                await MainActor.run {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }

    func numberOfPosts() -> Int {
        return posts.count
    }

    func post(at index: Int) -> PostModel {
        return posts[index]
    }

    func isExpanded(at index: Int) -> Bool {
        let id = posts[index].postId
        return expandedPostIds.contains(id)
    }

    func toggleExpansion(at index: Int) {
        let id = posts[index].postId
        if expandedPostIds.contains(id) {
            expandedPostIds.remove(id)
        } else {
            expandedPostIds.insert(id)
        }
    }
}

