//
//  MovieCollectionItem.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import Foundation

struct MovieCollectionItem {
    var original_title: String = ""
    var overview: String = ""
    var popularity: Double = 0
    var poster_path: String = ""
    var release_date: String = ""
    var vote_average: Double = 0
    var vote_count: Int = 0
}

extension MovieCollectionItem {
    static var empty: MovieCollectionItem {
        MovieCollectionItem()
    }
}
