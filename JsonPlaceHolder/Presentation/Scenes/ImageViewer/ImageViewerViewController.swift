//
//  ImageViewerViewController.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import UIKit
import SnapKit
import Kingfisher

final class ImageViewerViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let minimumZoomScale: CGFloat = 0.5
        static let maximumZoomScale: CGFloat = 3.0
        static let doubleTapZoomScale: CGFloat = 2.0
        static let animationDuration: TimeInterval = 0.3
        static let toolbarHeight: CGFloat = 44
        static let safeAreaPadding: CGFloat = 16
    }
    
    // MARK: - Properties
    private let photo: Photo
    private let cachedImage: UIImage?
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let toolbar = UIToolbar()
    private let shareButton = UIBarButtonItem()
    private let closeButton = UIBarButtonItem()
    
    // MARK: - Init
    init(photo: Photo, cachedImage: UIImage? = nil) {
        self.photo = photo
        self.cachedImage = cachedImage
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScrollView()
        loadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(scrollView.bounds.size)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Setup image view
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            // Width and height will be set programmatically based on image size
        }
        
        // Setup toolbar
        setupToolbar()
        
        // Setup gestures
        setupGestures()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    private func setupToolbar() {
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.toolbarHeight)
        }
        
        // Setup toolbar items
        closeButton.image = UIImage(systemName: "xmark")
        closeButton.target = self
        closeButton.action = #selector(closeButtonTapped)
        
        shareButton.image = UIImage(systemName: "square.and.arrow.up")
        shareButton.target = self
        shareButton.action = #selector(shareButtonTapped)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [
            closeButton,
            flexibleSpace,
            shareButton
        ]
        
        // Style toolbar
        toolbar.barStyle = .black
        toolbar.isTranslucent = true
    }
    
    private func setupGestures() {
        // Single tap to toggle toolbar
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGesture)
    }
    
    private func loadImage() {
        // Use cached image if available, otherwise load from URL
        if let cachedImage = cachedImage {
            imageView.image = cachedImage
            DispatchQueue.main.async {
                self.updateMinZoomScaleForSize(self.scrollView.bounds.size)
            }
        } else {
            guard let imageURL = URL(string: photo.picsumUrl) else { return }
            
            imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.imageView.image = value.image
                    DispatchQueue.main.async {
                        self?.updateMinZoomScaleForSize(self?.scrollView.bounds.size ?? .zero)
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let image = imageView.image else { return }
        
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        scrollView.zoomScale = minScale
        
        // Set the image view frame to the image size
        imageView.frame = CGRect(origin: .zero, size: image.size)
        
        // Set the content size to the image size
        scrollView.contentSize = image.size
        
        // Center the image
        centerImage()
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let image = imageView.image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image, photo.title],
            applicationActivities: nil
        )
        
        // For iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.barButtonItem = shareButton
        }
        
        present(activityViewController, animated: true)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            // Zoom out
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            // Zoom in
            let zoomScale = Constants.doubleTapZoomScale
            let zoomRect = zoomRectForScale(zoomScale, center: gesture.location(in: gesture.view))
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        let isHidden = toolbar.isHidden
        UIView.animate(withDuration: Constants.animationDuration) {
            self.toolbar.alpha = isHidden ? 1.0 : 0.0
        } completion: { _ in
            self.toolbar.isHidden = !isHidden
        }
    }
    
    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        let zoomRectSize = CGSize(
            width: scrollView.bounds.size.width / scale,
            height: scrollView.bounds.size.height / scale
        )
        
        return CGRect(
            x: center.x - zoomRectSize.width / 2,
            y: center.y - zoomRectSize.height / 2,
            width: zoomRectSize.width,
            height: zoomRectSize.height
        )
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        // Horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        // Vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
}
