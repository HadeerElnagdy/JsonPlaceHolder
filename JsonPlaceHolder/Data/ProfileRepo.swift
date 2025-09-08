//
//  PhotoRepo.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Moya
import RxMoya
import RxSwift

final class ProfileRepository: UserRepositoryProtocol, AlbumRepositoryProtocol {
    
    private let networkClient: NetworkClientType
    
    init(networkClient: NetworkClientType = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getUsers() -> Single<[User]> {
        return networkClient.request(.getUsers, type: [User].self)
    }
    
    func getAlbums(userId: Int) -> Single<[Album]> {
        return networkClient.request(.getAlbums(userId: userId), type: [Album].self)
    }
}
