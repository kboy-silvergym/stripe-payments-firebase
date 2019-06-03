//
//  StripeProvider.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import Stripe
import Firebase
import FirebaseFunctions

class StripeProvider: NSObject, STPCustomerEphemeralKeyProvider {
    lazy var functions = Functions.functions()
    let customerId: String
    
    init(customerId: String){
        self.customerId = customerId
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let data: [String: Any] = [
            "customerId": customerId,
            "stripe_version": apiVersion
        ]
        functions
            .httpsCallable("createStripeEphemeralKeys")
            .call(data) { result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                } else if let data = result?.data as? [String: Any] {
                    completion(data, nil)
                }
        }
    }
}

