//
//  String+Ext.swift
//  Smores
//
//  Created by Suha Baobaid on 3/7/22.
//

import UIKit

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
