import SwiftUI

struct FloatingActionButton: View {
    var body: some View {
        Image(systemName: "plus")
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(Color.appAccent)
            .clipShape(Circle())
            .shadow(radius: 4)
            .padding(.trailing, 20)
            .padding(.bottom, 20)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingActionButton()
            }
        }
    }
} 