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
    
    // MARK: - Constants
    private enum Constants {
        static let cellIdentifier = "AlbumCell"
        static let headerCornerRadius: CGFloat = 12
        static let headerHorizontalMargin: CGFloat = 16
        static let headerVerticalMargin: CGFloat = 8
        static let headerContentPadding: CGFloat = 12
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 4
        static let shadowOffset = CGSize(width: 0, height: 2)
    }
    
    // MARK: - Properties
    private let viewModel: ProfileViewModelProtocol
    private let disposeBag = DisposeBag()
    private var albums: [String] = []
    private var albumIds: [Int] = []
    
    // MARK: - UI Components
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var headerContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = Constants.headerCornerRadius
        container.layer.masksToBounds = true
        
        // Add subtle shadow
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = Constants.shadowOffset
        container.layer.shadowRadius = Constants.shadowRadius
        container.layer.shadowOpacity = Constants.shadowOpacity
        container.layer.masksToBounds = false
        
        return container
    }()
    
    private lazy var profileHeaderView: ProfileHeaderView = {
        return ProfileHeaderView(name: "", address: "") 
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
        viewModel.loadProfile()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Profile"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        
        // Setup activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func setupHeader() {
        headerContainer.addSubview(profileHeaderView)
        
        // Setup header constraints with proper padding
        profileHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let headerWidth = view.bounds.width - (Constants.headerHorizontalMargin * 2)
        let headerHeight = calculateHeaderHeight()
        
        // Set container frame
        headerContainer.frame = CGRect(
            x: Constants.headerHorizontalMargin,
            y: 0,
            width: headerWidth,
            height: headerHeight
        )
        
        // Set as table header
        tableView.tableHeaderView = headerContainer
    }
    
    private func calculateHeaderHeight() -> CGFloat {
        // Calculate dynamic height based on content
        let profileImageHeight = 50.0 // ProfileHeaderView Constants.profileImageSize
        let verticalPadding = 16.0 * 2 // top + bottom padding
        let nameHeight = 22.0 // Approximate height for name label
        let nameToAddressSpacing = 2.0 // Constants.nameToAddressSpacing
        let addressHeight = 60.0 // Increased space for address (can wrap to multiple lines)
        
        let totalHeight = max(profileImageHeight, nameHeight + nameToAddressSpacing + addressHeight) + verticalPadding
        return totalHeight
    }
    
    // MARK: - View Model Binding
    private func bindViewModel() {
        // Loading state binding
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        // User info binding - setup header only when data is available
        viewModel.userInfo
            .drive(onNext: { [weak self] info in
                guard let self = self else { return }
                
                // Setup header only if it hasn't been set up yet
                if self.tableView.tableHeaderView == nil {
                    self.setupHeader()
                }
                
                // Update header content with actual data
                self.updateHeaderContent(name: info.name, address: info.address)
            })
            .disposed(by: disposeBag)
        
        // Albums binding
        viewModel.albums
            .drive(onNext: { [weak self] albums in
                self?.albums = albums
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        // Album IDs binding
        viewModel.albumIds
            .drive(onNext: { [weak self] albumIds in
                self?.albumIds = albumIds
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
        
        // Force layout update
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        // Calculate new height
        let newHeight = calculateHeaderHeight()
        
        // Update frame if height changed
        if abs(headerView.frame.height - newHeight) > 0.1 {
            var frame = headerView.frame
            frame.size.height = newHeight
            headerView.frame = frame
            
            // Reassign to trigger layout update
            tableView.tableHeaderView = headerView
        }
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Albums"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
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
