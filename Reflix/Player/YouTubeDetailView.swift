import SwiftUI

struct YouTubeDetailView: View {
    let videoID: String
    
    var body: some View {
        VStack {
            YouTubeView(videoID: videoID)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
