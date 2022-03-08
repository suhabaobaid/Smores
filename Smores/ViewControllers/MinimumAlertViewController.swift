//
//  MinimumAlertViewController.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import UIKit

class MinimumAlertViewController: UIViewController {

    // MARK: - UI
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var icon: UIImageView
    var messageLabel: UILabel

    
    // MARK: - init
    init(message: String, icon: UIImage?, color: UIColor = .green) {

        
        messageLabel = UILabel()
        messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .left
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        
        self.icon = UIImageView(image: icon)
        self.icon.tintColor = .white
        self.containerView.backgroundColor = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        configureIcon()
        configureBodyLabel()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            containerView.widthAnchor.constraint(equalToConstant: view.bounds.width - 30),
        ])
        
        containerView.addSubview(icon)
        containerView.addSubview(messageLabel)
    }
    
    func configureIcon() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            icon.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configureBodyLabel() {
        messageLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}
