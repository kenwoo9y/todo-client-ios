import SwiftUI

struct HomeView: View {
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    @StateObject private var taskListViewModel = TaskListViewModel()
    @State private var isShowingTaskCreate = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                CommonLayout(isShowingSideMenu: $sideMenuViewModel.isShowingSideMenu) {
                    TaskTableView(taskListViewModel: taskListViewModel)
                }

                // Side menu
                SideMenuView(isShowing: $sideMenuViewModel.isShowingSideMenu)

                // Floating action button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: TaskCreateView(taskListViewModel: taskListViewModel)) {
                            FloatingActionButton()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
