import SwiftUI
import Kingfisher

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

// 独立的电影列表项目视图
struct MovieListItemView: View {
    let movie: MovieSearchResult
    let onTapped: () -> Void
    
    var body: some View {
        
                    HStack {
                        if let posterPath = movie.poster_path {
                            let posterURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
                            KFImage(posterURL) // 使用 Kingfisher 加载图片
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        } else {
                            Color.gray
                                .frame(width: 50, height: 75)
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            if let releaseDate = movie.release_date {
                                Text("Release Date: \(releaseDate)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                .simultaneousGesture(TapGesture().onEnded {
                    onTapped()
                })
            }
        }
        

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var searchResults: [MovieSearchResult] = []
    @State private var searchHistory: [String] = []
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                            
                            // 搜索标题
                            Text("搜尋")
                                .font(.custom("PingFang TC", size: 30))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            
                            // 搜索框
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search", text: $searchText)
                                    .focused($isSearchFieldFocused)
                                    .padding(8)
                                    .onSubmit {
                                        addToSearchHistory(query: searchText)
                                        searchMovies(query: searchText)
                                    }
                                
                                if !searchText.isEmpty {
                                    Button(action: {
                                        searchText = ""
                                        searchResults = []
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .padding(.top, 0)
                            .padding(.bottom, 15)
                    
                    if searchText.isEmpty && !searchHistory.isEmpty {
                        HStack {
                            Text("搜尋紀錄")
                                .font(.custom("PingFang TC", size: 18))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                searchHistory.removeAll()
                            }) {
                                Text("清除")
                                    .font(.subheadline)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        ZStack {
                                            Capsule(style: .circular)
                                                .stroke(lineWidth: 1.0)
                                        }
                                    )
                            }
                            .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    
                    List {
                        if searchText.isEmpty {
                            // 显示搜索记录
                            ForEach(searchHistory, id: \.self) { record in
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    Text(record)
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    searchText = record
                                    searchMovies(query: record)
                                }
                            }
                        } else {
                            // 显示搜索结果
                            ForEach(searchResults) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieListItemView(movie: movie) {
                                        addToSearchHistory(query: movie.title ?? "")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                                searchResults = []
                            } else {
                                searchMovies(query: newValue) // 实时搜索电影
                            }
                        }
//                .navigationTitle("Search")
            }
        }
    
    private func addToSearchHistory(query: String) {
            guard !query.isEmpty else { return }
            
            if !searchHistory.contains(query) {
                searchHistory.insert(query, at: 0)
            }
//        print("Query added to history: \(query)")
        }
    
    private func searchMovies(query: String) {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
       
        
        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=zh-TW&query=\(query)&page=1"

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
                let searchResponse = try decoder.decode(MovieSearchResponse.self, from: data)
                    self.searchResults = searchResponse.results

            } catch {
                print("JSON 解析错误: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

// SearchTabView 定义
//struct SearchTabView: View {
//    
//    @State private var searchText = ""
//    @State private var searchResults: [MovieSearchResult] = []
//    @State private var searchHistory: [String] = []
//    @FocusState private var isSearchFieldFocused: Bool
//    @State private var selectedMovie: MovieSearchResult? // 用于保存选中的电影
//    
//    var filteredResults: [MovieSearchResult] {
//        if searchText.isEmpty {
//            return []
//        } else {
//            return searchResults.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                
//                Text("搜尋")
//                    .font(.custom("PingFang TC", size: 30))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 16)
//                    .padding(.top, 8)
//                
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                    
//                    TextField("Search", text: $searchText)
//                        .focused($isSearchFieldFocused)
//                        .padding(8)
//                    
//                    if !searchText.isEmpty {
//                        Button(action: {
//                            searchText = ""
//                            searchResults = []
//                        }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.gray)
//                        }
//                    }
//                }
//                .padding(.horizontal, 16)
//                .background(Color(.systemGray5))
//                .cornerRadius(8)
//                .padding(.horizontal, 16)
//                .padding(.top, 0)
//                .padding(.bottom, 15)
//                
//                if searchText.isEmpty && !searchHistory.isEmpty {
//                    HStack {
//                        Text("搜尋紀錄")
//                            .font(.custom("PingFang TC", size: 18))
//                            .foregroundColor(.gray)
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            searchHistory.removeAll()
//                        }) {
//                            Text("清除")
//                                .font(.subheadline)
//                                .padding(.horizontal, 10)
//                                .padding(.vertical, 4)
//                                .background(
//                                    ZStack {
//                                        Capsule(style: .circular)
//                                            .stroke(lineWidth: 1.0)
//                                    }
//                                )
//                        }
//                        .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.top, 8)
//                }
//                
//                List {
//                    if searchText.isEmpty {
//                        ForEach(searchHistory, id: \.self) { record in
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.gray)
//                                    .font(.system(size: 15))
//                                
//                                Text(record)
//                                    .foregroundColor(.white)
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    if let index = searchHistory.firstIndex(of: record) {
//                                        searchHistory.remove(at: index)
//                                    }
//                                }) {
//                                    Image(systemName: "xmark")
//                                        .foregroundColor(.gray)
//                                        .font(.system(size: 10))
//                                }
//                                .buttonStyle(BorderlessButtonStyle())
//                            }
//                            .listRowBackground(Color.clear)
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                searchText = record
//                                searchMovies(query: record)
//                                isSearchFieldFocused = false
//                            }
//                        }
//                    } else {
//                        ForEach(filteredResults) { movie in
//                            NavigationLink(value: movie) {
//                                MovieListItemView(
//                                    movie: movie,
//                                    isSelected: selectedMovie == movie // 检查是否选中
//                                ) {
//                                    addSearchRecord(title: movie.title)
//                                    isSearchFieldFocused = false
//                                    selectedMovie = movie // 设置选中的电影
//                                }
//                            }
//                            .listRowBackground(Color.clear)
//                        }
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .background(Color.clear)
//                .onTapGesture {
//                    isSearchFieldFocused = false
//                }
//                .gesture(
//                    DragGesture().onChanged { _ in
//                        isSearchFieldFocused = false
//                    }
//                )
//            }
//            .background(Color.reflixBlack.ignoresSafeArea())
//            .navigationBarHidden(true)
//            .onChange(of: searchText) { newValue in
//                if !newValue.isEmpty {
//                    searchMovies(query: newValue)
//                }
//            }
//            .navigationDestination(for: MovieSearchResult.self) { movie in
//                MovieDetailView(movie: movie)
//            }
//        }
//    }
//    
//    // 新增搜索记录的函数
//    private func addSearchRecord(title: String) {
//        let trimmedText = title.trimmingCharacters(in: .whitespaces)
//        if !trimmedText.isEmpty && !searchHistory.contains(trimmedText) {
//            searchHistory.insert(trimmedText, at: 0)
//        }
//    }
//    
//    // 搜索电影的函数
//    private func searchMovies(query: String) {
//        guard !query.isEmpty else {
//            self.searchResults = []
//            return
//        }
//
//        let apiKey = "80e52b179a4a514f5cb0be8da6d5cc4b"
//        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=zh-TW&query=\(query)&page=1"
//
//        guard let url = URL(string: urlString) else {
//            print("無效的 URL")
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                print("錯誤: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("無資料")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let searchResponse = try decoder.decode(MovieSearchResponse.self, from: data)
//                    self.searchResults = searchResponse.results
//
//            } catch {
//                print("JSON 解析错误: \(error.localizedDescription)")
//            }
//        }
//
//        task.resume()
//    }
//}


#Preview {
    SearchTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}
