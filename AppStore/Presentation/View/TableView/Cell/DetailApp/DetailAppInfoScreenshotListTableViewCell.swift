//
//  DetailAppInfoScreenshotListTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

final class DetailAppInfoScreenshotListTableViewCell: BaseTableViewCell<[String]> {

    // MARK: - Properties

    private var screenshotUrls: [String] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        return collectionView
    }()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(collectionView)
    }

    override func setConstraints() {
        super.setConstraints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        setCollectionView()
    }

    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.bottom = 40
        collectionView.register(
            ScreenshotListCollectionViewCell.self,
            forCellWithReuseIdentifier: ScreenshotListCollectionViewCell.reuseIdentifier
        )
    }

    override func bind(_ model: [String]?) {
        super.bind(model)

        if let model = model {
            self.screenshotUrls = model
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DetailAppInfoScreenshotListTableViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return screenshotUrls.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScreenshotListCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! ScreenshotListCollectionViewCell

        let screenshotUrl = screenshotUrls[indexPath.row]
        cell.bind(screenshotUrl)
        return cell
    }
}
