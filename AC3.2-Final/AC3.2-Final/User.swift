//
//  User.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class User {
    internal var email: String?
    internal var password: String?
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
}
