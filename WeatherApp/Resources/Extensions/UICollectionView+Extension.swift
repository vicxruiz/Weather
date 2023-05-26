//
//  UICollectionView+Extension.swift
//  WeatherApp
//
//  Created by Victor Ruiz on 5/26/23.
//

import UIKit

extension UICollectionView {
    final func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the" +
                " cell is registered with table view"
            )
        }
        return cell
    }

    final func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }


    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: String(describing: viewType),
            for: indexPath
        )
        guard let typedView = view as? T else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: viewType)), make sure the" +
                " cell is registered with collection view"
            )
        }
        return typedView
    }

    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String) {
        self.register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: String(describing: supplementaryViewType)
        )
    }
}
