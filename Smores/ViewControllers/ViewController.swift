//
//  ViewController.swift
//  CustomKeyboardInputView
//
//  Created by Felipe Florencio Garcia on 19/10/2020.
//

import UIKit
import MessageKit

class ViewController: UIViewController, KeyboardInputAccessoryViewProtocol {
  
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 0.96, green: 0.73, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.91, green: 0.23, blue: 0.23, alpha: 1).cgColor,
        ]
        gradient.locations = [0, 0.25, 1]
        
        return gradient
    }()
    
    // Create lazy view
    private lazy var keyboardView: KeyboardInputAccessoryView = {
        return KeyboardInputAccessoryView.view(controller: self)
    }()
    private var imagePicker: ImagePickerController?
    
    private lazy var chatButton: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = Colors.orange
        button.tintColor = .white
        button.setTitle("SEND CHAT", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showKeyboard(_:)), for: .touchUpInside)
        return button
    }()
    
    var images: [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTapRecognizer()
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        configure()
        imagePicker = ImagePickerController(presentationController: self, delegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.images = []
        self.keyboardView.inputTextView.text = nil
        self.keyboardView.didSelectImages = false
    }
    
    private func configure() {
        view.addSubview(chatButton)
        
        NSLayoutConstraint.activate([
            chatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.medium),
            chatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.medium),
            chatButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    // MARK: - Custom keyboard input view
    override var inputAccessoryView: UIView? {
        return keyboardView.canBecomeFirstResponder ? keyboardView : nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return keyboardView.canBecomeFirstResponder
    }
    
    // MARK: IBAction
    @objc func showKeyboard(_ sender: UIButton) {
        self.keyboardView.showKeyboard()
    }
    
    // MARK: - Keyboard delegate
    func send(data type: String) {
        var messages: [LocalMessage] = []
        let currentUser = Sender(senderId: "1", displayName: "Suha")
        
        if !type.isEmpty, type != "" {
            messages.append(LocalMessage(senderId: currentUser.senderId, messageId: UUID().uuidString, sentDate: Date.now, contentType: .text, content: type))
        }
        
        for image in images {
            if let stringImage = UIImage(data: image)?.toJpegString(compressionQuality: 1) {
                messages.append(LocalMessage(senderId: currentUser.senderId, messageId: UUID().uuidString, sentDate: Date.now, contentType: .image, content: stringImage))
            }
            
        }
        
        
        PersistenceManager.shared.save(messages: messages)
        
        let chatVC = ChatViewController()
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func scrollView() -> UIScrollView? {
        // We don't have any scroll view or table view, but if you have just pass the reference here :-)
        // For example would be: self.tableView
        return nil
    }
    
    func openImagePicker() {
        imagePicker?.present(from: self.view)
        keyboardView.dismissKeyboard()
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardTapped() {
        self.keyboardView.dismissKeyboard()
    }
}

extension ViewController: ImageViewControllerDelegate {
    
    func didSelect(image: UIImage?) {
        
        guard let image = image else {
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.5) else { fatalError("Coudln't convert image") }
        self.images.append(imageData)
        self.keyboardView.didSelectImages = true
        self.keyboardView.showKeyboard()
        
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier, for: indexPath) as! ThumbnailCollectionViewCell
        cell.set(with: images[indexPath.row], index: indexPath)
        cell.didTapDelete = { [weak self] index in
            self?.didTapDelete(at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        didTapDelete(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Size.ThumbnailCell.width, height: Size.ThumbnailCell.height)
    }
    
    func didTapDelete(at indexPath: IndexPath) {
        keyboardView.imagesCollectionView.deleteItems(at: [indexPath])
        images.remove(at: indexPath.row)
        if images.isEmpty {
            self.keyboardView.didSelectImages = false
            self.keyboardView.invalidateIntrinsicContentSize()
        }
    }
}

