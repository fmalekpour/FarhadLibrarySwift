import XCTest
@testable import FarhadLibrarySwift

final class FarhadLibrarySwiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
	
	@available(iOS 16.0, *)
	func testUrlDirectoryList() throws
	{
		let url = T4.DOCUMENTS_URL("")
		let contents = try url.DIRECTORY_FILE_LIST()
		print("Contents: \(contents)")
	}
}
