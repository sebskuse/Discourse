//
//  MockTextOutputStream.swift
//  Discourse
//
//  Created by Seb Skuse on 22/07/2019.
//

import Foundation

class MockTextOutputStream: TextOutputStream {
    private(set) var receivedWriteMessages: [String] = []

    func write(_ string: String) {
        receivedWriteMessages.append(string)
    }
}
