//
//  CollectionViewCell.swift
//  SmoreProject
//
//  Created by Suha Baobaid on 3/4/22.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "ThumbnailCollectionViewCell"
    var index: IndexPath?
    var didTapDelete: ((IndexPath) -> Void)?
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = Size.SmallButton.size / 2
        button.backgroundColor = .black
        button.tintColor = .white
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: Size.SmallButton.size / 2), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.medium),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: Padding.small),
            deleteButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Padding.medium),
            deleteButton.widthAnchor.constraint(equalToConstant: Size.SmallButton.size),
            deleteButton.heightAnchor.constraint(equalToConstant: Size.SmallButton.size),
        ])
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    }
    
    func set(with data: Data, index: IndexPath) {
        imageView.image =  UIImage(data: data)!
        self.index = index
        
    }
    
    @objc func didTapDeleteButton() {
        guard let index = index else { return }
        didTapDelete?(index)
    }
    
}
