import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("© 2024 kenwoo9y")
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
    FooterView()
} 
