//
//  ViewController.swift
//  StripePaymentsSample
//
//  Created by 藤川慶 on 2019/06/03.
//  Copyright © 2019 kboy. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var payButton: UIButton!
    
    private var paymentContext: STPPaymentContext?
    
    private let useCase = StripeUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ポイント"
    }
    
    @IBAction func stripeButtonTapped(_ sender: Any) {
        // you should create customer id when you create user data, and store that data to local(ex. UserDefauls)
        guard let customerId = UserDataStore.getString(.stripeCustomerId) else {
            return
        }
        let customerContext = STPCustomerContext(keyProvider: StripeProvider(customerId: customerId))
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
        paymentContext!.paymentAmount = 5000
        paymentContext!.presentPaymentOptionsViewController()
    }
    
    @IBAction func payButtonTapped(_ sender: Any) {
        paymentContext?.requestPayment()
    }
}

extension ViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("paymentContextDidChange")
        cardNameLabel.text = paymentContext.selectedPaymentOption?.label
        cardImageView.image = paymentContext.selectedPaymentOption?.image
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("didFailToLoadWithError")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("didCreatePaymentResult")
        
        let sourceId = paymentResult.source.stripeID
        let paymentAmount = paymentContext.paymentAmount
        useCase
            .charge(sourceId: sourceId, amount: paymentAmount)
            .then {
                completion(nil)
            }.catch { error in
                completion(error)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("didFinishWith")
        
        switch status {
        case .error:
            self.showErrorDialog(error!)
        case .success:
            self.showOKDialog(title: "決済に成功しました")
        case .userCancellation:
            break
        @unknown default:
            break
        }
        print(status)
    }
}

extension ViewController {
    func showOKDialog(title: String, message: String? = nil, ok: String = "OK", completion: (() -> Void)? = nil){
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: ok, style: .default, handler: { _ in
                completion?()
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorDialog(_ error: Error, completion: (() -> Void)? = nil){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: error.localizedDescription,
                                          message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

