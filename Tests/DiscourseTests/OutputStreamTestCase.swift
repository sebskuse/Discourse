//
//  OutputStreamTestCase.swift
//  DiscourseTests
//
//  Created by Seb Skuse on 22/07/2019.
//

import XCTest

class OutputStreamTestCase: XCTestCase {
    var stream: MockTextOutputStream!

    override func setUp() {
        stream = MockTextOutputStream()
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        stream = nil
    }
}
