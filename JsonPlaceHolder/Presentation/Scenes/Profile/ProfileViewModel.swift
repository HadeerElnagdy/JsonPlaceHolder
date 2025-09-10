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
    var errorMessage: Driver<String?> { get }
    func loadProfile()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    private let profileUsecase: ProfileUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - State
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    private let userInfoRelay = BehaviorRelay<(name: String, address: String)>(value: (Constants.UIStrings.emptyString, Constants.UIStrings.emptyString))
    private let albumsRelay = BehaviorRelay<[String]>(value: [])
    private let albumIdsRelay = BehaviorRelay<[Int]>(value: [])
    
    // MARK: - Outputs
    var isLoading: Driver<Bool> { loadingRelay.asDriver() }
    var errorMessage: Driver<String?> { errorMessageRelay.asDriver() }
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
        errorMessageRelay.accept(nil)
        
        profileUsecase.execute(.getUser)
            .flatMap { [weak self] (user: User) -> Single<(User, [Album])> in
                guard let self = self else { return .never() }
                guard let userId = user.id, userId > 0 else {
                    throw AppError.unknown(NSError(domain: Constants.ErrorDomains.invalidUserId, code: -1, userInfo: nil))
                }
                return self.profileUsecase.execute(.getAlbums(userId: userId))
                    .map { albums in (user, albums) }
            }
            .subscribe(
                onSuccess: { [weak self] (user, albums) in
                    self?.handleSuccess(user: user, albums: albums)
                },
                onFailure: { [weak self] error in
                    self?.handleError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func handleSuccess(user: User, albums: [Album]) {
        let name = user.name ?? Constants.UIStrings.unknownUser
        let address = user.address?.formatted ?? Constants.UIStrings.noAddressAvailable
        let albumTitles = albums.map { $0.title }
        let albumIds = albums.map { $0.id }
        
        userInfoRelay.accept((name: name, address: address))
        albumsRelay.accept(albumTitles)
        albumIdsRelay.accept(albumIds)
        loadingRelay.accept(false)
        errorMessageRelay.accept(nil)
    }
    
    private func handleError(_ error: Error) {
        let errorMessage: String
        if let appError = error as? AppError {
            errorMessage = appError.localizedDescription
        } else {
            errorMessage = Constants.ErrorMessages.unknownError
        }
        
        errorMessageRelay.accept(errorMessage)
        loadingRelay.accept(false)
    }
}
