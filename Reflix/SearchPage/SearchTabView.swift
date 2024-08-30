import SwiftUI
import Kingfisher

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var searchResults: [MovieBasicInfo] = []
    @State private var filteredResults: [MovieBasicInfo] = []
    @State private var searchHistory: [String] = []
    @State private var selectedGenre: Genre2? = nil
    //用於選擇哪個類別
    @State private var isModalPresented: Bool = false
    //用於顯示CategoryView
    @FocusState private var isSearchFieldFocused: Bool
    
    let genres: [Genre2] = [  //用於類別選單
        Genre2(id: 28, name: "動作片"),
        Genre2(id: 878, name: "科幻片"),
        Genre2(id: 12, name: "英雄片"),
        Genre2(id: 16, name: "動畫片"),
        Genre2(id: 35, name: "喜劇片"),
        Genre2(id: 27, name: "恐怖片"),
        Genre2(id: 80, name: "犯罪片"),
        Genre2(id: 10402, name: "音樂片"),
        Genre2(id: 10752, name: "戰爭片")

    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("搜尋")
                        .font(.custom("PingFang TC", size: 30))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    Button(action: {  //定義類別按鈕
                        isModalPresented = true
                    }) {
                        if let genre = selectedGenre {
                            Text(genre.name)
                                .foregroundColor(.gray)
                        } else {
                            Text("類別").foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 30).padding(.top,30)
                    
                }
                
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
                            filteredResults = []
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
                        ForEach(searchHistory, id: \.self) { record in
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                                
                                Text(record)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let index = searchHistory.firstIndex(of: record) {
                                        searchHistory.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 10))
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                searchText = record
                                searchMovies(query: record)
                                isSearchFieldFocused = false
                            }
                        }
                    } else {
                        ForEach(filteredResults) { movie in
                            NavigationLink(destination: MovieDetailView(movieID: movie.id)
                                .onDisappear {
                                    addToSearchHistory(query: movie.title)
                                }) {
                                    MovieListItemView(movie: movie)
                                }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    searchResults = []
                    filteredResults = []
                } else {
                    searchMovies(query: searchText)
                }
            }
            .sheet(isPresented: $isModalPresented) { // 當壓下類別按鈕後 會顯示出來
                ModalView(isPresented: $isModalPresented, selectedGenre: $selectedGenre, genres: genres) { genre in
                    if let genre = genre {
                        filterMoviesByGenre(genre: genre) //用選取到的類別filter
                    } else {
                        filteredResults = searchResults
                    }
                }
            }
        }
    }
    
    private func addToSearchHistory(query: String) {
        guard !query.isEmpty else { return }
        
        if !searchHistory.contains(query) {
            searchHistory.insert(query, at: 0)
        }
    }
    
    private func searchMovies(query: String) {
        TMDBAPI.searchMovies(query: query) { result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.searchResults = movies
                    self.filteredResults = movies
                    self.selectedGenre = nil
                }
            case .failure(let error):
                print("Error searching movies: \(error)")
            }
        }
    }
    
    private func filterMoviesByGenre(genre: Genre2) {
        filteredResults = searchResults.filter { movie in
            return (movie.genreIDs ?? []).contains(genre.id)
        }
    }
}

#Preview {
    SearchTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}

