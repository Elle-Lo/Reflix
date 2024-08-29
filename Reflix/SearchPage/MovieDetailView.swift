import SwiftUI
import Kingfisher


struct MovieDetailView: View {
    let movieID: Int
    @State private var movieDetail: MovieDetail?
    @State private var movieImages: [String] = []
    @State private var youtubeVideoID: String?
    @State private var castMembers: [CastMember] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let movieDetail = movieDetail {
                    if !movieImages.isEmpty {
                        CarouselView(images: movieImages)
                    }
                    
                    Text(movieDetail.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.leading)
                    
                    HStack {
                        if let releaseDate = movieDetail.releaseDate {
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
                    
                    if let voteAverage = movieDetail.voteAverage {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f/10", voteAverage))
                        }
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, 2)
                    }
                    
                    if let youtubeVideoID = youtubeVideoID {
                        NavigationLink(destination: YouTubeDetailView(videoID: youtubeVideoID)) {
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
                        HStack(spacing: 5) {
                            ForEach(castMembers) { cast in
                                VStack {
                                    if let profilePath = cast.profilePath {
                                        KFImage(URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)"))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 66, height: 100)
                                            .cornerRadius(8)
                                    } else {
                                        Color.gray
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                    }
                                    
                                    Text(cast.originalName)
                                        .font(.caption2)
                                        .lineLimit(1)
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                } else {
                    ProgressView("正在載入...")
                }
                
                if let overview = movieDetail?.overview {
                    VStack(alignment: .leading) {
                        Text("劇情介紹")
                            .font(.headline)
                            .padding(.leading)
                            .padding(.top, 15)
                        
                        Text(overview)
                            .font(.body)
                            .padding(.top, 1)
                            .padding(.bottom, 20)
                            .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                loadMovieDetail()
                loadMovieCredits()
            }
            .background(Color.black.ignoresSafeArea())
            .foregroundColor(.white)
        }
    }
    
    private func formattedRuntime(_ runtime: Int) -> String {
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)hr \(minutes)m"
    }
    
    private func loadMovieDetail() {
        TMDBAPI.fetchMovieDetails(movieID: movieID) { result in
            switch result {
            case .success(let movieDetail):
                self.movieDetail = movieDetail
                loadMovieImages()
                loadMovieTrailer()
            case .failure(let error):
                print("讀取電影資訊錯誤: \(error)")
            }
        }
    }
    
    private func loadMovieCredits() {
        TMDBAPI.fetchMovieCredits(movieID: movieID) { result in
            switch result {
            case .success(let creditsResponse):
                self.castMembers = creditsResponse.cast
            case .failure(let error):
                print("讀取演員資訊錯誤: \(error)")
            }
        }
    }
    
    private func loadMovieImages() {
        TMDBAPI.fetchMovieImages(movieID: movieID) { result in
            switch result {
            case .success(let imagesResponse):
                self.movieImages = imagesResponse.backdrops.map { $0.filePath }
            case .failure(let error):
                print("電影劇照資訊錯誤: \(error)")
            }
        }
    }
    
    private func loadMovieTrailer() {
        TMDBAPI.fetchMovieVideos(movieID: movieID) { result in
            switch result {
            case .success(let videoResponse):
                if let youtubeVideo = videoResponse.results.first(where: { $0.site == "YouTube" && $0.type == "Trailer" }) {
                    self.youtubeVideoID = youtubeVideo.key
                }
            case .failure(let error):
                print("讀取預告片錯誤: \(error)")
            }
        }
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
    
    private func playYouTubeVideo(videoID: String) {
        if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    MovieDetailView(movieID: 550)
}
