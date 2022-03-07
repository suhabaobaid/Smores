//
//  LightningCollectionViewCell.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import UIKit

class LightningCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LightningCollectionViewCell"
    
    // MARK: - UI
    let imageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(systemName: "questionmark.circle"))
        imageView.contentScaleFactor = 0.5
        imageView.tintColor = .white
        imageView.backgroundColor = Colors.orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = Colors.orange
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.93, alpha: 1)
        contentView.layer.cornerRadius = 14
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        imageView.layer.cornerRadius = 12
    }
    
    func set(with question: String) {
        self.label.text = question
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        label.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
