//
//  AlbumDetailsViewModel.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import Foundation
import RxSwift
import RxCocoa

protocol AlbumDetailsViewModelProtocol {
    var photos: Driver<[Photo]> { get }
    var filteredPhotos: Driver<[Photo]> { get }
    var isLoading: Driver<Bool> { get }
    var errorMessage: Driver<String?> { get }
    var searchText: BehaviorRelay<String> { get }
    var albumId: Int { get }
    func loadPhotos(albumId: Int)
}

final class AlbumDetailsViewModel: AlbumDetailsViewModelProtocol {
    
    // MARK: - Properties
    private let photoRepository: PhotoRepositoryProtocol
    private let disposeBag = DisposeBag()
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let photosRelay = BehaviorRelay<[Photo]>(value: [])
    private let errorMessageRelay = BehaviorRelay<String?>(value: nil)
    let searchText = BehaviorRelay<String>(value: "")
    private(set) var albumId: Int = 0
    
    // MARK: - Outputs
    var isLoading: Driver<Bool> { loadingRelay.asDriver() }
    var photos: Driver<[Photo]> { photosRelay.asDriver() }
    var errorMessage: Driver<String?> { errorMessageRelay.asDriver() }
    
    var filteredPhotos: Driver<[Photo]> {
        Driver.combineLatest(photos, searchText.asDriver())
            .map { photos, searchText in
                if searchText.isEmpty {
                    return photos
                }
                return photos.filter { photo in
                    photo.title.localizedCaseInsensitiveContains(searchText)
                }
            }
    }
    
    // MARK: - Init
    init(photoRepository: PhotoRepositoryProtocol = AlbumDetailsRepo()) {
        self.photoRepository = photoRepository
    }
    
    // MARK: - Load
    func loadPhotos(albumId: Int) {
        self.albumId = albumId
        loadingRelay.accept(true)
        errorMessageRelay.accept(nil)
        
        photoRepository.getPhotos(albumId: albumId)
            .subscribe(onSuccess: { [weak self] photos in
                self?.photosRelay.accept(photos)
                self?.loadingRelay.accept(false)
            }, onFailure: { [weak self] error in
                self?.loadingRelay.accept(false)
                self?.errorMessageRelay.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
