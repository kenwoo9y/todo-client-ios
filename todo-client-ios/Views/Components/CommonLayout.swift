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
            // ヘッダー
            HeaderView(title: "ToDo App", isShowingSideMenu: $isShowingSideMenu)

            // メインコンテンツエリア
            ScrollView {
                content
            }
            .background(Color.appBackground)

            // フッター
            FooterView(copyright: "© 2024 kenwoo9y")
        }
    }
}
