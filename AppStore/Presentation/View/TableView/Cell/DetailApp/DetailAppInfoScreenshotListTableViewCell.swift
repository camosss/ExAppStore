//
//  DetailAppInfoScreenshotListTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

final class DetailAppInfoScreenshotListTableViewCell: BaseTableViewCell<[String]> {

    // MARK: - Properties

    var onHeightUpdated: (() -> Void)?

    private var maxHeight: CGFloat = 0
    private var screenshotUrls: [String] = []

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCompositionalLayout()
    )

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(collectionView)
    }

    override func setConstraints() {
        super.setConstraints()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        setCollectionView()
    }

    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
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

        guard let model = model, !model.isEmpty else {
            return
        }

        self.screenshotUrls = model
        self.adjustCollectionViewHeight(for: model)
        self.collectionView.reloadData()
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { 
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets.trailing = 10

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.6),
                heightDimension: .fractionalHeight(1.0)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16, leading: 24, bottom: 16, trailing: 24)
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }
    }

    private func adjustCollectionViewHeight(for urls: [String]) {
        let expectedImageViewWidth = (UIScreen.main.bounds.width + 10) * 0.6

        for urlString in urls {

            loadImage(
                for: urlString,
                imageViewWidth: expectedImageViewWidth
            ) { [weak self] calculatedHeight in
                guard let self = self,
                      let calculatedHeight = calculatedHeight
                else { return }

                if calculatedHeight > self.maxHeight {
                    self.maxHeight = calculatedHeight

                    DispatchQueue.main.async {
                        self.collectionView.snp.updateConstraints { make in
                            make.height.equalTo(self.maxHeight)
                        }
                        self.onHeightUpdated?()
                    }
                }
            }
        }
    }

    private func loadImage(
        for urlString: String,
        imageViewWidth: CGFloat,
        completion: @escaping (CGFloat?) -> Void
    ) {
        let dummyImageView = UIImageView()
        dummyImageView.loadImage(with: urlString) { imageSize in
            guard let size = imageSize else {
                completion(nil)
                return
            }

            let aspectRatio = size.height / size.width
            let calculatedHeight = imageViewWidth * aspectRatio
            completion(calculatedHeight)
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
