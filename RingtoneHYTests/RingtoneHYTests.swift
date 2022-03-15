//
//  RingtoneHYTests.swift
//  RingtoneHYTests
//
//  Created by AFObject on 11/3/22.
//

import XCTest
@testable import RingtoneHY
import AVFAudio

class RingtoneHYTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        AVAudioPlayer.ring(type: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
