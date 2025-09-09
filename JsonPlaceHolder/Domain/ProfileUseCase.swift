//
//  GetUserUseCaseProtocol.swift
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
                        throw NSError(domain: "NoUsersError", code: -1, userInfo: nil)
                    }
                    return randomUser
                }
                .map { $0 as! T }
            
        case .getAlbums(let userId):
            return albumRepository.getAlbums(userId: userId)
                .map { $0 as! T }
        }
    }
}

enum ProfileUseCaseExecution {
    case getUser
    case getAlbums(userId: Int)
}
