//
//  DataManager.swift
//  MC3-Practice
//
//  Created by Kim Insub on 2022/07/27.
//

import Foundation

class DataManager {
    static let shared = DataManager()

    let user: User = User(name: "woody", profileImage: "woodyProfileImage")

    private lazy var feeds: [Feed] = Array(repeating: Feed(owner: user, contributor: nil, title: "some title", description: "some description", audio: "some audio", image: "someImage"), count: 50)

    func fetchData(currentPage: Int, completion: @escaping (Result<([Feed], Bool), Error>) -> Void) {

        let lastPage = self.feeds.count

        guard currentPage < lastPage else { return }

        // if First
        if currentPage == 0 {
            guard 0 < lastPage else { return }

            if 12 < lastPage {
                let result = Array(self.feeds[0...11])
                completion(.success((result, true)))
            } else {
                let result = Array(self.feeds[0...(lastPage - 1)])
                completion(.success((result, false)))
            }
        }

        // if more
        if 0 < currentPage {
            if currentPage + 9 < lastPage {
                let result = Array(self.feeds[currentPage...currentPage + 8])
                completion(.success((result, true)))
            } else {
                let result = Array(self.feeds[currentPage...lastPage - 1])
                completion(.success((result, false)))
            }
        }
    }
}
