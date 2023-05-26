//
//  StatefulViewController.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit
import SnapKit

enum ViewState: Equatable {
    case content
    case loading
    case error(BasicError)
}

class StatefulViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let transitionDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    public var viewState: ViewState = .content {
        didSet {
            transitionToViewState(animated: true)
        }
    }

    // Views
    public lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        return view
    }()

    private lazy var contentWrapper = UIView()

    public var content: UIView? {
        didSet {
            oldValue?.removeFromSuperview()

            guard let content = content else {
                return
            }

            contentWrapper.addSubview(content)

            content.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    private lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [contentWrapper], axis: .vertical)
        view.isHidden = true
        return view
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.reloadClosure = { [weak self] in
            guard let self = self else { return }
            print("Reload")
        }
        view.isHidden = true
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(contentView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        setConstraints()
        transitionToViewState(animated: false)
    }
    
    // MARK: - Public Methods

    public func addHeaderContent(_ content: UIView) {
        guard let index = contentView.arrangedSubviews.firstIndex(of: contentWrapper) else {
            return
        }
        contentView.insertArrangedSubview(content, at: index)
    }

    public func addFooterContent(_ content: UIView) {
        contentView.addArrangedSubview(content)
    }

    // MARK: - Helpers

    private func transitionToViewState(animated: Bool) {
        if case .error(let error) = viewState {
            errorView.error = error
        }

        let swapActiveView = { [self] in
            loadingView.isHidden = true
            contentView.isHidden = true
            errorView.isHidden = true

            switch viewState {
            case .loading:
                loadingView.isHidden = false
            case .content:
                contentView.isHidden = false
            case .error:
                errorView.isHidden = false
            }
        }

        if animated {
            UIView.transition(
                with: containerView,
                duration: Constants.transitionDuration,
                options: [.transitionCrossDissolve, .curveEaseInOut],
                animations: swapActiveView
            )
        } else {
            swapActiveView()
        }
    }

    private func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

