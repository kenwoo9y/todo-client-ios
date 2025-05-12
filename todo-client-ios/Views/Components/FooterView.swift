import SwiftUI

struct FooterView: View {
    let copyright: String

    var body: some View {
        HStack {
            Spacer()
            Text(copyright)
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.appSecondary)
        .shadow(radius: 2)
    }
}

#Preview {
    FooterView(copyright: "© 2024 kenwoo9y")
}
