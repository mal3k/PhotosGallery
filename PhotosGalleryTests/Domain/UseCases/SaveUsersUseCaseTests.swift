//
//  SaveUsersUseCaseTests.swift
//  PhotosGalleryTests
//
//  Created by Malek TRABELSI on 28/01/2021.
//

import XCTest
import CoreData
@testable import PhotosGallery

class SaveUsersUseCaseTests: XCTestCase {

    var coreDataMock: CoreDataMock!
    var userWorker: UserWorker!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataMock = CoreDataMock()
        userWorker = UserWorker(managedObjectContext: coreDataMock.mainContext, coreDataMock: coreDataMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataMock = nil
        userWorker = nil
    }
    func testAddUser() {
        let user = userWorker.addUser(User.stub())
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertNotNil(user.id, "id should not be nil")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
