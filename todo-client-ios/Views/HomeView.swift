import SwiftUI

struct HomeView: View {
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    @StateObject private var taskListViewModel = TaskListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // メインコンテンツ
                CommonLayout(isShowingSideMenu: $sideMenuViewModel.isShowingSideMenu) {
                    TaskTableView(taskListViewModel: taskListViewModel)
                }
                
                // サイドメニュー
                SideMenuView(isShowing: $sideMenuViewModel.isShowingSideMenu)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}