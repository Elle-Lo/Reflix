import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?autoplay=1")!
        uiView.load(URLRequest(url: youtubeURL))
    }
}
