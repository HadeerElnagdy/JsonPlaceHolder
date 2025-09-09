//
//  ProfileHeaderView.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 09.09.25.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let profileImageSize: CGFloat = 50
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 8
        static let imageToTextSpacing: CGFloat = 10
        static let nameToAddressSpacing: CGFloat = 2
        static let nameFontSize: CGFloat = 18
        static let addressFontSize: CGFloat = 14
        static let defaultName = "Loading..."
        static let defaultAddress = "Please wait..."
        static let fallbackName = "Unknown"
        static let fallbackAddress = "Not Defined"
    }
    
    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = Constants.profileImageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.nameFontSize)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "" 
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.addressFontSize)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.lineSpacing = 2.0 // Add line spacing for better readability
        label.text = "" 
        return label
    }()
    
    // MARK: - Initialization
    init(name: String, address: String) {
        super.init(frame: .zero)
        setupViews()
        updateContent(name: name, address: address)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        updateContent(name: Constants.fallbackName, address: Constants.fallbackAddress)
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.profileImageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constants.imageToTextSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.nameToAddressSpacing)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
            make.bottom.equalToSuperview().inset(Constants.verticalPadding)
        }
    }
    
    // MARK: - Public Methods
    func updateContent(name: String, address: String) {
        nameLabel.text = name.isEmpty ? Constants.fallbackName : name
        addressLabel.text = address.isEmpty ? Constants.fallbackAddress : address
        
        // Trigger layout update if needed
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        let imageHeight = Constants.profileImageSize
        let textHeight = nameLabel.intrinsicContentSize.height + 
                        addressLabel.intrinsicContentSize.height + 
                        Constants.nameToAddressSpacing
        let contentHeight = max(imageHeight, textHeight)
        
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: contentHeight + (Constants.verticalPadding * 2)
        )
    }
}
