//
//  StripeUseCase.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import Hydra

class StripeUseCase {
    private let stripeRepo = StripeRepository()
    
    private func createStripeCustomerId(email: String) -> Promise<String> {
        return stripeRepo.createCustomerId(email: email)
    }
    
    func charge(sourceId: String, amount: Int) -> Promise<Void> {
        guard let customerId = UserDataStore.getString(.stripeCustomerId) else {
            return Promise<Void>.init(rejected: ClientError.cast)
        }
        return stripeRepo.createCharge(customerId: customerId, sourceId: sourceId, amount: amount)
    }
}
