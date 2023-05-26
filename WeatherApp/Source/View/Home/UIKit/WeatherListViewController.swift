//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/25/23.
//

import UIKit
import SnapKit

enum WeatherListSectionType: Hashable {
    case currentLocation
    case recents
    case search

    var title: String {
        switch self {
        case .currentLocation:
            return Strings.Home.currentLocation
        case .recents:
            return Strings.Home.recents
        case .search:
            return Strings.Home.searchResults
        }
    }
}

enum WeatherListCellType: Hashable {
    case currentLocation(WeatherResponse)
    case search(WeatherResponse)
}

/// Main list view controller for displaying weather section data for current location, recents, and search
final class WeatherListViewController: StatefulViewController {
    // MARK: - Constants
    
    private enum Constants {
        static let sectionHeaderSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(70.0)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        static let searchSectionHeight: CGFloat = 100.0
        static let currenctLocationSectionHeight: CGFloat = 310.0
        static let currentLocationSectionWidth: CGFloat = 326.0
        static let searchBarHeight: CGFloat = 40.0
    }
    
    // MARK: - Properties

    private typealias DataSource = UICollectionViewDiffableDataSource<WeatherListSectionType, WeatherListCellType>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<WeatherListSectionType, WeatherListCellType>

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.alwaysBounceVertical = false
        collectionView.clipsToBounds = true
        collectionView.delegate = self

        collectionView.register(
            supplementaryViewType: HomeSectionHeaderView.self,
            ofKind: UICollectionView.elementKindSectionHeader
        )
        
        collectionView.register(cellType: CurrentLocationCell.self)
        collectionView.register(cellType: SearchCell.self)

        return collectionView
    }()

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, type in
                guard let self = self else { return UICollectionViewCell() }
                let cell = self.cellProvider(for: collectionView, indexPath: indexPath, type: type)
                return cell
            }
        )

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }

            let header = self.headerProvider(for: collectionView, kind: kind, indexPath: indexPath)
            return header
        }

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        return dataSource
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = Strings.Home.searchPlaceholder
        bar.searchBarStyle = .minimal
        bar.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
        return bar
    }()
    
    private lazy var contentStackView = UIStackView(
        arrangedSubviews: [searchBar, collectionView],
        axis: .vertical
    )

    private let viewModel: WeatherListModelType
    
    // MARK: - Initialization

    init(
        viewModel: WeatherListModelType
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
        content = contentStackView
        setupViews()
    }

    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.outputs.viewState = { [weak self] newState in
            guard let self = self else { return }
            self.viewState = newState
        }

        viewModel.outputs.cellTypes = { [weak self] types in
            guard let self = self else { return }
            self.updateDataSource(rowTypes: types)
        }
    }

    // MARK: - Helpers
    
    private func setupViews() {
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchBarHeight)
        }
    }
    
    private func updateDataSource(rowTypes: [WeatherListSectionCellConfig]) {
        var snapshot = Snapshot()

        // Define the order of sections
        let sectionOrder: [WeatherListSectionType] = [
            .search,
            .currentLocation,
            .recents,
        ]

        // Iterate through the section order and add sections and items to the snapshot
        for sectionType in sectionOrder {
            // Find the corresponding section configuration for the current section type
            guard let sectionConfig = rowTypes.first(where: { $0.section == sectionType }) else {
                continue
            }
            
            // Remove duplicate items using a set
            let uniqueItems = Array(Set(sectionConfig.cells))
            
            // Add the section and its unique items to the snapshot
            snapshot.appendSections([sectionType])
            snapshot.appendItems(uniqueItems, toSection: sectionType)
        }

        // Apply the snapshot to the data source
        dataSource.apply(snapshot, animatingDifferences: false)
    }


    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionNumber, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionNumber]
            switch sectionType {
            case .currentLocation:
                return self.getCurrentLocationSectionLayout()
            case .recents:
                return self.getRecentsSectionLayout()
            case .search:
                return self.getSearchSectionLayout()
            }
        })
    }

    private func cellProvider(
        for collectionView: UICollectionView,
        indexPath: IndexPath,
        type: WeatherListCellType
    ) -> UICollectionViewCell {
        switch type {
        case .currentLocation(let weatherResponse):
            let cell: CurrentLocationCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(weatherResponse)
            return cell
        case .search(let weatherResponse):
            let cell: SearchCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(weatherResponse)
            return cell
        }
    }

    private func headerProvider(
        for collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView {

        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: indexPath,
            viewType: HomeSectionHeaderView.self
        )

        let sectionType = dataSource.snapshot().sectionIdentifiers[indexPath.section]

        sectionHeaderView.set(title: sectionType.title)
        
        return sectionHeaderView
    }

    // MARK: Layout configuration
    private func getCurrentLocationSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constants.currenctLocationSectionHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.pd75
        section.contentInsets = NSDirectionalEdgeInsets(all: Layout.pd100)

        section.boundarySupplementaryItems = [Constants.sectionHeaderSupplementaryItem]

        return section
    }

    private func getRecentsSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.searchSectionHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.pd75
        section.contentInsets = NSDirectionalEdgeInsets(all: Layout.pd100)

        section.boundarySupplementaryItems = [Constants.sectionHeaderSupplementaryItem]

        return section
    }
    
    private func getSearchSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.searchSectionHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.pd75
        section.contentInsets = NSDirectionalEdgeInsets(all: Layout.pd100)

        section.boundarySupplementaryItems = [Constants.sectionHeaderSupplementaryItem]

        return section
    }
}

extension WeatherListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.inputs.didTapCell(with: type)
    }
}

extension WeatherListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.inputs.didTapSearch(for: text)
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
