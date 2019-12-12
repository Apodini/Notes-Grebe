import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Notes_gRPC_ServerTests.allTests),
    ]
}
#endif
