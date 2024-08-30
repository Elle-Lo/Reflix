import SwiftUI
import Kingfisher

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var searchResults: [MovieBasicInfo] = []
    @State private var searchHistory: [String] = []
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("搜尋")
                    .font(.custom("PingFang TC", size: 30))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
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
                        ForEach(searchResults) { movie in
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
                } else {
                    searchMovies(query: searchText)
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
                }
            case .failure(let error):
                print("Error searching movies: \(error)")
            }
        }
    }
}

#Preview {
    SearchTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}
