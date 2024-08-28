import SwiftUI
import Foundation

// 定义电影搜索结果的数据结构
struct MovieSearchResult: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let release_date: String?
    let poster_path: String?
}

struct MovieSearchResponse: Codable {
    let results: [MovieSearchResult]
}


// 演員
struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    let original_name: String
}
    
struct MovieCreditsResponse: Codable {
    let cast: [CastMember]
}


// DetailView2 model
struct MovieDetail: Codable {
    let title: String
    let overview: String?
    let release_date: String?
    let vote_average: Double?
    let runtime: Int?
    let genres: [Genre]?
    let certification: String?
}

struct Genre: Codable {
    let name: String
}


// 輪播劇照
struct MovieImagesResponse: Codable {
    let backdrops: [MovieImage]
}

struct MovieImage: Codable {
    let file_path: String
}


// 預告片影片
struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable {
    let key: String
    let site: String
    let type: String
}

// 類別簡轉繁
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
