@testable import TodoClientIOS
import XCTest

final class DateUtilsTests: XCTestCase {
    func testFormatDateTime() {
        // 正常系のテスト
        let inputDate = "2024-03-20T15:30:00"
        let expectedOutput = "2024-03-21 00:30"
        XCTAssertEqual(DateUtils.formatDateTime(inputDate), expectedOutput)

        // 不正な日付文字列のテスト
        let invalidDate = "invalid-date"
        XCTAssertEqual(DateUtils.formatDateTime(invalidDate), invalidDate)
    }
}
