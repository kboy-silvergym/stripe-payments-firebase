//
//  StripeRepository.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import Hydra
import FirebaseFunctions

enum ClientError: LocalizedError {
    case noData
    case cast
}

class StripeRepository {
    lazy var functions = Functions.functions()
    
    func createCustomerId(email: String) -> Promise<String> {
        return Promise<String> (in: .background, { resolve, reject, _ in
            let data: [String: Any] = [
                "email": email
            ]
            self.functions.httpsCallable("createStripeCustomer")
                .call(data) { result, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        reject(error)
                    } else if let data = result?.data as? [String: Any],
                        let customerId = data["customerId"] as? String {
                        resolve(customerId)
                    } else {
                        reject(ClientError.noData)
                    }
            }
        })
    }
    
    func createCharge(customerId: String, sourceId: String, amount: Int) -> Promise<Void> {
        return Promise<Void> (in: .background, { resolve, reject, _ in
            let data: [String: Any] = [
                "customerId": customerId,
                "sourceId": sourceId,
                "amount": amount,
                "idempotencyKey": UUID().uuidString
            ]
            self.functions.httpsCallable("createStripeCharge")
                .call(data) { result, error in
                    
                    if let error = error {
                        reject(error)
                    } else {
                        resolve(())
                    }
            }
        })
    }
}
