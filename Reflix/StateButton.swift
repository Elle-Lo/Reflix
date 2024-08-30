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
//            return "已收藏"
//        case .沒看過:
//            return "沒看過"
//        case .看過n次:
//            return "看過"
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
//    @State private var selectedState: String = "狀態"
//    @State private var viewCount: String = "1"
//    @FocusState private var isFocused: Bool
//    @State private var isEditing: Bool = false
//    
//    var onStateSelected: ((StateOption, String?) -> Void)? = nil
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Text(selectedState)
//                .font(.caption)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 8)
//                .background(Color.red)
//                .cornerRadius(3.0)
//        }
//        .foregroundColor(.white)
//        .padding(8)
//        .background(Color.black.opacity(0.001))
//        .onTapGesture {
//            showPopOver.toggle()
//        }
//        .popover(isPresented: $showPopOver, arrowEdge: .top) {
//                    ZStack {
//                        Color.reflixGray.opacity(0.95)
//                            .cornerRadius(10)
//                        
//                        VStack {
//                            if isEditing {
//                                VStack {
//                                    HStack(spacing: 12) {
//                                        ForEach(StateOption.allCases, id: \.self) { option in
//                                            stateButton(option: option)
//                                        }
//                                    }
//                                    .padding(.vertical, 5)
//                                    .padding(.horizontal, 10)
//                                    
//                                    HStack {
//                                        
//                                        TextField("輸入次數", text: $viewCount)
//                                            .padding(8)
//                                            .background(Color.white)
//                                            .foregroundColor(.black)
//                                            .keyboardType(.numberPad)
//                                            .cornerRadius(8)
//                                            .multilineTextAlignment(.center)
//                                            .focused($isFocused)
//                                            .onAppear {
//                                                isFocused = true
//                                            }
//                                        
//                                        Button(action: {
//                                            handleStateSelection(option: .看過n次)
//                                        }) {
//                                            Text("完成")
//                                                .font(.caption)
//                                                .fontWeight(.bold)
//                                                .padding(.vertical, 10)
//                                                .padding(.horizontal, 15)
//                                                .background(.reflixWhite)
//                                                .foregroundColor(.reflixBlack)
//                                                .cornerRadius(8)
//                                        }
//                                    }
//                                }
//                                .padding(.horizontal)
//                            } else {
//                                HStack(spacing: 12) {
//                                    ForEach(StateOption.allCases, id: \.self) { option in
//                                        stateButton(option: option)
//                                    }
//                                }
//                                .padding(.vertical, 5)
//                                .padding(.horizontal, 10)
//                            }
//                        }
//                    }
//                    .frame(width: 200, height: isEditing ? 130 : 80)  // 控制弹出框的宽度和高度
//                    .shadow(radius: 10)
//                    
//                }
//            }
//            
//            private func stateButton(option: StateOption) -> some View {
//                VStack(spacing: 8) {
//                    Image(systemName: option.iconName)
//                        .font(.title3)
//                        .foregroundColor(.white)
//                    Text(option.title)
//                        .font(.caption)
//                        .foregroundColor(.white)
//                }
//                .padding(4)
//                .background(Color.black.opacity(0.001))
//                .onTapGesture {
//                    if option == .看過n次 {
//                        isEditing = true
//                    } else {
//                        handleStateSelection(option: option)
//                    }
//                }
//            }
//            
//            private func handleStateSelection(option: StateOption) {
//                if option == .看過n次 && !viewCount.isEmpty {
//                    selectedState = "\(option.title) \(viewCount)次"
//                } else {
//                    selectedState = option.title
//                }
//                isEditing = false
//                showPopOver = false
//                onStateSelected?(option, option == .看過n次 ? viewCount : nil)
//            }
//        }

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
    @State private var showSheet: Bool = false
    @State private var selectedState: String = "狀態"
    @State private var viewCount: String = "1"
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    
    var onStateSelected: ((StateOption, String?) -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            stateLabel
        }
        .onTapGesture {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            sheetContent
        }
    }
    
    // 单独提取 label
    private var stateLabel: some View {
        Text(selectedState)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.red)
            .cornerRadius(3.0)
            .foregroundColor(.white)
            .padding(8)
            .background(Color.black.opacity(0.001))
    }
    
    // 单独提取 sheet 内容
    private var sheetContent: some View {
        VStack {
            stateButtons
            if isEditing {
                editView
                    .transition(.move(edge: .bottom))
            }
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(10)
        .presentationDetents([.fraction(0.2)])
        .presentationDragIndicator(.hidden)
        .animation(.easeInOut(duration: 0.3), value: isEditing)
    }
    
    // 单独提取 state 按钮
    private var stateButtons: some View {
        HStack(spacing: 25) {
            ForEach(StateOption.allCases, id: \.self) { option in
                stateButton(option: option)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
    // 单独提取编辑视图
    private var editView: some View {
        HStack {
            TextField("輸入次數", text: $viewCount)
                .keyboardType(.numberPad)
                .padding(8)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)
                .multilineTextAlignment(.center)
                .focused($isFocused)
                .frame(width: 150)
                .onAppear {
                    isFocused = true
                }
                .onChange(of: viewCount) { oldValue, newValue in
                    validateViewCount()
                }
            
            Button(action: {
                handleStateSelection(option: .看過n次)
            }) {
                Text("完成")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(.reflixWhite)
                    .foregroundColor(.reflixBlack)
                    .cornerRadius(8)
            }
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
            withAnimation {
                if option == .看過n次 {
                    isEditing = true
                } else {
                    handleStateSelection(option: option)
                }
            }
        }
    }
    
    private func handleStateSelection(option: StateOption) {
        withAnimation {
            if option == .看過n次 && !viewCount.isEmpty {
                selectedState = "\(option.title) \(viewCount)次"
            } else {
                selectedState = option.title
            }
            isEditing = false
            showSheet = false
            onStateSelected?(option, option == .看過n次 ? viewCount : nil)
        }
    }
    
    private func validateViewCount() {
        if let intValue = Int(viewCount), intValue < 1 {
            viewCount = "1"
        }
    }
}

#Preview {
    StateButton()
}


