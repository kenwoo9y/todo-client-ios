import SwiftUI

struct HeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
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
    HeaderView(title: "ToDo App")
} 
