struct Actor: Codable {
    let id: Int
    let name: String
    let biography: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case profilePath = "profile_path"
    }
}

