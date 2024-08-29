import SwiftUI

struct MovieTabView: View {
    
    @State private var nowPlayingMovies: [Result] = []
    @State private var upcomingMovies: [Result] = []
  
    var body: some View {

        NavigationView {
            List {
                
                CollectCell(title: "上映中", movies: nowPlayingMovies)
                CollectCell(title: "即將上映", movies: upcomingMovies)
            }
            .navigationTitle("我的電影")
            .listStyle(PlainListStyle())
            
        }
        
        .onAppear() {
            fetchTopMovies(limit: 10)
            fetchUpComingMovies(limit: 10)
        }
    }
    
    func fetchTopMovies(limit: Int = 10) {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=zh-TW&page=1"

        guard let url = URL(string: urlString) else {
            print("無效的 URL")
            return
        }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                DispatchQueue.main.async {
                    self.nowPlayingMovies = Array(movieData.results.prefix(limit))
                }
            } catch {
                print("JSON 解析錯誤: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func fetchUpComingMovies(limit: Int = 10) {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=zh-TW&page=1"

        guard let url = URL(string: urlString) else {
            print("無效的 URL")
            return
        }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                let movieData = try decoder.decode(MovieData.self, from: data)
                
                DispatchQueue.main.async {
                    self.upcomingMovies = Array(movieData.results.prefix(limit)) //
                }
                
            } catch {
                print("JSON 解析錯誤: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


#Preview {
    MovieTabView()
}


