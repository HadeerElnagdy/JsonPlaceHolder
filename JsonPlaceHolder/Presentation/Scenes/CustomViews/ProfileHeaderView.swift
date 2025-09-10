import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    
    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.SystemImages.personIcon)
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.ProfileHeader.nameFontSize)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = Constants.UIStrings.emptyString
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.ProfileHeader.addressFontSize)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = Constants.UIStrings.emptyString
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
    }
    
    // MARK: - Setup
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.ProfileHeader.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.ProfileHeader.verticalPadding)
            make.size.equalTo(Constants.ProfileHeader.profileImageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constants.ProfileHeader.imageToTextSpacing)
            make.trailing.equalToSuperview().inset(Constants.ProfileHeader.horizontalPadding)
            make.top.equalTo(profileImageView.snp.top)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.ProfileHeader.nameToAddressSpacing)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalTo(nameLabel.snp.trailing)
            make.bottom.equalToSuperview().inset(Constants.ProfileHeader.verticalPadding)
        }
    }
    
    // MARK: - Public Methods
    func updateContent(name: String, address: String) {
        nameLabel.text = name.isEmpty ? Constants.ProfileHeader.fallbackName : name
        addressLabel.text = address.isEmpty ? Constants.ProfileHeader.fallbackAddress : address
    }
    
    override var intrinsicContentSize: CGSize {
        let width = UIScreen.main.bounds.width - (Constants.ProfileHeader.horizontalPadding * 2)
        let height = max(Constants.ProfileHeader.profileImageSize + (Constants.ProfileHeader.verticalPadding * 2), 
                        nameLabel.intrinsicContentSize.height + 
                        addressLabel.intrinsicContentSize.height + 
                        Constants.ProfileHeader.nameToAddressSpacing + 
                        (Constants.ProfileHeader.verticalPadding * 2))
        return CGSize(width: width, height: height)
    }
}
