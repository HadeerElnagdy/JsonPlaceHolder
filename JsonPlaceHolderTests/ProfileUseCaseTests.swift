//
//  ProfileUseCaseTests.swift
//  JsonPlaceHolderTests
//
//  Created by Hadeer on 10.09.25.
//

import XCTest
import RxSwift
@testable import JsonPlaceHolder

final class ProfileUseCaseTests: XCTestCase {
    
    var useCase: ProfileUseCase!
    var mockRepository: MockProfileRepository!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        mockRepository = MockProfileRepository()
        useCase = ProfileUseCase(repo: mockRepository)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        useCase = nil
        mockRepository = nil
        disposeBag = nil
    }
    
    func testGetUserSuccess() {
        // Given
        let mockUsers = [
            User(id: Constants.TestData.testUserId, name: Constants.TestData.testName, username: Constants.TestData.testUsername, email: Constants.TestData.testEmail, address: nil, phone: nil, website: nil, company: nil),
            User(id: Constants.TestData.testUserId2, name: Constants.TestData.testName2, username: Constants.TestData.testUsername2, email: Constants.TestData.testEmail2, address: nil, phone: nil, website: nil, company: nil)
        ]
        mockRepository.mockUsers = mockUsers
        
        // When
        let _: Single<User> = useCase.execute(.getUser)
        
        // Then - verify the repository was called
        XCTAssertEqual(mockRepository.getUsersCallCount, 1)
    }
    
    func testGetUserFailure() {
        // Given
        mockRepository.mockUsers = []
        
        // When
        let _: Single<User> = useCase.execute(.getUser)
        
        // Then - verify the repository was called
        XCTAssertEqual(mockRepository.getUsersCallCount, 1)
    }
    
    func testGetAlbumsSuccess() {
        // Given
        let mockAlbums = [
            Album(userId: 1, id: 1, title: Constants.TestData.testAlbum1Title),
            Album(userId: 1, id: 2, title: Constants.TestData.testAlbum2Title)
        ]
        mockRepository.mockAlbums = mockAlbums
        
        // When
        let _: Single<[Album]> = useCase.execute(.getAlbums(userId: 1))
        
        // Then - verify the repository was called
        XCTAssertEqual(mockRepository.getAlbumsCallCount, 1)
    }
    
    func testGetAlbumsWithInvalidUserId() {
        // Given
        mockRepository.mockAlbums = []
        
        // When
        let _: Single<[Album]> = useCase.execute(.getAlbums(userId: -1))
        
        // Then - verify the repository was not called for invalid user ID
        XCTAssertEqual(mockRepository.getAlbumsCallCount, 0)
    }
}

// MARK: - MockProfileRepository
class MockProfileRepository: UserRepositoryProtocol, AlbumRepositoryProtocol {
    var mockUsers: [User] = []
    var mockAlbums: [Album] = []
    var getUsersCallCount = 0
    var getAlbumsCallCount = 0
    
    func getUsers() -> Single<[User]> {
        getUsersCallCount += 1
        return .just(mockUsers)
    }
    
    func getAlbums(userId: Int) -> Single<[Album]> {
        getAlbumsCallCount += 1
        return .just(mockAlbums)
    }
}
