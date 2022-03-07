//
//  KeyboardInputAccessoryView.swift
//  CustomKeyboardInputView
//
//  Created by Felipe Florencio Garcia on 19/10/2020.
//

import UIKit

protocol KeyboardInputAccessoryViewProtocol: UICollectionViewDelegate, UICollectionViewDataSource where Self: UIViewController {
    
    func send(data type: String)
    
    func openImagePicker()
    
    // Keyboard automatically adjusts your scroll view inset
    func scrollView() -> UIScrollView?
}

internal struct InputContainerViewConstants {
    static let maxInputMessageContainerViewHeight: CGFloat = 200
    static let containerInsetsDefault = UIEdgeInsets(top: 12, left: 8, bottom: 8, right: 30)
}

class KeyboardInputAccessoryView: UIView {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var LightningCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private weak var delegate: KeyboardInputAccessoryViewProtocol?
    private weak var hostViewController: KeyboardInputAccessoryViewProtocol?
    private var firstResponder: Bool = false
    private var inputMessageTextViewHeight: CGFloat = 0
    var didSelectImages = false {
        didSet {
            if didSelectImages {
                imagesCollectionView.backgroundColor = .white
            } else {
                imagesCollectionView.backgroundColor = .clear
            }
            imagesCollectionView.reloadData()
        }
    }
    var showLightningView = false {
        didSet {
//            LightningCollectionView.reloadData()
        }
    }
    
    class func view(controller: KeyboardInputAccessoryViewProtocol) -> KeyboardInputAccessoryView {
        guard let view = Bundle.main.loadNibNamed(String(describing: KeyboardInputAccessoryView.self), owner: nil, options: nil)?.first as? KeyboardInputAccessoryView else { fatalError() }
        view.delegate = controller
        view.inputTextView.delegate = view
        view.hostViewController = controller
        view.imagesCollectionView.delegate = controller
        view.imagesCollectionView.dataSource = controller
        setupUI(view: view)
        return view
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Control the automatic expansion of the text view
    // as also control the maximum size that can grow
    override var intrinsicContentSize: CGSize {
        let size = textViewSize(height: &inputMessageTextViewHeight,
                                maxInputHeight: InputContainerViewConstants.maxInputMessageContainerViewHeight,
                                textView: inputTextView)
        self.inputHeightConstraint.constant = size.height
        self.collectionViewHeightConstraint.constant = self.didSelectImages ? 80 : 0
//        self.LightningCollectionViewHeightConstraint.constant = self.showLightningView ? 120 : 0
        return CGSize(width: size.width, height: size.height + 50 + (self.didSelectImages ? 80 : 0))
    }
    
    override var canBecomeFirstResponder: Bool {
        return firstResponder
    }
    
    class private func setupUI(view: KeyboardInputAccessoryView) {
        view.inputTextView.font = UIFont.systemFont(ofSize: 12)
        view.inputTextView.isScrollEnabled = false
        view.placeholderLabel.numberOfLines = 2
        view.placeholderLabel.text = "Need an icebreaker? Tap on the lightning bolt"
        view.placeholderLabel.font = UIFont.systemFont(ofSize: 12)
        view.inputTextView.textContainerInset = InputContainerViewConstants.containerInsetsDefault
        view.imagesCollectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        view.imagesCollectionView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if didSelectImages {
            self.inputTextView.cornerRadius(usingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 26, height: 26))
            self.imagesCollectionView.cornerRadius(usingCorners: [.bottomLeft], cornerRadii: CGSize(width: 26, height: 26))
        } else {
            self.inputTextView.cornerRadius(usingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 26, height: 26))
        }
        
        self.sendButton.cornerRadius(usingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 26, height: 26))
    }
    
    // MARK: - Actions Buttons
    @IBAction func send(_ sender: UIButton) {
        delegate?.send(data: self.inputTextView.text)
        dismissKeyboard()
    }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        delegate?.openImagePicker()
    }
    
    @IBAction func lightningButtonTapped(_ sender: UIButton) {
        print("Lightning")
        self.showLightningView = true
    }
    
    // MARK: - Public functions
    func showKeyboard() {
        setupKeyboardNotification()
        
        DispatchQueue.main.async {
            
            self.firstResponder = true
            self.delegate?.becomeFirstResponder()
            self.inputTextView.becomeFirstResponder()
        }
    }
    
    func dismissKeyboard() {
        firstResponder = false
        self.inputTextView.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    private func textViewSize(height: inout CGFloat,
                              maxInputHeight: CGFloat,
                              textView: UITextView) -> CGSize {
        var textSize = textView.sizeThatFits(CGSize(width: textView.bounds.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        
        let textViewSize = textView.bounds.size
        
        if textSize.height < textViewSize.height {
            textSize = textViewSize
        }
        
        if textSize.height >= maxInputHeight {
            height = maxInputHeight
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            height = textSize.height
        }
        invalidateIntrinsicContentSize() // invalidate before layout
        setNeedsLayout()
        return CGSize(width: self.bounds.width, height: height)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard avoid
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let scrollView = self.hostViewController?.scrollView(), let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let size = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = size
            scrollView.scrollIndicatorInsets = size
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height), animated: true) // Scrolls to end
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.hostViewController?.scrollView()?.contentInset = .zero
        self.hostViewController?.scrollView()?.scrollIndicatorInsets = .zero
    }
}

extension KeyboardInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
