//import SwiftUI
//
//enum StateOption: String, CaseIterable {
//    case 想看
//    case 看過n次
//    case 沒看過
//   
//    var title: String {
//        switch self {
//        case .想看:
//            return "收藏"
//        case .沒看過:
//            return "沒看過"
//        case .看過n次:
//            return "看過n次"
//        }
//    }
//    
//    var iconName: String {
//        switch self {
//        case .想看:
//            return "heart"
//        case .沒看過:
//            return "eye.slash"
//        case .看過n次:
//            return "checkmark"
//        }
//    }
//}
//
//struct StateButton: View {
//    @State private var showPopOver: Bool = false
//    var onStateSelected: ((StateOption) -> Void)? = nil
//    
//    var body: some View {
//        VStack(spacing: 8) {
//
//            Text("狀態")
//                .font(.caption)
//                .fontWeight(.bold)
//                .foregroundColor(.reflixWhite)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 8)
//                .background(Color.reflixRed)
//                .cornerRadius(3.0)
//            
//        }
//        .foregroundColor(.reflixWhite)
//        .padding(8)
//        .background(Color.black.opacity(0.001))
//        .onTapGesture {
//            showPopOver.toggle()
//        }
//        .popover(isPresented: $showPopOver, content: {
//            
//            ZStack {
//                Color.reflixGray.ignoresSafeArea()
//                
//                VStack {
//                    Spacer()
//                    
//                    HStack(spacing: 12) {
//                        ForEach(StateOption.allCases, id: \.self) { option in
//                            stateButton(option: option)
//                        }
//                    }
//                    .padding(.vertical, 5)
//                    .padding(.horizontal, 10)
//                    .background(Color.reflixGray)
//                    .cornerRadius(10)
//                }
//            }
//            .presentationCompactAdaptation(.popover)
//        })
//    }
//    
//    private func stateButton(option: StateOption) -> some View {
//        VStack(spacing: 8) {
//            Image(systemName: option.iconName)
//                .font(.title3)
//            Text(option.title)
//                .font(.caption)
//        }
//        .foregroundStyle(.reflixWhite)
//        .padding(4)
//        .background(Color.black.opacity(0.001))
//        .onTapGesture {
//            showPopOver = false
//            onStateSelected?(option)
//        }
//    }
//}


//另外一個
import SwiftUI

enum StateOption: String, CaseIterable {
    case 想看
    case 看過n次
    case 沒看過
   
    var title: String {
        switch self {
        case .想看:
            return "已收藏"
        case .沒看過:
            return "沒看過"
        case .看過n次:
            return "看過"
        }
    }
    
    var iconName: String {
        switch self {
        case .想看:
            return "heart"
        case .沒看過:
            return "eye.slash"
        case .看過n次:
            return "checkmark"
        }
    }
}

struct StateButton: View {
    @State private var showPopOver: Bool = false
    @State private var selectedState: String = "狀態"
    @State private var viewCount: String = "1"
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    
    var onStateSelected: ((StateOption, String?) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            Text(selectedState)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.red)
                .cornerRadius(3.0)
        }
        .foregroundColor(.white)
        .padding(8)
        .background(Color.black.opacity(0.001))
        .onTapGesture {
            showPopOver.toggle()
        }
        .popover(isPresented: $showPopOver, arrowEdge: .top) {
                    ZStack {
                        Color.reflixGray.opacity(0.95)
                            .cornerRadius(10)
                        
                        VStack {
                            if isEditing {
                                VStack {
                                    HStack(spacing: 12) {
                                        ForEach(StateOption.allCases, id: \.self) { option in
                                            stateButton(option: option)
                                        }
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    
                                    HStack {
                                        
                                        TextField("輸入次數", text: $viewCount)
                                            .keyboardType(.numberPad)
                                            .padding(8)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(8)
                                            .focused($isFocused)
                                            .onAppear {
                                                isFocused = true
                                            }
                                        
                                        Button(action: {
                                            handleStateSelection(option: .看過n次)
                                        }) {
                                            Text("完成")
                                                .font(.caption)
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 15)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            } else {
                                HStack(spacing: 12) {
                                    ForEach(StateOption.allCases, id: \.self) { option in
                                        stateButton(option: option)
                                    }
                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                    .frame(width: 200, height: isEditing ? 130 : 80)  // 控制弹出框的宽度和高度
                    .shadow(radius: 10)
                    
                }
            }
            
            private func stateButton(option: StateOption) -> some View {
                VStack(spacing: 8) {
                    Image(systemName: option.iconName)
                        .font(.title3)
                        .foregroundColor(.white)
                    Text(option.title)
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(4)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    if option == .看過n次 {
                        isEditing = true
                    } else {
                        handleStateSelection(option: option)
                    }
                }
            }
            
            private func handleStateSelection(option: StateOption) {
                if option == .看過n次 && !viewCount.isEmpty {
                    selectedState = "\(option.title) \(viewCount)次"
                } else {
                    selectedState = option.title
                }
                isEditing = false
                showPopOver = false
                onStateSelected?(option, option == .看過n次 ? viewCount : nil)
            }
        }


