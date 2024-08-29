import SwiftUI

struct MovieTabView: View {
    
    @State private var nowPlayingMovies: [MovieBasicInfo] = []
    @State private var upcomingMovies: [MovieBasicInfo] = []
  
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("我的電影")
                .font(.custom("PingFang TC", size: 30))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.top, 8)
            
            NavigationView {
                List {
                    CollectCell(title: "上映中", movies: nowPlayingMovies)
                    CollectCell(title: "即將上映", movies: upcomingMovies)
                }
//                .navigationTitle("我的電影")
                .listStyle(PlainListStyle())
            }
            .onAppear {
                loadNowPlayingMovies(limit: 10)
                loadUpcomingMovies(limit: 10)
            }
        }
    }
    
    // MARK: - 加載上映中電影
    private func loadNowPlayingMovies(limit: Int) {
        TMDBAPI.fetchNowPlayingMovies(limit: limit) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.nowPlayingMovies = movies
                }
            case .failure(let error):
                print("Failed to load now playing movies: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 加載即將上映電影
    private func loadUpcomingMovies(limit: Int) {
        TMDBAPI.fetchUpcomingMovies(limit: limit) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.upcomingMovies = movies
                }
            case .failure(let error):
                print("Failed to load upcoming movies: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MovieTabView()
}
