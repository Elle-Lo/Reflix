//
//  YouTubePlayerFullScreenView.swift
//  Reflix
//
//  Created by 池昀哲 on 2024/8/27.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubePlayerFullScreenView: View {
    
    var videoID: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isLandscape: Bool = false // 用於追蹤當前是否為橫向
    @State private var player: YouTubePlayer
    
    
    let configuration = YouTubePlayer.Configuration(
        fullscreenMode: .system,
        autoPlay: true,
        playInline: true
    )

    init(videoID: String) {
            self.videoID = videoID
            _player = State(initialValue: YouTubePlayer(source: .video(id: videoID), configuration: configuration))  //初始化這個Ytplayer
        }
    
    
    var body: some View {
            ZStack {
                YouTubePlayerView(player)
                    .onAppear {
                        player.play()
                        detectOrientation() // 偵測當前方向
                    }
                    .onChange(of: isLandscape) { newValue in
                        if newValue {
                            setOrientation(.landscapeRight)
                        } else {
                            setOrientation(.portrait)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                
                // 橫向時顯示的關閉按鈕在左上
                if isLandscape {
                    Button(action: {
                        player.pause()
                        presentationMode.wrappedValue.dismiss() //退出當前video 頁面
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .position(x: 15, y: 50) // 設置按鈕位置
                }
            }
        }
    
    //navigation bar 關閉按鈕版本
//    var body: some View {
//        NavigationView {
//            YouTubePlayerView(player)
//                .onAppear {
//                    //player.play()
//                    detectOrientation() // 偵測當前方向
//                }
//                .onChange(of: isLandscape) { newValue in
//                    if newValue {
//                        setOrientation(.landscapeRight)
//                    } else {
//                        setOrientation(.portrait)
//                    }
//                }
//                .navigationBarTitle("", displayMode: .inline)
//                .navigationBarHidden(isLandscape) // 橫屏時隱藏導航欄
//                .navigationBarItems(leading: Button("關閉") {
//                    player.pause()
//                    presentationMode.wrappedValue.dismiss()
//                }.opacity(isLandscape ? 0 : 1)) // 根據橫豎屏動態設置按鈕顯示
//                .edgesIgnoringSafeArea(.all)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
    
    // 設置裝置方向
    //用於設定指定裝置的方向
    private func setOrientation(_ orientation: UIDeviceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        updateSupportedInterfaceOrientations()
    }
    
    // 通知更新方向
    //告訴系統當前視圖控制器需要重新計算
    private func updateSupportedInterfaceOrientations() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
    // 偵測當前方向
    //方向改變時自動更新橫向或直向的狀態
    private func detectOrientation() {
        let currentOrientation = UIDevice.current.orientation
        isLandscape = currentOrientation.isLandscape
        
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
            let newOrientation = UIDevice.current.orientation
            isLandscape = newOrientation.isLandscape
        }
    }
    
}

