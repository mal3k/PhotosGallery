//
//  SearchUsersUseCaseTests.swift
//  PhotosGalleryTests
//
//  Created by Malek TRABELSI on 28/01/2021.
//

import XCTest
@testable import PhotosGallery

class SearchUsersUseCaseTests: XCTestCase {

    var api: API!
    var apiConfig: APIConfig!
    var apiFetcher: HTTPClient!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiConfig = APIConfig(scheme: Globals.SCHEME,
                              host: Globals.HOST)
        apiFetcher = APIFetcher()
        api = API(apiConfig: apiConfig,
                  apiFetcher: apiFetcher)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        api = nil
        apiConfig = nil
        apiFetcher = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGetUsersUseCase_whenSuccessfullyFetchesUsers_thenTestIfDataIsNotEmpty() {
        // given
        let expectation = self.expectation(description: "Users list fetched successfully")
        // when
        self.getUsers { result in
            switch result {
            case .success(let users):
                expectation.fulfill()
                // then
                XCTAssertTrue(users.count > 0)
            case .failure(let error):
                print(error)
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

extension SearchUsersUseCaseTests {
    func getUsers(completion: @escaping (Result<UsersResponse, HTTPNetworkError>) -> Void) {
        api.getUsers { result in
            completion(result)
        }
    }
}
