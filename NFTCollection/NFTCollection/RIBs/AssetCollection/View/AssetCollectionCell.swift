//
//  AssetCollectionCell.swift
//  NFTCollection
//
//  Created by Greener Chen on 2023/2/23.
//

import UIKit
import SnapKit
import SDWebImage

class AssetCollectionCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(nameLabel)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nameLabel.snp.top)
            make.height.equalTo(140)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    func bind(presenter: AssetCollectionCellPresenter) {
        imageView.sd_setImage(
            with: URL(string: presenter.imageUrl),
            placeholderImage: UIImage(systemName: "photo")
        )
        nameLabel.text = presenter.name
    }
}
