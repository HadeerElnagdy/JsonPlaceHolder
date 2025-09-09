import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    // MARK: - Constants
    private enum Constants {
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
    
    // MARK: - UI Components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = Constants.profileImageSize / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.size.equalTo(Constants.profileImageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constants.imageToTextSpacing)
            make.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            make.top.equalTo(profileImageView.snp.top)
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
    }
    
    override var intrinsicContentSize: CGSize {
        let width = UIScreen.main.bounds.width - (Constants.horizontalPadding * 2)
        let height = max(Constants.profileImageSize + (Constants.verticalPadding * 2), 
                        nameLabel.intrinsicContentSize.height + 
                        addressLabel.intrinsicContentSize.height + 
                        Constants.nameToAddressSpacing + 
                        (Constants.verticalPadding * 2))
        return CGSize(width: width, height: height)
    }
}