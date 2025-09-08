//
//  ReposProtocol.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import RxSwift

// MARK: - User Repository
protocol UserRepositoryProtocol {
    func getUsers() -> Single<[User]>
}

// MARK: - Album Repository
protocol AlbumRepositoryProtocol {
    func getAlbums(userId: Int) -> Single<[Album]>
}

// MARK: - Photo Repository
protocol PhotoRepositoryProtocol {
    func getPhotos(albumId: Int) -> Single<[Photo]>
}
