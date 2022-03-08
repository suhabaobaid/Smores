//
//  ChatViewController.swift
//  CustomKeyboardInputView
//
//  Created by Suha Baobaid on 3/6/22.
//

import UIKit
import MessageKit

struct Sender: SenderType, Codable {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    let currentUser = Sender(senderId: "1", displayName: "Suha")
    var messages: [MessageType] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
        fetchAllMessages()
    }
    
    func fetchAllMessages() {
        PersistenceManager.shared.retrieveMessage { [weak self] result in
            switch result {
                case .failure(let error):
                    self?.presentMinimumAlertonMainThread(message: "Unable to fetch messages", isError: true, dismissTime: 3)
                case .success(let messages):
                    var newMessages: [Message] = []
                    for message in messages {
                        if message.contentType == .text {
                            newMessages.append(Message(sender: Sender(senderId: message.senderId, displayName: "Suha"), messageId: message.messageId, sentDate: message.sentDate, kind: .text(message.content)))
                        } else {
                            if let image = message.content.toImage() {
                                newMessages.append(Message(sender: Sender(senderId: message.senderId, displayName: "Suha"), messageId: message.messageId, sentDate: message.sentDate, kind: .photo(
                                    Media(url: nil,
                                          image: image,
                                          placeholderImage: UIImage(named: "placeholder")!,
                                          size: CGSize(width: 200, height: 200)))))
                            }
                        }
                    }
                    self?.messages = newMessages
                    self?.messagesCollectionView.reloadData()
            }
        }
    }

}

// MARK: - Message Delegates
extension ChatViewController {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}
