//
//  GalleryCollectionView.swift
//  GalleryCollectionView
//
//  Created by MisnikovRoman on 26.02.2020.
//  Copyright © 2020 Роман Мисников. All rights reserved.
//

import UIKit
import TinyConstraints

final public class ImageCell: UICollectionViewCell {
    private var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage?) {
        self.imageView.image = image
        self.imageView.layer.cornerRadius = 8
        self.imageView.layer.masksToBounds = true
    }

    private func setup() {
        self.contentView.addSubview(self.imageView)
        self.imageView.edgesToSuperview()
    }
}

final public class GalleryCollectionView: UICollectionView {

    var images: [UIImage] = [] { didSet { self.reloadData() } }

    private(set) var imageHeight: CGFloat = 0
    private let reuseId = "ImageCell"

    convenience init(height: CGFloat, images: [UIImage] = []) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: height - 16, height: height - 16 )
        layout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: layout)
        self.imageHeight = height
        self.images = images
        self.setup()
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: self.imageHeight)
    }

    func setup() {
        self.backgroundColor = .white
        self.register(ImageCell.self, forCellWithReuseIdentifier: self.reuseId)
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseId,
                                                              for: indexPath)
        guard let cell = dequeuedCell as? ImageCell else { return UICollectionViewCell() }
        cell.configure(with: self.images[indexPath.item])
        return cell
    }
}
