//
//  ProfileViewModel.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileViewModelProtocol {
    var userInfo: Driver<(name: String, address: String)> { get }
    var albums: Driver<[String]> { get }
    var albumIds: Driver<[Int]> { get }
    var isLoading: Driver<Bool> { get }
    func loadProfile()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    private let profileUsecase: ProfileUseCaseProtocol
    private let disposeBag = DisposeBag()
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    var isLoading: Driver<Bool> { loadingRelay.asDriver() }

    // MARK: - Outputs
    private let userInfoRelay = BehaviorRelay<(name: String, address: String)>(
        value: ("", "")
    )
    private let albumsRelay = BehaviorRelay<[String]>(value: [])
    private let albumIdsRelay = BehaviorRelay<[Int]>(value: [])
    
    var userInfo: Driver<(name: String, address: String)> { userInfoRelay.asDriver() }
    var albums: Driver<[String]> { albumsRelay.asDriver() }
    var albumIds: Driver<[Int]> { albumIdsRelay.asDriver() }
    
    // MARK: - Init
    init(profileUsecase: ProfileUseCaseProtocol = ProfileUseCase()) {
        self.profileUsecase = profileUsecase
    }
    
    // MARK: - Load
    func loadProfile() {
        loadingRelay.accept(true)
        profileUsecase.execute(.getUser)
            .flatMap { [weak self] (user: User) -> Single<(User, [Album])> in
                guard let self = self else { return .never() }
                return self.profileUsecase.execute(.getAlbums(userId: user.id ?? 0))
                    .map { albums in (user, albums) }
            }
            .subscribe(onSuccess: { [weak self] (user, albums) in
                self?.userInfoRelay.accept((user.name ?? "", user.address?.formatted ?? ""))
                self?.albumsRelay.accept(albums.map { $0.title })
                self?.albumIdsRelay.accept(albums.map { $0.id })
                self?.loadingRelay.accept(false)
            }, onFailure: { [weak self] error in
                self?.loadingRelay.accept(false)
                print("❌ Failed to load profile: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
