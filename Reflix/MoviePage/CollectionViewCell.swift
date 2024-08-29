import SwiftUI
import Kingfisher

struct CollectCell: View {
    let title: String
    let movies: [MovieBasicInfo]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .padding(.vertical)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(150))], spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        
                        NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                            VStack {
                                if let posterPath = movie.posterPath {
                                    let imageTransURL = "https://image.tmdb.org/t/p/w500" + posterPath
                                    
                                    KFImage(URL(string: imageTransURL))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 150)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                } else {
                                
                                    Color.gray
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                }
                                
                                Text(movie.title)
                                    .font(.caption)
                                    .foregroundColor(.reflixWhite)
                                    .lineLimit(1)
                            }
                            .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
    }
}
