//
//  Movie.swift
//  MVVMFirst
//
//  Created by Алексей on 01.01.2021.
//

import Foundation
import CoreData

struct Movie: Codable {
    let title: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    
    init(data: [String : Any]) throws {
        guard let title = data["original_title"] as? String,
              let overview = data["overview"] as? String,
              let popularity = data["popularity"] as? Double,
              let posterPath = data["poster_path"] as? String,
              let releaseDate = data["release_date"] as? String,
              let voteAverage = data["vote_average"] as? Double,
              let voteCount = data["vote_count"] as? Int else { throw JSONDecodeError.jsonDecodeError }
        self.title = title
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

//MARK: Mapping

extension Movie {
    func mapToManagedMovie(context: NSManagedObjectContext) -> ManagedMovie? {
        let managedMovie = ManagedMovie(context: context)
        managedMovie.title = title
        managedMovie.overview = overview
        managedMovie.popularity = popularity
        managedMovie.posterPath = posterPath
        managedMovie.releaseDate = releaseDate
        managedMovie.voteAverage = voteAverage
        managedMovie.voteCount = Int16(voteCount)
        guard (try? context.save()) != nil else { return nil }
        return managedMovie
    }
}
