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
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(250))], spacing: 30) {
                    ForEach(movies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    
                                    if let posterPath = movie.posterPath {
                                        let imageTransURL = "https://image.tmdb.org/t/p/w500" + posterPath
                                        
                                        KFImage(URL(string: imageTransURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 225)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(3)
                                            .overlay(
                                                VStack {
                                                    Spacer()
                                                    if let state = UserDefaults.standard.string(forKey: "movieState-\(movie.id)"),
                                                       state != "狀態" {
                                                        StateLabel(state: state)
                                                    }
                                                }
                                                    .frame(width: 150)
                                            )
                                    } else {
                                        Color.gray
                                            .frame(width: 150, height: 225)
                                            .cornerRadius(3)
                                    }
                                    
                                    if let rating = movie.voteAverage {
                                        Text(String(format: "%.1f", rating))
                                        
                                            .font(.system(size: 14).bold())
                                            .frame(width: 30, height: 35)
                                            .background(Color.yellow)
                                            .clipShape(CutCornerRectangle(cornerRadius: 3))
                                            .foregroundColor(.white)
                                            .offset(x: 0, y: 0)
                                            .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2)
                                    }
                                }
                                
                                Text(movie.title)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 300)
        }
    }
}

struct CutCornerRectangle: Shape {
    var cornerRadius: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: cornerRadius), control: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 30, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY - 4))
        path.closeSubpath()
        
        return path
    }
}

struct StateLabel: View {
    let state: String
    
    var body: some View {
        Text(state)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .padding(.bottom, 2)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(4)
            .offset(y: 4)
            .frame(maxWidth: .infinity, alignment: .center)
            .clipped()
    }
}
