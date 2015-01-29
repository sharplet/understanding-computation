//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Prelude
import XCTest

final class PreludeTests: XCTestCase {
	func testIdentity() {
		XCTAssertEqual(id(self), self)
	}

	func testConst() {
		XCTAssertEqual(const(0)(1), 0)
	}
}
