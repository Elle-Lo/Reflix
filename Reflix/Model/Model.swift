import SwiftUI
import Foundation

// MARK: - 基本電影數據結構
struct MovieBasicInfo: Codable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String?
    let posterPath: String?
    let overview: String?
    let backdropPath: String?
    let genreIDs: [Int]?
    let originalLanguage: String?
    let originalTitle: String?
    let popularity: Double?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let adult: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, video, adult
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - 電影列表響應結構 (通用於「上映中」、「即將上映」、「搜索結果」等)
struct MovieListResponse<T: Codable>: Codable {
    let page: Int
    let results: [T]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - 電影詳細信息結構
struct MovieDetail: Codable {
    let title: String
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double?
    let runtime: Int?
    let genres: [Genre]?
    let certification: String?
    
    enum CodingKeys: String, CodingKey {
        case title, overview, runtime, genres, certification
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - 類型結構
struct Genre: Codable {
    let name: String
}

// MARK: - 演員信息結構
struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let originalName: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
        case originalName = "original_name"
    }
}

// MARK: - 演員響應結構
struct MovieCreditsResponse: Codable {
    let cast: [CastMember]
}

// MARK: - 輪播劇照結構
struct MovieImagesResponse: Codable {
    let backdrops: [MovieImage]
}

struct MovieImage: Codable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

// MARK: - 預告片影片結構
struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable {
    let key: String
    let site: String
    let type: String
}

// MARK: - 預告片響應結構
struct VideoResponse: Codable {
    let id: Int
    let results: [MovieVideo]
}

// MARK: - 類別簡轉繁映射
let genreMapping: [String: String] = [
    "动作": "動作",
    "冒险": "冒險",
    "动画": "動畫",
    "喜剧": "喜劇",
    "犯罪": "犯罪",
    "纪录": "紀錄",
    "剧情": "劇情",
    "家庭": "家庭",
    "奇幻": "奇幻",
    "历史": "歷史",
    "恐怖": "恐怖",
    "音乐": "音樂",
    "悬疑": "懸疑",
    "爱情": "愛情",
    "科幻": "科幻",
    "电视电影": "電視電影",
    "惊悚": "驚悚",
    "战争": "戰爭",
    "西部": "西部"
]
