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
    var searchText: BehaviorRelay<String> { get }
    func loadPhotos(albumId: Int)
}

final class AlbumDetailsViewModel: AlbumDetailsViewModelProtocol {
    
    // MARK: - Properties
    private let photoRepository: PhotoRepositoryProtocol
    private let disposeBag = DisposeBag()
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let photosRelay = BehaviorRelay<[Photo]>(value: [])
    let searchText = BehaviorRelay<String>(value: "")
    
    // MARK: - Outputs
    var isLoading: Driver<Bool> { loadingRelay.asDriver() }
    var photos: Driver<[Photo]> { photosRelay.asDriver() }
    
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
        loadingRelay.accept(true)
        photoRepository.getPhotos(albumId: albumId)
            .subscribe(onSuccess: { [weak self] photos in
                self?.photosRelay.accept(photos)
                self?.loadingRelay.accept(false)
            }, onFailure: { [weak self] error in
                self?.loadingRelay.accept(false)
                print("❌ Failed to load photos: \(error)")
            })
            .disposed(by: disposeBag)
    }
}