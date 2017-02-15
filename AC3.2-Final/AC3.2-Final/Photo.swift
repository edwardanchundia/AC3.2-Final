//
//  Photo.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Photo {
    internal let key: String
    internal let userId: String
    internal let comment: String
    
    init(key: String, userId: String, comment: String) {
        self.key = key
        self.userId = userId
        self.comment = comment
    }
    
    var asDictionary: [String: String] {
        return ["userId": userId, "comment": comment]
    }
    
}
