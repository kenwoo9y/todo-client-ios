import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .accessibilityLabel("地球")
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
