//
//  BookRoomTests.swift
//  BookRoomTests
//
//  Created by Gulati, Mauli on 20/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import XCTest
@testable import BookRoom

class BookRoomTests: XCTestCase {

    func testToAmPMTimeString() {
        let date = "2:55 PM"
        let dateToString = Date().toAmPMTimeString()
        XCTAssertEqual(dateToString, date)
    }
    
    func testto24HourTimeString() {
        let expectedTime = "14:35"
        let to24HourString = Date().to24HourTimeString()
        XCTAssertEqual(to24HourString, expectedTime)
    }
        
    func testSort() {
        let capacityArray = ["10", "8", "4", "6"]
        let expectedCapacityArray = ["4", "6", "8", "10"]
        let resultCapacityArray = capacityArray.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
        XCTAssertEqual(resultCapacityArray, expectedCapacityArray)

    }
    
    func testdateToString() {
        let expectedDate = "20th Mar 2020"
        let dateString = Date().dateToString(date: Date())
        XCTAssertEqual(dateString, expectedDate)
    }

}
