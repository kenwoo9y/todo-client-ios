import SwiftUI

struct HeaderView: View {
    let title: String
    @Binding var isShowingSideMenu: Bool

    var body: some View {
        HStack {
            Button(
                action: {
                    isShowingSideMenu.toggle()
                },
                label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.white)
                        .accessibilityLabel("メニューを開く")
                }
            )

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.appPrimary)
        .shadow(radius: 2)
    }
}

#Preview {
    HeaderView(title: "ToDo App", isShowingSideMenu: .constant(false))
}
