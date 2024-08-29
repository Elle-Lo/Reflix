import SwiftUI
import Kingfisher
import AVKit

struct MovieDetailView: View {

//    @Environment(\.dismiss) var dismiss

    let movie: Result
    @State private var ytURL: String = ""
    @State private var ytKey: String = ""
    @State private var movieImages: [String] = []
    @State private var castMembers: [CastMember] = []
    @State private var movieDetail: MovieDetail?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !movieImages.isEmpty {
                    CarouselView(images: movieImages)
                }
                
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.leading)
                
                if let movieDetail = movieDetail {
                    HStack {
                        if let releaseDate = movieDetail.release_date {
                            let year = String(releaseDate.prefix(4))
                            Text("\(year)")
                        }
                        
                        if let certification = movieDetail.certification {
                            Text("\(certification)")
                        }
                        
                        if let runtime = movieDetail.runtime {
                            Text("\(formattedRuntime(runtime))")
                        }
                        
                        if let genres = movieDetail.genres {
                            let genreNames = genres.compactMap { genreMapping[$0.name] }.joined(separator: ", ")
                            Text("類別: \(genreNames)")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    
                    if let voteAverage = movieDetail.vote_average {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f/10", voteAverage))
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 2)
                    }
                }
                
                if !ytURL.isEmpty, let validURL = URL(string: ytURL) {
                    NavigationLink(destination: YouTubeDetailView(videoID: ytKey)) {
                        HStack {
                            Image(systemName: "play.fill")
                                .foregroundColor(.reflixBlack)
                                .font(.system(size: 14))
                            
                            Text("播放預告片")
                                .foregroundColor(.reflixBlack)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                        }
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.reflixWhite)
                        .cornerRadius(5)
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
                }

                Text("主要演員")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(castMembers) { cast in
                            VStack {
                                if let profilePath = cast.profile_path {
                                    KFImage(URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)"))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                } else {
                                    Color.gray
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                }

                                Text(cast.original_name)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .frame(width: 100)
                        }
                    }
                    .padding(.horizontal)
                    
                }.padding(.bottom)

                Spacer()
                
                VStack(alignment: .leading) {
                    Text("劇情介紹")
                        .font(.headline)
                        .padding(.leading)
                        .padding(.top, 15)
                    
                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 1)
                        .padding(.bottom, 20)
                        .padding(.horizontal)
                }
                
                Spacer()

            }
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
        .onAppear {
            fetch(movieID: String(movie.id))
            loadMovieImages()
            loadMovieCredits()
            loadMovieDetail()
        }
       
//        .navigationBarBackButtonHidden(true)

//        .toolbar(content: {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                    dismiss()
//                }, label: {
//                    Image(systemName: "chevron.backward")
//                        .fontWeight(.semibold)
//                })
//
//            }
//        })
    }
    
    private func formattedRuntime(_ runtime: Int) -> String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)hr \(minutes)m"
    }
    
    func fetch(movieID: String) {
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

                if let trailer = videoData.results.first(where: { ($0.type == "Trailer" || $0.type == "Teaser") && $0.site == "YouTube" }) {
                    let trailerURL = "https://www.youtube.com/watch?v=\(trailer.key)"
                    ytURL = trailerURL
                    ytKey = trailer.key
                } else {
                    print("未找到預告片")
                }
            } catch {
                print("JSON 解析錯誤: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    private func loadMovieImages() {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)/images?api_key=\(apiKey)"

        fetchData(endpoint: urlString) { (result: Swift.Result<MovieImagesResponse, Error>) in
            switch result {
            case .success(let imagesResponse):
                self.movieImages = imagesResponse.backdrops.map { $0.file_path }
            case .failure(let error):
                print("電影劇照資訊錯誤: \(error)")
            }
        }
    }

    private func loadMovieCredits() {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(apiKey)&language=zh-TW"

        fetchData(endpoint: urlString) { (result: Swift.Result<MovieCreditsResponse, Error>) in
            switch result {
            case .success(let creditsResponse):
                self.castMembers = creditsResponse.cast
            case .failure(let error):
                print("讀取演員資訊錯誤: \(error)")
            }
        }
    }
    
    private func loadMovieDetail() {
          let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
          let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=\(apiKey)&language=zh-TW"

          fetchData(endpoint: urlString) { (result: Swift.Result<MovieDetail, Error>) in
              switch result {
              case .success(let detail):
                  self.movieDetail = detail
              case .failure(let error):
                  print("讀取電影詳細資訊錯誤: \(error)")
              }
          }
      }

    private func fetchData<T: Decodable>(endpoint: String, completion: @escaping (Swift.Result<T, Error>) -> Void) {
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

    struct CarouselView: View {
        let images: [String]
        @State private var currentIndex = 0
        private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

        var body: some View {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    KFImage(URL(string: "https://image.tmdb.org/t/p/w780\(images[index])"))
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 350)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
        }
    }

}

let mockData : Result = Result(adult: false, backdropPath: "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg", genreIDS: [28, 35, 878], id: 533535, originalLanguage: "en", originalTitle: "Deadpool & Wolverine", overview: "史上最另類超級英雄、語不驚人死不休的死侍睽違六年終於萬眾矚目重返大銀幕，更首度加入漫威電影宇宙！除了與老搭檔鋼人、青少女彈頭和雪緒再度聚首，更將與睽別15年的金鋼狼二度並肩作戰再續兄弟情，時間變異管理局找上門帶走他也老神在在，並自認只有自己能當漫威救世主，改寫漫威電影宇宙！", popularity: 4467.772, posterPath: "/wjVZAMWgfPfn2ALtLkUJY88ZySm.jpg", releaseDate: "2024-07-24", title: "死侍與金鋼狼", video: false, voteAverage: 7.765, voteCount: 2440)

#Preview {
    MovieDetailView(movie: mockData)
}


//struct ExtractedView: View { //用於有預告片
//    var text : String
//    var body: some View {
//        Text(text)
//            .bold()
//            .font(.title2)
//            .frame(width: 130,height: 50)
//            .foregroundColor(.white)
//            .background(Color(.red))
//            .cornerRadius(10)
//    }
//}
//
//struct ExtractedView2: View {  //用於無預告片
//
//    var text : String
//    var body: some View {
//        Text(text)
//            .font(.title3)
//            .frame(width: 130,height: 50)
//            .foregroundColor(.white)
//            .background(Color(.gray))
//            .cornerRadius(10)
//
//    }
//}
