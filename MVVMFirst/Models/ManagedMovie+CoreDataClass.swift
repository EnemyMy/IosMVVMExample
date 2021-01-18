//
//  ManagedMovie+CoreDataClass.swift
//  
//
//  Created by Алексей on 01.01.2021.
//
//

import Foundation
import CoreData

@objc(ManagedMovie)
public class ManagedMovie: NSManagedObject {

}

//MARK: Mapping

extension ManagedMovie {
    func mapToMovieCollectionItem() -> MovieCollectionItem {
        let movieItem = MovieCollectionItem(original_title: self.title,
                                            overview: self.overview,
                                            popularity: self.popularity,
                                            poster_path: self.posterPath,
                                            release_date: self.releaseDate,
                                            vote_average: self.voteAverage,
                                            vote_count: Int(self.voteCount))
        return movieItem
    }
}

extension Array where Element: ManagedMovie {
    func mapToMovieCollectionItems() -> [MovieCollectionItem] {
        return self.map {$0.mapToMovieCollectionItem()}
        
    }
}
