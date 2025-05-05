import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Features")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    FeatureRow(text: "Simple and intuitive task management")
                    FeatureRow(text: "Easy task creation, editing, and deletion")
                    FeatureRow(text: "Task completion tracking")
                    FeatureRow(text: "User-friendly interface")
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Technical Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("This application is built using the following technologies:")
                        .padding(.bottom, 5)
                    
                    TechRow(icon: "swift", title: "Swift", description: "A powerful and intuitive programming language for iOS development")
                    TechRow(icon: "swift", title: "SwiftUI", description: "A modern framework for building user interfaces")
                }
            }
            .padding()
        }
        .navigationTitle("About This ToDo App")
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.appPrimary)
            Text(text)
            Spacer()
        }
    }
}

struct TechRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.appPrimary)
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading, 25)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
} 
