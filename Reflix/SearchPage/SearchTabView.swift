import SwiftUI
import Kingfisher

struct SearchTabView: View {
    @State private var searchText = ""
    @State private var searchResults: [MovieBasicInfo] = []
    @State private var filteredResults: [MovieBasicInfo] = []
    @State private var searchHistory: [String] = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    @State private var selectedGenre: Genre2? = nil
    @State private var isModalPresented: Bool = false
    
    @FocusState private var isSearchFieldFocused: Bool
    
    let genres: [Genre2] = [
        Genre2(id: 28, name: "動作片"),
        Genre2(id: 12, name: "冒險片"),
        Genre2(id: 16, name: "動畫片"),
        Genre2(id: 35, name: "喜劇片"),
        Genre2(id: 80, name: "犯罪片"),
        Genre2(id: 99, name: "紀錄片"),
        Genre2(id: 18, name: "劇情片"),
        Genre2(id: 10751, name: "家庭片"),
        Genre2(id: 14, name: "奇幻片"),
        Genre2(id: 36, name: "歷史片"),
        Genre2(id: 27, name: "恐怖片"),
        Genre2(id: 10402, name: "音樂片"),
        Genre2(id: 9648, name: "懸疑片"),
        Genre2(id: 10749, name: "愛情片"),
        Genre2(id: 878, name: "科幻片"),
        Genre2(id: 10770, name: "電視電影"),
        Genre2(id: 53, name: "驚悚片"),
        Genre2(id: 10752, name: "戰爭片"),
        Genre2(id: 37, name: "西部片")
    ]
    
    
    var body: some View {
           NavigationStack {
               VStack(alignment: .leading) {
                   headerView
                   
                   searchBar
                   
                   if searchText.isEmpty && !searchHistory.isEmpty {
                       searchHistoryView
                   }
                   
                   searchResultsListView
               }
               .onChange(of: searchText) {
                   handleSearchTextChange()
               }
               .sheet(isPresented: $isModalPresented) {
                   genreSelectionSheet
               }
           }
       }
       
       private var headerView: some View {
           HStack {
               Text("搜尋")
                   .font(.custom("PingFang TC", size: 30))
                   .foregroundColor(.white)
                   .padding(.horizontal, 16)
                   .padding(.top, 8)
               
               Spacer()
               
               Button(action: {
                   isModalPresented = true
               }) {
                   Text(selectedGenre?.name ?? "類別")
                       .foregroundColor(selectedGenre == nil ? .white : .gray)
               }
               .padding(.trailing, 30)
               .padding(.top, 30)
           }
       }
       
       private var searchBar: some View {
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
                   Button(action: clearSearch) {
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
       }
       
       private var searchHistoryView: some View {
           VStack(alignment: .leading) {
               HStack {
                   Text("搜尋紀錄")
                       .font(.custom("PingFang TC", size: 18))
                       .foregroundColor(.gray)
                   
                   Spacer()
                   
                   Button(action: { clearSearchHistory() }) {
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
               
               List {
                   ForEach(searchHistory, id: \.self) { record in
                       searchHistoryRow(record)
                   }
               }
               .listStyle(PlainListStyle())
           }
       }
       
       private func searchHistoryRow(_ record: String) -> some View {
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
                       saveSearchHistory()
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
       
       private var searchResultsListView: some View {
           List {
               ForEach(filteredResults) { movie in
                   NavigationLink(destination: MovieDetailView(movieID: movie.id)
                       .onDisappear {
                           addToSearchHistory(query: movie.title)
                       }) {
                       MovieListItemView(movie: movie)
                   }
               }
           }
           .listStyle(PlainListStyle())
       }
       
       private var genreSelectionSheet: some View {
           CategoryView(isPresented: $isModalPresented, selectedGenre: $selectedGenre, genres: genres) { genre in
               if let genre = genre {
                   filterMoviesByGenre(genre: genre)
               } else {
                   filteredResults = searchResults
               }
           }
       }
       
       private func handleSearchTextChange() {
           if searchText.isEmpty {
               searchResults = []
               filteredResults = []
           } else {
               searchMovies(query: searchText)
           }
       }
       
       private func addToSearchHistory(query: String) {
           guard !query.isEmpty else { return }
           
           if !searchHistory.contains(query) {
               searchHistory.insert(query, at: 0)
               saveSearchHistory()
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
       
       private func clearSearch() {
           searchText = ""
           searchResults = []
           filteredResults = []
       }
       
       private func saveSearchHistory() {
           UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
       }
       
       private func clearSearchHistory() {
           searchHistory.removeAll()
           saveSearchHistory()
       }
   }
#Preview {
    SearchTabView()
}

#Preview("SearchTabView (Landscape)", traits: .landscapeLeft) {
    SearchTabView()
}

