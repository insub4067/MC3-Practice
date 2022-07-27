//
//  UserViewController.swift
//  MC3-Practice
//
//  Created by Kim Insub on 2022/07/27.
//

import UIKit

class UserViewController: UIViewController {

    let user = DataManager.shared.user
    lazy var feeds: [Feed] = []
    private var currentPage: Int = 0
    private var hasNextPage: Bool = true
    private var isLoading: Bool = false

    // Feed Collection View
    private let feedCollectionView: UICollectionView = {
        let surfaceLength = UIScreen.main.bounds.width / 3

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: surfaceLength, height: surfaceLength)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 36)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.register(FeedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableView.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self

        DataManager.shared.fetchData(currentPage: currentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.feeds.append(contentsOf: response.0)
                self?.currentPage = (self?.feeds.count)!
                self?.hasNextPage = response.1

                DispatchQueue.main.async {
                    self?.feedCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        configureNavbar()
        configureView()
        applyConstraints()
    }
}

extension UserViewController {

    // Configure Nav Bar
    private func configureNavbar() {

        // user name
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        leftButton.setTitle(user.name, for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let leftButtonItem = UIBarButtonItem(customView: leftButton)

        // plus button
        let image = UIImage(systemName: "plus.square")
        let rightButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)


        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.tintColor = .white
    }

    private func configureView() {
        [feedCollectionView]
            .forEach { item in
                view.addSubview(item)
            }
    }
    private func applyConstraints() {
        let feedCollectionViewConstraints = [
            feedCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            feedCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            feedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        [feedCollectionViewConstraints]
            .forEach { item in
                NSLayoutConstraint.activate(item)
            }
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Section 당 Cell 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    // Cell 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }

        let feed = feeds[indexPath.row]

        cell.configure(with: feed)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableView.identifier, for: indexPath) as? FeedCollectionReusableView else { return UICollectionReusableView() }

        header.configure(with: user)

        return header
    }

    // header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 192)
    }
}

extension UserViewController: UIScrollViewDelegate {

    // if scroll over bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (feedCollectionView.contentSize.height - scrollView.frame.size.height + 120) < position {

            guard !isLoading else { return }

            isLoading = true

            DataManager.shared.fetchData(currentPage: currentPage) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.feeds.append(contentsOf: response.0)
                    self?.currentPage = (self?.feeds.count)!
                    self?.hasNextPage = response.1
                    DispatchQueue.main.async {
                        self?.feedCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

            isLoading = false
        }
    }
}
