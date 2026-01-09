@testable import TodoClientIOS
import XCTest

final class DateUtilsTests: XCTestCase {
    func testFormatDateTime() {
        // Test for normal case
        let inputDate = "2024-03-20T15:30:00"
        let expectedOutput = "2024-03-21 00:30"
        XCTAssertEqual(DateUtils.formatDateTime(inputDate), expectedOutput)

        // Test for invalid date string
        let invalidDate = "invalid-date"
        XCTAssertEqual(DateUtils.formatDateTime(invalidDate), invalidDate)
    }
}
