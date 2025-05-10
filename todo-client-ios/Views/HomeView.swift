import SwiftUI

struct HomeView: View {
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    @StateObject private var taskListViewModel = TaskListViewModel()
    @State private var isShowingTaskCreate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // メインコンテンツ
                CommonLayout(isShowingSideMenu: $sideMenuViewModel.isShowingSideMenu) {
                    TaskTableView(taskListViewModel: taskListViewModel)
                }
                
                // サイドメニュー
                SideMenuView(isShowing: $sideMenuViewModel.isShowingSideMenu)
                
                // フローティングアクションボタン
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