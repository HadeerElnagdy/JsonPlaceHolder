//
//  AlbumDetailsViewController.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class AlbumDetailsViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let cellIdentifier = "PhotoCell"
        static let itemsPerRow: CGFloat = 3
        static let cellSpacing: CGFloat = 2
        static let searchBarHeight: CGFloat = 44
        static let searchBarPadding: CGFloat = 16
    }
    
    // MARK: - Properties
    private let viewModel: AlbumDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    private var photos: [Photo] = []
    private var filteredPhotos: [Photo] = []
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search photos..."
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.cellSpacing
        layout.minimumLineSpacing = Constants.cellSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No photos found"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Init
    init(viewModel: AlbumDetailsViewModelProtocol = AlbumDetailsViewModel(), albumId: Int) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.loadPhotos(albumId: albumId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Album Photos"
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(Constants.searchBarPadding)
            make.height.equalTo(Constants.searchBarHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Loading state
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Photos binding
        viewModel.filteredPhotos
            .drive(onNext: { [weak self] photos in
                self?.filteredPhotos = photos
                self?.collectionView.reloadData()
                self?.updateEmptyState()
            })
            .disposed(by: disposeBag)
        
        // Search text binding
        searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
    }
    
    private func updateEmptyState() {
        emptyStateLabel.isHidden = !filteredPhotos.isEmpty
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! PhotoCell
        let photo = filteredPhotos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = filteredPhotos[indexPath.item]
        
        // Get the cached image from the cell if available
        var cachedImage: UIImage?
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cachedImage = cell.getCachedFullSizeImage()
        }
        
        let imageViewerVC = ImageViewerViewController(photo: photo, cachedImage: cachedImage)
        present(imageViewerVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AlbumDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = Constants.cellSpacing * (Constants.itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - totalSpacing
        let cellWidth = availableWidth / Constants.itemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

// MARK: - UISearchBarDelegate
extension AlbumDetailsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText.accept(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - PhotoCell
class PhotoCell: UICollectionViewCell {
    
    // Store the cached full-size image
    private var cachedFullSizeImage: UIImage?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(2)
        }
    }
    
    func configure(with photo: Photo) {
        titleLabel.text = photo.title
        
        // Load thumbnail for display
        imageView.kf.setImage(with: URL(string: photo.picsumThumbnailUrl))
        
        // Preload and cache the full-size image in the background
        if let fullSizeURL = URL(string: photo.picsumUrl) {
            KingfisherManager.shared.retrieveImage(with: fullSizeURL) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let value):
                        self?.cachedFullSizeImage = value.image
                    case .failure(let error):
                        print("Failed to cache full-size image: \(error)")
                    }
                }
            }
        }
    }
    
    func getCachedFullSizeImage() -> UIImage? {
        return cachedFullSizeImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        titleLabel.text = nil
        cachedFullSizeImage = nil
    }
}