import SwiftUI

struct MovieTabView: View {
    
    @State private var nowPlayingMovies: [MovieBasicInfo] = []
    @State private var upcomingMovies: [MovieBasicInfo] = []
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("我的電影")
                    .font(.custom("PingFang TC", size: 30))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.top, 15)
                
                List {
                    CollectCell(title: "上映中", movies: nowPlayingMovies)
                    CollectCell(title: "即將上映", movies: upcomingMovies)
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    loadNowPlayingMovies(limit: 50)
                    loadUpcomingMovies(limit: 50)
                }
                
            }
        }
        .scrollIndicators(.hidden)
    }
    
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
