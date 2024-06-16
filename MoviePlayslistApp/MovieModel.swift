//
//  MovieModel.swift
//  MoviePlayslistApp
//
//  Created by Raj Shekhar on 17/06/24.
//

import Foundation

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//struct Movie: Codable {
//    let id: Int
//    let title: String
//    let backdropPath: String
//    let voteAverage: Double
//    let posterPath: String
//    var playlists: [String] = []
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case backdropPath = "backdrop_path"
//        case voteAverage = "vote_average"
//        case posterPath = "poster_path"
//
//    }
//}
//
//struct Playlist: Codable {
//    let name: String
//    let movieIds: [Int]
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case movieIds = "movie_ids"
//    }
//}
