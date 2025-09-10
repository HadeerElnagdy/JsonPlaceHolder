//
//  ProfileUseCase.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 09.09.25.
//

import RxSwift
import Foundation

protocol ProfileUseCaseProtocol {
    func execute<T>(_ execution: ProfileUseCaseExecution) -> Single<T>
}

final class ProfileUseCase: ProfileUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    private let albumRepository: AlbumRepositoryProtocol
    
    init(repo: UserRepositoryProtocol & AlbumRepositoryProtocol = ProfileRepository()) {
        self.userRepository = repo
        self.albumRepository = repo
    }
    
    func execute<T>(_ execution: ProfileUseCaseExecution) -> Single<T> {
        switch execution {
        case .getUser:
            return userRepository.getUsers()
                .map { users -> User in
                    guard let randomUser = users.randomElement() else {
                        throw AppError.noUsersFound
                    }
                    return randomUser
                }
                .map { user in
                    guard let result = user as? T else {
                        throw AppError.unknown(NSError(domain: Constants.ErrorDomains.typeCastError, code: -1, userInfo: nil))
                    }
                    return result
                }
                .catch { error in
                    throw AppError.networkError(error)
                }
            
        case .getAlbums(let userId):
            guard userId > 0 else {
                return Single.error(AppError.unknown(NSError(domain: Constants.ErrorDomains.invalidUserId, code: -1, userInfo: nil)))
            }
            
            return albumRepository.getAlbums(userId: userId)
                .map { albums in
                    guard let result = albums as? T else {
                        throw AppError.unknown(NSError(domain: Constants.ErrorDomains.typeCastError, code: -1, userInfo: nil))
                    }
                    return result
                }
                .catch { error in
                    throw AppError.networkError(error)
                }
        }
    }
}

enum ProfileUseCaseExecution: Equatable {
    case getUser
    case getAlbums(userId: Int)
}
