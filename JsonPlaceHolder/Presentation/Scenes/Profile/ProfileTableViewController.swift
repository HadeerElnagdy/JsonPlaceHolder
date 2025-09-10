//
//  ProfileTableViewController.swift
//  JsonPlaceHolder
//
//  Created by Hadeer on 08.09.25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    private let viewModel: ProfileViewModelProtocol
    private let disposeBag = DisposeBag()
    private var albums: [String] = []
    private var albumIds: [Int] = []
    private var errorMessage: String?
    
    // MARK: - UI Components
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.backgroundColor = UIColor.systemBackground.withAlphaComponent(Constants.UI.activityIndicatorAlpha)
        indicator.layer.cornerRadius = Constants.UI.activityIndicatorCornerRadius
        indicator.layer.masksToBounds = true
        return indicator
    }()
    
    private lazy var headerContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = Constants.ProfileTableView.headerCornerRadius
        container.layer.masksToBounds = true
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = Constants.ProfileTableView.shadowOffset
        container.layer.shadowRadius = Constants.ProfileTableView.shadowRadius
        container.layer.shadowOpacity = Constants.ProfileTableView.shadowOpacity
        container.layer.masksToBounds = false
        
        return container
    }()
    
    private lazy var profileHeaderView: ProfileHeaderView = {
        return ProfileHeaderView(name: Constants.UIStrings.emptyString, address: Constants.UIStrings.emptyString) 
    }()
    
    // MARK: - Initialization
    init(viewModel: ProfileViewModelProtocol = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = ProfileViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        viewModel.loadProfile()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = Constants.UIStrings.profileTitle
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.ProfileTableView.cellIdentifier)
        
        if let navController = navigationController {
            navController.view.addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(Constants.UI.activityIndicatorSize)
            }
        } else {
            view.addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(Constants.UI.activityIndicatorSize)
            }
        }
    }
    
    private func setupHeader() {
        headerContainer.addSubview(profileHeaderView)
        
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.headerPadding)
            make.leading.equalToSuperview().offset(Constants.UI.headerPadding)
            make.trailing.equalToSuperview().offset(-Constants.UI.headerPadding)
            make.bottom.equalToSuperview().offset(-Constants.UI.headerPadding)
        }
        
        let headerWidth = view.bounds.width - (Constants.ProfileTableView.headerHorizontalMargin * 2)
        let headerHeight = calculateHeaderHeight()
        
        headerContainer.frame = CGRect(
            x: Constants.ProfileTableView.headerHorizontalMargin,
            y: 0,
            width: headerWidth,
            height: headerHeight
        )
        
        tableView.tableHeaderView = headerContainer
    }
    
    private func calculateHeaderHeight() -> CGFloat {
        let profileImageHeight = Constants.ProfileHeader.profileImageSize
        let verticalPadding = Constants.UI.headerPadding * Constants.UI.verticalPaddingMultiplier
        let nameHeight = Constants.UI.nameLabelHeight
        let nameToAddressSpacing = Constants.ProfileHeader.nameToAddressSpacing
        let addressHeight = Constants.UI.addressLabelHeight
        
        let totalHeight = max(profileImageHeight, nameHeight + nameToAddressSpacing + addressHeight) + verticalPadding
        return totalHeight
    }
    
    // MARK: - View Model Binding
    private func bindViewModel() {
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    if let navController = self.navigationController {
                        navController.view.bringSubviewToFront(self.activityIndicator)
                    } else {
                        self.view.bringSubviewToFront(self.activityIndicator)
                    }
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.isHidden = false
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.userInfo
            .drive(onNext: { [weak self] info in
                guard let self = self else { return }
                
                if self.tableView.tableHeaderView == nil {
                    self.setupHeader()
                }
                
                self.updateHeaderContent(name: info.name, address: info.address)
            })
            .disposed(by: disposeBag)
        
        viewModel.albums
            .drive(onNext: { [weak self] albums in
                self?.albums = albums
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.albumIds
            .drive(onNext: { [weak self] albumIds in
                self?.albumIds = albumIds
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .drive(onNext: { [weak self] errorMessage in
                self?.errorMessage = errorMessage
                if let errorMessage = errorMessage {
                    ErrorAlertView.showError(
                        in: self ?? UIViewController(),
                        message: errorMessage,
                        retryAction: { [weak self] in
                            self?.viewModel.loadProfile()
                        }
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Header Management
    private func updateHeaderContent(name: String, address: String) {
        profileHeaderView.updateContent(name: name, address: address)
        updateHeaderSize()
    }
    
    private func updateHeaderSize() {
        guard let headerView = tableView.tableHeaderView else { return }
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let newHeight = calculateHeaderHeight()
        
        if abs(headerView.frame.height - newHeight) > Constants.UI.headerHeightTolerance {
            var frame = headerView.frame
            frame.size.height = newHeight
            headerView.frame = frame
            
            tableView.tableHeaderView = headerView
        }
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.UIStrings.myAlbumsTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ProfileTableView.cellIdentifier, for: indexPath)
        cell.textLabel?.text = albums[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < albumIds.count else { return }
        
        let albumId = albumIds[indexPath.row]
        let albumDetailsVC = AlbumDetailsViewController(albumId: albumId)
        navigationController?.pushViewController(albumDetailsVC, animated: true)
    }
    
}
