//
//  HomeSectionHeaderView.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

/// Custom view for displaying section header info
final class HomeSectionHeaderView: UICollectionReusableView {
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel
            ],
            axis: .vertical,
            spacing: Layout.pd25
        )

        return stackView
    }()

    // MARK: Initializer
    
    /// Initializes the view with the specified frame.
    /// - Parameter frame: The frame rectangle for the cell, measured in points.
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(contentStackView)
        setConstraints()
    }

    // MARK: - Public Methods
    
    /// Sets the title and subtitle for the cell.
    ///
    /// - Parameters:
    ///   - title: The title to be displayed.
    ///   - subtitle: The subtitle to be displayed (optional).
    func set(title: String) {
        titleLabel.text = title

        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Layout.pd200,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
    }

    // MARK: - Helpers

    private func setConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Unavailable
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
