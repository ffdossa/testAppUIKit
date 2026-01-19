//
//  DetailViewModel.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 18.01.2026.
//

import Foundation

// MARK: - Detail ViewModel

class DetailViewModel {
    private let postId: Int
    
    var postDetail: PostDetailModel?
    var onDataLoaded: ((PostDetailModel) -> Void)?
    var onError: ((String) -> Void)?

    init(postId: Int) {
        self.postId = postId
    }

    func loadDetails() {
        Task {
            do {
                let detail = try await NetworkManager.shared.fetchDetails(id: postId)
                self.postDetail = detail
                await MainActor.run {
                    self.onDataLoaded?(detail)
                }
            } catch {
                await MainActor.run {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
