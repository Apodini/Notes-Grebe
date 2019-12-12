import XCTest
@testable import Notes_gRPC_Server

final class Notes_gRPC_ServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Notes_gRPC_Server().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
