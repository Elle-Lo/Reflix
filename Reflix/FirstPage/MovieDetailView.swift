

//
//  MovieDetailView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/26.
//
import SwiftUI
import Kingfisher

struct VideoResponse: Codable {
    let id: Int
    let results: [Result2]
}

// MARK: - Result
struct Result2: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}


struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss //先加這行因 目前 SwiftUI 尚未提供對應的 modifier
    
    let movie: Result
    @State var ytURL: String = ""
    @State var ytKey: String = ""
    @State private var isShowingFullScreen = false
    @State private var isLandscape = false
    
    
    
    var body: some View {
   
        ScrollView {
            VStack(alignment: .leading) {
                let imageTransURL = "https://image.tmdb.org/t/p/w500" + movie.posterPath
                
                KFImage(URL(string: imageTransURL))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding()
                
                Text(movie.title)
                    .font(.largeTitle)
                    .padding([.leading, .trailing, .bottom]) //給左、右、下方給一些邊距
                
                Text(movie.overview)
                    .font(.body)
                    .padding([.leading, .trailing, .bottom])
                
                Spacer()

                
                if !ytURL.isEmpty, let validURL = URL(string: ytURL) {  //避免還沒拿到資料就解包就crash

                    
                    //單純用link
//                    Link(destination: validURL, label: {
//                        ExtractedView(text: "播放預告片")
//                    })
                    
                    Button(action: {
                        isShowingFullScreen = true
                    }, label: {
                        ExtractedView(text: "播放預告片")
                    })
                    .fullScreenCover(isPresented: $isShowingFullScreen, content: {
                        YouTubePlayerFullScreenView(videoID: ytKey)
                    })
                    
                    
                    
                } else {
                    Text("暫無預告片")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear() {  //進入此cell 再去打一支拿youtube的預告片網址
            print("movie: \(movie.title) , movid : \(movie.id)")
            fetch(movieID: String(movie.id))
            print(ytURL)
        }
        //.navigationTitle(movie.title)
        //.navigationBarTitleDisplayMode(.inline)
        
        .navigationBarBackButtonHidden(true)  //將預設的返回按鈕隱藏改用自訂的
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                        Image(systemName: "chevron.backward")
                            .fontWeight(.semibold)
                })
                
                
                
            }
        })
    }
    
     func fetch(movieID: String) {  //用先前拿到的id去抓取Yt的專屬id 並轉成可以用的網址
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)&language=zh-TW"
        
        guard let url = URL(string: urlString) else {
            print("無效的 URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("錯誤: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("無資料")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let videoData = try decoder.decode(VideoResponse.self, from: data)
                
                for video in videoData.results {
                    print("影片類型: \(video.type), 來源: \(video.site), Key: \(video.key)")
                }
                
                
                if let trailer = videoData.results.first(where: { ($0.type == "Trailer" || $0.type == "Teaser") && $0.site == "YouTube" }) {
                    let trailerURL = "https://www.youtube.com/watch?v=\(trailer.key)" //轉換成yt可以找到的網址
                    ytURL = trailerURL
                    ytKey = trailer.key
                   // print("電影： \(movie.title) , 預告片連結: \(trailerURL)")
                    
                    
                } else {
                    print("未找到預告片")
                }
            } catch {
                print("JSON 解析錯誤: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    
}



//#Preview {
//    MovieDetailView(movie:)
//}

struct ExtractedView: View {
    
    var text : String
    var body: some View {
        Text(text)
            .bold()
            .font(.title2)
            .frame(width: 200,height: 50)
            .foregroundColor(.white)
            .background(Color(.red))
            .cornerRadius(10)
           
    }
}

//#Preview {
//    MovieDetailView(movie: MovieSearchResult)
//}
