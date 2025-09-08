//
//  AlbumRepo.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Moya
import RxMoya
import RxSwift

final class AlbumDetailsRepo: PhotoRepositoryProtocol {
    private let networkClient: NetworkClientType
    
    init(networkClient: NetworkClientType = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getPhotos(albumId: Int) -> Single<[Photo]> {
        networkClient.request(.getPhotos(albumId: albumId), type: [Photo].self)
    }
}
