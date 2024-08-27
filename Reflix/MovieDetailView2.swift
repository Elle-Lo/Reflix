//
//  MovieDetailView2.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/27.
//

import SwiftUI

struct MovieDetailView2: View {
    let movie: MovieSearchResult

    var body: some View {
        VStack {
            Text(movie.title)
                .font(.largeTitle)
                .padding()

            if let releaseDate = movie.release_date {
                Text("Release Date: \(releaseDate)")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
    }
}

//#Preview {
//    MovieDetailView2()
//}
