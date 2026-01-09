import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Background overlay
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("メニューを閉じる")
            }

            // Menu content
            HStack {
                MenuContent(isShowing: $isShowing, selectedTab: $selectedTab)
                    .frame(width: 250)
                    .background(Color.white)
                    .offset(x: isShowing ? 0 : -250)
                    .animation(.easeInOut, value: isShowing)

                Spacer()
            }
        }
    }
}

private struct MenuContent: View {
    @Binding var isShowing: Bool
    @Binding var selectedTab: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MenuHeader(isShowing: $isShowing)
            MenuItems(selectedTab: $selectedTab)
            Spacer()
        }
    }
}

private struct MenuHeader: View {
    @Binding var isShowing: Bool

    var body: some View {
        HStack {
            Text("Menu")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            Button(
                action: {
                    isShowing = false
                },
                label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.title2)
                        .accessibilityLabel("メニューを閉じる")
                }
            )
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

private struct MenuItems: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if selectedTab == 0 {
                NavigationLink(destination: HomeView()) {
                    HStack {
                        Image(systemName: "house.fill")
                            .accessibilityLabel("ホーム")
                        Text("Home")
                    }
                    .foregroundColor(.black)
                }
            } else {
                NavigationLink(destination: HomeView()) {
                    HStack {
                        Image(systemName: "house.fill")
                            .accessibilityLabel("ホーム")
                        Text("Home")
                    }
                    .foregroundColor(.black)
                }
            }

            NavigationLink(destination: AboutView()) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .accessibilityLabel("アバウト")
                    Text("About")
                }
                .foregroundColor(.black)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        SideMenuView(isShowing: .constant(true))
    }
}
