import SwiftUI

struct CommonLayout<Content: View>: View {
    @Binding var isShowingSideMenu: Bool
    let content: Content

    init(isShowingSideMenu: Binding<Bool>, @ViewBuilder content: () -> Content) {
        _isShowingSideMenu = isShowingSideMenu
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(title: "ToDo App", isShowingSideMenu: $isShowingSideMenu)

            // Main content area
            ScrollView {
                content
            }
            .background(Color.appBackground)

            // Footer
            FooterView(copyright: "© 2024 kenwoo9y")
        }
    }
}
