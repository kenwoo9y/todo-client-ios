import SwiftUI

struct HomeView: View {
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    @StateObject private var taskListViewModel = TaskListViewModel()
    
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
                        FloatingActionButton(action: {
                            // TODO: タスク登録画面への遷移処理を追加
                        })
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