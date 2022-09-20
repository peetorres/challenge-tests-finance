
import XCTest

@testable import FinanceApp

final class FinanceServiceTests: XCTestCase {

    func test_fetch_ActivityDetailsSuccess() {
        let expectation = expectation(description: "Waiting request")
        let networkClientSpy = NetworkClientSpy()
        let givenJSON = """
        {
          "name": "Mall",
          "category": "Shopping",
          "price": 100.0,
          "time": "8:57 AM"
        }
        """
        networkClientSpy.completionData = givenJSON.data(using: .utf8)
        let sut = FinanceService(networkClient: networkClientSpy)

        let expectedResult = ActivityDetails(name: "Mall",
                                             price: 100.0,
                                             category: "Shopping",
                                             time: "8:57 AM")

        sut.fetchActivityDetails { response in
            XCTAssertEqual(response, expectedResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetch_ActivityDetailsCountingOnePerformRequest() {
        let expectation = expectation(description: "Waiting request")
        let networkClientSpy = NetworkClientSpy()
        let sut = FinanceService(networkClient: networkClientSpy)

        sut.fetchActivityDetails { response in

            XCTAssertEqual(networkClientSpy.performRequestCount, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetch_ActivityDetailsParsePriceFails() {
        let expectation = expectation(description: "Waiting request")
        let networkClientSpy = NetworkClientSpy()
        let givenJSON = """
        {
          "name": "Mall",
          "category": "Shopping",
          "price": "100.0",
          "time": "8:57 AM"
        }
        """
        networkClientSpy.completionData = givenJSON.data(using: .utf8)
        let sut = FinanceService(networkClient: networkClientSpy)

        sut.fetchActivityDetails { response in
            XCTAssertNil(response)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetch_ActivityDetailsDataNil() {
        let expectation = expectation(description: "Waiting request")
        let networkClientSpy = NetworkClientSpy()
        networkClientSpy.completionData = nil
        let sut = FinanceService(networkClient: networkClientSpy)

        sut.fetchActivityDetails { response in
            XCTAssertNil(response)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_fetch_ActivityDetailsURL() {
        let expectation = expectation(description: "Waiting request")
        let networkClientSpy = NetworkClientSpy()
        let sut = FinanceService(networkClient: networkClientSpy)
        let expectedURL = URL(string: "https://raw.githubusercontent.com/devpass-tech/challenge-finance-app/main/api/activity_details_endpoint.json")!

        sut.fetchActivityDetails { response in
            XCTAssertEqual(networkClientSpy.url, expectedURL)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
