//
//  BithumbMarketTests.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class TransactionViewModelTests: XCTestCase {
    
    var transactionViewModel: TransactionViewModel!
    var service: Serviceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        transactionViewModel = TransactionViewModel(service: service, symbol: "")
    }

    override func tearDownWithError() throws {
        service = nil
        transactionViewModel = nil
    }

    func test_체결내역_요청성공() throws {
        transactionViewModel.fetchTransaction()
        
        let expectedTransactionDataType = transactionViewModel.transactionData.value[0].type
        let expectedTransactionDataPrice = transactionViewModel.transactionData.value[0].price
        let expectedTransactionDataTotal = transactionViewModel.transactionData.value[1].total
        
        let expectTransactionType = "ask"
        let expectTransactionPrice = "1"
        let expectTransactionTotal = "1"
        
        XCTAssertEqual(expectedTransactionDataType, expectTransactionType)
        XCTAssertEqual(expectedTransactionDataPrice, expectTransactionPrice)
        XCTAssertEqual(expectedTransactionDataTotal, expectTransactionTotal)
    }
    
    func test_채결내역_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        service.request(endpoint: .transactionHistory(symbol: "")) { (result: Result<Transaction, HTTPError>) -> Void in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure.errorDescription, "연결에 실패 하였습니다.")
            }
        }
        
        transactionViewModel = TransactionViewModel(service: service, symbol: "")
        transactionViewModel.fetchTransaction()
        
        XCTAssertTrue(transactionViewModel.transactionData.value.isEmpty)
    }
    
}
