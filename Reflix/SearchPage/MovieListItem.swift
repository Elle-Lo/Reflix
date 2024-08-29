import SwiftUI
import Kingfisher

struct MovieListItemView: View {
    let movie: MovieBasicInfo 
    
    var body: some View {
        HStack {
            if let posterPath = movie.posterPath {
                let posterURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
                KFImage(posterURL)
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
                
                if let releaseDate = movie.releaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
}
