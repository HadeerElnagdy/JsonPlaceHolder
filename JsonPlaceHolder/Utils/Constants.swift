//
//  Constants.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 10.09.25.
//

import UIKit

enum Constants {
    
    // MARK: - API
    enum API {
        static let baseURL = "https://jsonplaceholder.typicode.com"
        static let picsumBaseURL = "https://picsum.photos"
        static let timeout: TimeInterval = 30.0
    }
    
    // MARK: - UI
    enum UI {
        static let animationDuration: TimeInterval = 0.3
        static let toolbarHeight: CGFloat = 44.0
        static let activityIndicatorCornerRadius: CGFloat = 8.0
        static let activityIndicatorAlpha: CGFloat = 0.8
        static let fadeTransitionDuration: TimeInterval = 0.3
        static let headerHeightTolerance: CGFloat = 0.1
        static let nameLabelHeight: CGFloat = 22.0
        static let addressLabelHeight: CGFloat = 60.0
        static let verticalPaddingMultiplier: CGFloat = 2.0
        static let activityIndicatorSize: CGFloat = 80.0
        static let headerPadding: CGFloat = 16.0
    }
    
    // MARK: - Image Viewer
    enum ImageViewer {
        static let minimumZoomScale: CGFloat = 0.5
        static let maximumZoomScale: CGFloat = 3.0
        static let doubleTapZoomScale: CGFloat = 2.0
        static let imageSize = CGSize(width: 800, height: 600)
        static let thumbnailSize = CGSize(width: 300, height: 300)
    }
    
    // MARK: - Profile Table View
    enum ProfileTableView {
        static let cellIdentifier = "AlbumCell"
        static let headerCornerRadius: CGFloat = 12
        static let headerHorizontalMargin: CGFloat = 16
        static let headerVerticalMargin: CGFloat = 8
        static let headerContentPadding: CGFloat = 12
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 4
        static let shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Album Details
    enum AlbumDetails {
        static let cellIdentifier = "PhotoCell"
        static let itemsPerRow: CGFloat = 3
        static let cellSpacing: CGFloat = 2
        static let searchBarHeight: CGFloat = 44
        static let searchBarPadding: CGFloat = 16
        static let collectionViewTopOffset: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 12
        static let titleLabelTopOffset: CGFloat = 4
        static let titleLabelHorizontalInset: CGFloat = 2
        static let emptyStateFontSize: CGFloat = 16
    }
    
    // MARK: - Profile Header
    enum ProfileHeader {
        static let profileImageSize: CGFloat = 50
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let imageToTextSpacing: CGFloat = 10
        static let nameToAddressSpacing: CGFloat = 2
        static let nameFontSize: CGFloat = 18
        static let addressFontSize: CGFloat = 14
        static let fallbackName = "Unknown"
        static let fallbackAddress = "Not Defined"
    }
    
    // MARK: - Error Messages
    enum ErrorMessages {
        static let unknownError = "Unknown error occurred"
    }
    
    // MARK: - Alert Messages
    enum AlertMessages {
        static let errorTitle = "Error"
        static let retryAction = "Retry"
        static let cancelAction = "Cancel"
    }
    
    // MARK: - UI Strings
    enum UIStrings {
        static let profileTitle = "Profile"
        static let albumPhotosTitle = "Album Photos"
        static let myAlbumsTitle = "My Albums"
        static let searchPlaceholder = "Search photos..."
        static let noPhotosFound = "No photos found"
        static let unknownUser = "Unknown User"
        static let noAddressAvailable = "No address available"
        static let emptyString = ""
    }
    
    // MARK: - System Images
    enum SystemImages {
        static let closeIcon = "xmark"
        static let photoPlaceholder = "photo"
        static let personIcon = "person"
        static let shareIcon = "square.and.arrow.up"
    }
    
    // MARK: - Error Domains
    enum ErrorDomains {
        static let invalidUserId = "InvalidUserId"
        static let typeCastError = "TypeCastError"
        static let testError = "TestError"
    }
    
    // MARK: - Test Data
    enum TestData {
        static let testUserId = 1
        static let testUserId2 = 2
        static let testUsername = "johndoe"
        static let testUsername2 = "janedoe"
        static let testEmail = "john@example.com"
        static let testEmail2 = "jane@example.com"
        static let testName = "John Doe"
        static let testName2 = "Jane Doe"
        static let testCity = "New York"
        static let testZipcode = "10001"
        static let testStreet = "123 Main St"
        static let testSuite = "Apt 1"
        static let testPhone = "123-456-7890"
        static let testWebsite = "johndoe.com"
        static let testAlbum1Title = "Album 1"
        static let testAlbum2Title = "Album 2"
    }
}
