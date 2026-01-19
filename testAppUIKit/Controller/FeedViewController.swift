//
//  FeedViewController.swift
//  testAppUIKit
//
//  Created by Andrii Marchuk on 17.01.2026.
//

import UIKit

// MARK: - Feed ViewController

class FeedViewController: UIViewController {
    private let viewModel = FeedViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Feed"
        view.backgroundColor = .systemBackground
        setupTableView()
        bindViewModel()
        viewModel.loadData()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] errorAlert in
            let alert = UIAlertController(title: "Error",
                                          message: errorAlert,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        let isExpanded = viewModel.isExpanded(at: indexPath.row)
        let post = viewModel.post(at: indexPath.row)

        cell.configure(with: post, isExpanded: isExpanded)

        cell.onExpandTapped = { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleExpansion(at: indexPath.row)

            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = viewModel.post(at: indexPath.row)
        let detailVC = DetailViewController(postId: post.postId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
