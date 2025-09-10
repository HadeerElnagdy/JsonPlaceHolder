//
//  MockProfileUseCase.swift
//  JsonPlaceHolderTests
//
//  Created by Hadeer on 10.09.25.
//

import Foundation
import RxSwift
@testable import JsonPlaceHolder

final class MockProfileUseCase: ProfileUseCaseProtocol {
    var userResult: Single<User> = .error(AppError.unknown(NSError(domain: Constants.ErrorDomains.testError, code: -1, userInfo: nil)))
    var albumsResult: Single<[Album]> = .error(AppError.unknown(NSError(domain: Constants.ErrorDomains.testError, code: -1, userInfo: nil)))
    var executeCallCount = 0
    var lastExecution: ProfileUseCaseExecution?

    func execute<T>(_ execution: ProfileUseCaseExecution) -> Single<T> {
        executeCallCount += 1
        lastExecution = execution

        switch execution {
        case .getUser:
            return userResult.map { $0 as! T }
        case .getAlbums:
            return albumsResult.map { $0 as! T }
        }
    }
}
