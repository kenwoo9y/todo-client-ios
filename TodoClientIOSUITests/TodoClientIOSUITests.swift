import XCTest

final class TodoClientIOSUITests: XCTestCase {
    override func setUpWithError() throws {
        // 失敗時に即座に停止する
        continueAfterFailure = false

        // アプリを起動
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // アプリを終了
        XCUIApplication().terminate()
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
