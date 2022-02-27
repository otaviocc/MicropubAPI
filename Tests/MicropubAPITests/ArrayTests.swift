import XCTest
@testable import MicropubAPI

final class ArrayTests: XCTestCase {

    func testUnionWithNil() throws {
        // Given
        let array = [1, 2, 3, 4]

        // When
        let newArray = array.union(with: nil)

        // Then
        XCTAssertEqual(newArray, [1, 2, 3, 4])
    }

    func testUnionWithValidArray() throws {
        // Given
        let array = [1, 2, 3, 4]

        // When
        let newArray = array.union(
            with: [5, 6, 7, 8]
        )

        // Then
        XCTAssertEqual(newArray, [1, 2, 3, 4, 5, 6, 7, 8])
    }
}
