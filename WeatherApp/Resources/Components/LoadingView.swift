//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit
import SnapKit

final class LoadingView: UIView {

    // MARK: - Properties

    lazy var activityIndicator: ActivityIndicator = {
        let view = ActivityIndicator(size: .medium)
        view.startAnimating()
        return view
    }()

    // MARK: - Initialization

    public init() {
        super.init(frame: .zero)
        addSubview(activityIndicator)
        setConstraints()
    }

    // MARK: - Layout

    private func setConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Unavailable

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
