//
//  ProfileViewModelTests.swift
//  JsonPlaceHolderTests
//
//  Created by Hadeer on 10.09.25.
//

import XCTest
import RxSwift
@testable import JsonPlaceHolder

final class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileViewModel?
    var mockUseCase: MockProfileUseCase?
    var disposeBag: DisposeBag?
    
    override func setUpWithError() throws {
        mockUseCase = MockProfileUseCase()
        viewModel = ProfileViewModel(profileUsecase: mockUseCase!)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockUseCase = nil
        disposeBag = nil
    }
    
    func testInitialState() throws {
        // Given
        let viewModel = try XCTUnwrap(self.viewModel)
        let disposeBag = try XCTUnwrap(self.disposeBag)
        
        // When
        var userInfo: (String, String) = (Constants.UIStrings.emptyString, Constants.UIStrings.emptyString)
        var albums: [String] = []
        var albumIds: [Int] = []
        var isLoading: Bool = false
        var errorMessage: String? = nil
        
        viewModel.userInfo.drive(onNext: { userInfo = $0 }).disposed(by: disposeBag)
        viewModel.albums.drive(onNext: { albums = $0 }).disposed(by: disposeBag)
        viewModel.albumIds.drive(onNext: { albumIds = $0 }).disposed(by: disposeBag)
        viewModel.isLoading.drive(onNext: { isLoading = $0 }).disposed(by: disposeBag)
        viewModel.errorMessage.drive(onNext: { errorMessage = $0 }).disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(userInfo.0, Constants.UIStrings.emptyString)
        XCTAssertEqual(userInfo.1, Constants.UIStrings.emptyString)
        XCTAssertEqual(albums, [])
        XCTAssertEqual(albumIds, [])
        XCTAssertEqual(isLoading, false)
        XCTAssertNil(errorMessage)
    }
    
    func testLoadProfileSuccess() throws {
        // Given
        let viewModel = try XCTUnwrap(self.viewModel)
        let mockUseCase = try XCTUnwrap(self.mockUseCase)
        
        let mockUser = User(
            id: 1,
            name: Constants.TestData.testName,
            username: Constants.TestData.testUsername,
            email: Constants.TestData.testEmail,
            address: Address(
                street: Constants.TestData.testStreet,
                suite: Constants.TestData.testSuite,
                city: Constants.TestData.testCity,
                zipcode: Constants.TestData.testZipcode,
                geo: nil
            ),
            phone: Constants.TestData.testPhone,
            website: Constants.TestData.testWebsite,
            company: nil
        )
        
        let mockAlbums = [
            Album(userId: 1, id: 1, title: Constants.TestData.testAlbum1Title),
            Album(userId: 1, id: 2, title: Constants.TestData.testAlbum2Title)
        ]
        
        mockUseCase.userResult = .just(mockUser)
        mockUseCase.albumsResult = .just(mockAlbums)
        
        // When
        viewModel.loadProfile()
        
        // Then - verify the use case was called
        XCTAssertEqual(mockUseCase.executeCallCount, 2) // getUser + getAlbums
        XCTAssertEqual(mockUseCase.lastExecution, .getAlbums(userId: 1))
    }
    
    func testLoadProfileFailure() throws {
        // Given
        let viewModel = try XCTUnwrap(self.viewModel)
        let mockUseCase = try XCTUnwrap(self.mockUseCase)
        
        mockUseCase.userResult = .error(AppError.networkError(NSError(domain: Constants.ErrorDomains.testError, code: -1, userInfo: nil)))
        
        // When
        viewModel.loadProfile()
        
        // Then - verify the use case was called
        XCTAssertEqual(mockUseCase.executeCallCount, 1) // Only getUser should be called
        XCTAssertEqual(mockUseCase.lastExecution, .getUser)
    }
    
    func testLoadProfileWithInvalidUserId() throws {
        // Given
        let viewModel = try XCTUnwrap(self.viewModel)
        let mockUseCase = try XCTUnwrap(self.mockUseCase)
        
        let mockUser = User(
            id: nil,
            name: Constants.TestData.testName,
            username: Constants.TestData.testUsername,
            email: Constants.TestData.testEmail,
            address: nil,
            phone: nil,
            website: nil,
            company: nil
        )
        
        mockUseCase.userResult = .just(mockUser)
        
        // When
        viewModel.loadProfile()
        
        // Then - verify the use case was called
        XCTAssertEqual(mockUseCase.executeCallCount, 1) // Only getUser should be called
        XCTAssertEqual(mockUseCase.lastExecution, .getUser)
    }
    
    func testLoadingState() throws {
        // Given
        let viewModel = try XCTUnwrap(self.viewModel)
        let mockUseCase = try XCTUnwrap(self.mockUseCase)
        
        mockUseCase.userResult = .error(AppError.networkError(NSError(domain: Constants.ErrorDomains.testError, code: -1, userInfo: nil)))
        
        // When
        viewModel.loadProfile()
        
        // Then - verify the use case was called
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.lastExecution, .getUser)
    }
}
