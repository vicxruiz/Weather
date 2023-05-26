//
//  BasicError.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import Foundation

/// The base protocol for defining an error.
protocol BaseError: Error {
    var title: String? { get }
    var message: String { get }
}

extension BaseError {
    
    /// Converts the error to a custom basic error.
    var asCustomBasicError: BasicError {
        .custom(title: title, message: message)
    }
}

/// The enumeration representing basic errors.
enum BasicError: BaseError, Equatable {
    case networkError
    case custom(title: String?, message: String)

    var title: String? {
        switch self {
        case .networkError:
            return Strings.Errors.networkError
        case .custom(let title, _):
            return title
        }
    }

    var message: String {
        switch self {
        case .networkError:
            return Strings.Errors.tryAgain
        case .custom(_, let message):
            return message
        }
    }
}

