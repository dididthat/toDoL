//
//  ToDoItemTests.swift
//  toDoLTests
//
//  Created by snydia on 21.06.2024.
//

import XCTest
@testable import toDoL

final class ToDoItemTests: XCTestCase {

    private let json = """
    {
        "id": "jlwfwk123-fsdfsdf-dsdads-dasfasf",
        "text": "Hello SHMR",
        "importance": "important",
        "deadline": 1001,
        "isCompleted": true,
        "creationDate": 1020,
    }
    """
    private let todoItem = TodoItem(
        id: "jlwfwk123-fsdfsdf-dsdads-dasfasf",
        text: "Hello SHMR",
        importance: .important,
        deadline: Date(timeIntervalSince1970: 1001),
        isCompleted: true,
        creationDate: Date(timeIntervalSince1970: 1020)
    )
   
    func testParsing() throws {
        guard
            let data = json.data(using: .utf8),
            let rawValue = try? JSONSerialization.jsonObject(with: data)
        else {
            XCTFail("Failed to parse json into data")
            return
        }
        
        guard let result = TodoItem.parse(json: rawValue) else {
            XCTFail("Failed to parse json into object")
            return
        }
        
        XCTAssertEqual(result, todoItem)
    }
    
    func testDecoding() throws {
        guard let json = try? JSONSerialization.data(withJSONObject: todoItem.json, options: .prettyPrinted) else {
            XCTFail("Failed to parse object into json")
            return
        }
        
        guard
            let rawValue = try? JSONSerialization.jsonObject(with: json)
        else {
            XCTFail("Failed to parse json into data")
            return
        }
        
        guard let result = TodoItem.parse(json: rawValue) else {
            XCTFail("Failed to parse json into object")
            return
        }
        
        XCTAssertEqual(result, todoItem)
    }
    
    func testTodoItemCSVParsing() throws {
        let csvString = "123,Test Todo,,,false,1622505600,"
        let item = TodoItem.parse(csv: csvString)
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, "123")
        XCTAssertEqual(item?.text, "Test Todo")
        XCTAssertEqual(item?.importance, .usual)
        XCTAssertEqual(item?.isCompleted, false)
        XCTAssertEqual(item?.creationDate.timeIntervalSince1970, 1622505600)
    }
    
    func testTodoItemToCSV() throws {
        let item = TodoItem(
            id: "123",
            text: "Test Todo",
            importance: .important,
            deadline: nil,
            isCompleted: false,
            creationDate: Date(timeIntervalSince1970: 1622505600),
            modificationDate: nil
        )
        
        let csv = item.csv
        let expectedCSV = "123,Test Todo,important,,false,1622505600.0,"
        XCTAssertEqual(csv, expectedCSV)
    }
}
