//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit
import SnapKit

class ErrorView: UIView {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [titleLabel, messageLabel],
            axis: .vertical,
            spacing: Layout.pd100
        )
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Layout.pd100,
            bottom: 0,
            trailing: Layout.pd100
        )
        view.alignment = .fill
        view.distribution = .fill

        return view
    }()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(subview: stackView)
        view.alwaysBounceVertical = true
        return view
    }()

    var reloadClosure: (() -> Void)?

    var error: Error = BasicError.networkError {
        didSet {
            if let error = error as? BaseError {
                self.titleLabel.text = error.title
                self.messageLabel.text = error.message
            } else {
                self.titleLabel.text = Strings.Errors.somethingWentWrong
            }
        }
    }

    init() {
        super.init(frame: .zero)

        addSubview(scrollView)

        setConstraints()
    }

    @objc func reloadButtonTapped() {
        reloadClosure?()
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Layout.pd300)
            make.leading.trailing.width.equalToSuperview()
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
