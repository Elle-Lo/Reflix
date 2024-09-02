import SwiftUI

enum StateOption: String, CaseIterable {
    case 想看
    case 看過n次
    case 沒看過
    case 重置
   
    var title: String {
        switch self {
        case .想看:
            return "已收藏"
        case .沒看過:
            return "沒看過"
        case .看過n次:
            return "看過"
        case .重置:
            return "重置"
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
        case .重置:
            return "arrow.uturn.left"
        }
    }
    
    var isResetOption: Bool {
        return self == .重置
    }
}

struct StateButton: View {
    let movieID: Int
    @State private var selectedState: String
    @State private var showSheet: Bool = false
    @State private var viewCount: String = "1"
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    
    init(movieID: Int) {
        self.movieID = movieID
        
        let key = "movieState-\(movieID)"
        if let storedState = UserDefaults.standard.string(forKey: key) {
            self._selectedState = State(initialValue: storedState)
        } else {
            self._selectedState = State(initialValue: "狀態")
        }
    }
    
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
    
    private var stateLabel: some View {
        Text(selectedState)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.red)
            .cornerRadius(3.0)
            .padding(8)
            .background(Color.black.opacity(0.001))
    }
    
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
    
    private var stateButtons: some View {
        HStack(spacing: 25) {
            ForEach(StateOption.allCases, id: \.self) { option in
                stateButton(option: option)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
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
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
    }
    
    private func stateButton(option: StateOption) -> some View {
        VStack(spacing: 8) {
            Image(systemName: option.iconName)
                .font(.title3)
                .foregroundColor(option.isResetOption ? .gray : .white)
            Text(option.title)
                .font(.caption)
                .foregroundColor(option.isResetOption ? .gray : .white)
        }
        .padding(4)
        .background(Color.black.opacity(0.001))
        .onTapGesture {
            withAnimation {
                if option.isResetOption {
                    resetState()
                } else if option == .看過n次 {
                    isEditing = true
                } else {
                    handleStateSelection(option: option)
                }
            }
        }
    }
    
    private func handleStateSelection(option: StateOption) {
        let key = "movieState-\(movieID)"
        
        if option == .看過n次 {
            selectedState = "\(option.title) \(viewCount)次"
            UserDefaults.standard.set(selectedState, forKey: key)
        } else {
            selectedState = option.title
            UserDefaults.standard.set(selectedState, forKey: key)
        }

        isEditing = false
        showSheet = false
    }
    
    private func resetState() {
        let key = "movieState-\(movieID)"
        selectedState = "狀態"
        UserDefaults.standard.set(selectedState, forKey: key)
    }
    
    private func validateViewCount() {
        if let intValue = Int(viewCount), intValue < 1 {
            viewCount = "1"
        }
    }
}
