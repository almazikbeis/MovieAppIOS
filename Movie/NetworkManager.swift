import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "523ef11a8307f5f7ee05bf19033a50e0" // Ваш API-ключ
    
    private init() {}
    
    // Метод для получения списка популярных фильмов
    func fetchMovies(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)movie/popular?api_key=\(apiKey)&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Декодируем массив фильмов напрямую из "results"
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let results = json?["results"] as? [[String: Any]] ?? []
                let movies = try results.map { try JSONDecoder().decode(Movie.self, from: JSONSerialization.data(withJSONObject: $0)) }
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Метод для получения деталей фильма
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "\(baseURL)movie/\(movieId)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Метод для получения списка актеров фильма
    func fetchMovieCast(movieId: Int, completion: @escaping (Result<[Actor], Error>) -> Void) {
        let urlString = "\(baseURL)movie/\(movieId)/credits?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let castResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let cast = castResponse?["cast"] as? [[String: Any]] ?? []
                let actors = try cast.map { try JSONDecoder().decode(Actor.self, from: JSONSerialization.data(withJSONObject: $0)) }
                completion(.success(actors))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchActorDetails(actorId: Int, completion: @escaping (Result<Actor, Error>) -> Void) {
        let urlString = "\(baseURL)person/\(actorId)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let actor = try JSONDecoder().decode(Actor.self, from: data)
                completion(.success(actor))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        func fetchMoviesForActor(actorId: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
            let urlString = "\(baseURL)person/\(actorId)/movie_credits?api_key=\(apiKey)"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let creditsResponse = try JSONDecoder().decode(MovieCreditsResponse.self, from: data)
                    completion(.success(creditsResponse.cast))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

}

