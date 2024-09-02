import Foundation

enum TMDBAPI {
    private static let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
    private static let baseURL = "https://api.themoviedb.org/3"

    // MARK: - Fetch Now Playing Movies
    static func fetchNowPlayingMovies(limit: Int = 10, completion: @escaping (Result<[MovieBasicInfo], Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=zh-TW&page=1"
        fetchDataList(endpoint: endpoint, limit: limit, completion: completion)
    }
    
    // MARK: - Fetch Upcoming Movies
    static func fetchUpcomingMovies(limit: Int = 10, completion: @escaping (Result<[MovieBasicInfo], Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=zh-TW&page=1"
        fetchDataList(endpoint: endpoint, limit: limit, completion: completion)
    }

    // MARK: - Fetch Movie Details
    static func fetchMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/\(movieID)?api_key=\(apiKey)&language=zh-TW"
        fetchData(endpoint: endpoint, completion: completion)
    }

    // MARK: - Fetch Movie Credits (Actors)
    static func fetchMovieCredits(movieID: Int, completion: @escaping (Result<MovieCreditsResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/\(movieID)/credits?api_key=\(apiKey)&language=zh-TW"
        fetchData(endpoint: endpoint, completion: completion)
    }

    // MARK: - Fetch Movie Images (Backdrops)
    static func fetchMovieImages(movieID: Int, completion: @escaping (Result<MovieImagesResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/\(movieID)/images?api_key=\(apiKey)"
        fetchData(endpoint: endpoint, completion: completion)
    }

    // MARK: - Fetch Movie Videos (Trailers)
    static func fetchMovieVideos(movieID: Int, completion: @escaping (Result<MovieVideosResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/movie/\(movieID)/videos?api_key=\(apiKey)&language=zh-TW"
        fetchData(endpoint: endpoint, completion: completion)
    }

    // MARK: - Search Movies
    static func searchMovies(query: String, completion: @escaping (Result<[MovieBasicInfo], Error>) -> Void) {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = "\(baseURL)/search/movie?api_key=\(apiKey)&language=zh-TW&query=\(queryEncoded)&page=1"
        fetchDataList(endpoint: endpoint, completion: completion)
    }

    // MARK: - Generic Fetch Function for List
    private static func fetchDataList<T: Codable>(endpoint: String, limit: Int? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(MovieListResponse<T>.self, from: data)
                if let limit = limit {
                    completion(.success(Array(decodedData.results.prefix(limit))))
                } else {
                    completion(.success(decodedData.results))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Generic Fetch Function for Single Item
    private static func fetchData<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
