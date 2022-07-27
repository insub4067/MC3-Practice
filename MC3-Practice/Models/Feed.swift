//
//  Feed.swift
//  MC3-Practice
//
//  Created by Kim Insub on 2022/07/27.
//

import Foundation

struct Feed {
    let owner: User
    let contributor: User?
    let title: String
    let description: String
    let audio: String
    let image: String
    var isOriginalFeed: Bool {
        contributor == nil
    }
}
