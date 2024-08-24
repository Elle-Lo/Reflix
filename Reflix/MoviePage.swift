import SwiftUI


//Movie頁的畫面
struct MovieTabView: View {
    
    @State private var nowPlayingMovies: [Result] = [] // 儲存上映中電影
    @State private var upcomingMovies: [Result] = []   // 儲存即將上映電影
    
    
    var body: some View {

        NavigationView {
            List {
                // 第一個 Cell: 使用 CollectCell (上映中電影)
                CollectCell(title: "上映中", movies: nowPlayingMovies)

                // 第二個 Cell: 使用 CollectCell (即將上映電影)
                CollectCell(title: "即將上映", movies: upcomingMovies)
            }
            .navigationTitle("我的電影")
        }
        
        .onAppear() {
            fetchTopMovies(limit: 10) //抓取熱映電影10 筆資料並更新UI
            fetchUpComingMovies(limit: 10) //抓取10筆即將上映資料 並更新UI

        }
        
    }
    
    func fetchTopMovies(limit: Int = 10) {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b" // 自己的 API key
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
                let movieData = try decoder.decode(MovieData.self, from: data) // 將資料解碼為 MovieData 型別
                print("popular now : \(movieData.results.prefix(limit))")
                // 使用主線程更新 UI
                DispatchQueue.main.async {
                    self.nowPlayingMovies = Array(movieData.results.prefix(limit))
                        //假設movieData小於所限制的數量 也不會出錯

                }

            } catch {
                print("JSON 解析錯誤: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    func fetchUpComingMovies(limit: Int = 10) {
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b" // 自己的 API key
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
                let movieData = try decoder.decode(MovieData.self, from: data) // 將資料解碼為 MovieData 型別
                print("upcoming \(movieData.results.prefix(limit))")
                // 使用主線程更新 UI
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


//#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
//    MovieTabView()
//}

