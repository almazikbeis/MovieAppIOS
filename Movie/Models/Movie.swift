import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let runtime: Int? 
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case runtime
        case genres
    }
}

// Дополнительная структура для жанра
struct Genre: Codable {
    let id: Int
    let name: String
}

