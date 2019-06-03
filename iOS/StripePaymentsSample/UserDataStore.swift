//
//  UserDataStore.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import Foundation

class UserDataStore {
    private static let userDefaults = UserDefaults.standard
    
    enum UserKeys: String {
        case stripeCustomerId
    }
    
    static func setString(_ key: UserKeys, string: String){
        userDefaults.set(string, forKey: key.rawValue)
    }
    
    static func getString(_ key: UserKeys) -> String? {
        guard let string = userDefaults.string(forKey: key.rawValue) else {
            return nil
        }
        return string
    }
}

