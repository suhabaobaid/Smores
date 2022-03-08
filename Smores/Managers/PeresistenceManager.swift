//
//  PeresistenceManager.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import UIKit

enum CustomError: Error {
    case retrievingMessages
}

class PersistenceManager {
    static let shared: PersistenceManager = PersistenceManager()
    
    let path = URL(fileURLWithPath: NSTemporaryDirectory())
    
    let key = "timeline"
    
    func save(messages: [LocalMessage]) {
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        
        retrieveMessage { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(var oldMessages):
                    oldMessages.append(contentsOf: messages)
                    try? storage.save(oldMessages, for: self.key)
            }
        }
        
        
    }
    
    func retrieveMessage(completionHandler: @escaping (Result<[LocalMessage], CustomError>) -> Void) {
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        do {
            let messages:[LocalMessage] = try storage.fetch(for: key)
            completionHandler(.success(messages))
        } catch {
            completionHandler(.failure(.retrievingMessages))
        }
    }
}
