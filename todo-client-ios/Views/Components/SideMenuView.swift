import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @StateObject private var viewModel = SideMenuViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 背景のオーバーレイ
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
            }
            
            // サイドメニュー
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    // メニューヘッダー
                    HStack {
                        Text("Menu")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            isShowing = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                    }
                    .padding(.top, 20)
                    
                    // メニュー項目
                    VStack(alignment: .leading, spacing: 15) {
                        if presentationMode.wrappedValue.isPresented {
                            Button(action: {
                                isShowing = false
                            }) {
                                HStack {
                                    Image(systemName: "house.fill")
                                    Text("Home")
                                }
                                .foregroundColor(.black)
                            }
                        } else {
                            NavigationLink(destination: HomeView()) {
                                HStack {
                                    Image(systemName: "house.fill")
                                    Text("Home")
                                }
                                .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("About")
                            }
                            .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: 250)
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: isShowing ? 0 : -250)
                .animation(.easeInOut, value: isShowing)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
} 