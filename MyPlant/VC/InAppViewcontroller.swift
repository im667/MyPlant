//
//  InAppViewcontroller.swift
//  MyPlant
//
//  Created by mac on 2022/01/07.
//

//import Foundation
//import UIKit
//import StoreKit
//
//class InAppViewController: UIViewController, SKProductsRequestDelegate {
//
//
//
//    //1.인앱 상품 ID 정의
//    var productIdentifier: Set<String> = ["com.ssac.MyPlant.plant"]
//
//    var product: SKProduct?
//    var productArray = Array<SKProduct>()
//
//    let button = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        requestProductData()
//
//        view.addSubview(button)
//        button.backgroundColor = .white
//        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//    }
//
//
//
//    //2. productIdentifier에 정의된 상품id에 대한 정보 가져오기 및 사용자의 디바이스가 인앱결제가 가능한지 여부 확인
//
//    @objc func buttonClicked(){
//        let payment = SKPayment(product: product!)
//        SKPaymentQueue.default().add(payment)
//        SKPaymentQueue.default().add(self)
//
//    }
//
//    func requestProductData() {
//
//        //구매가 가능한지 아닌지 상태확인하는 메소드
//        if SKPaymentQueue.canMakePayments() {
//            print("인앱결제가능")
//        let request = SKProductsRequest(productIdentifiers: productIdentifier)
//
//            request.delegate = self
//            request.start()
//        } else {
//            print("결제 안돼용")
//        }
//    }
//
//    //인앱 상품조회
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//
//        let products = response.products
//
//        if products.count > 0 {
//            for i in products {
//                productArray.append(i)
//                product = i
//
//                print(i.localizedTitle, i.price, i.localizedDescription)
//            }
//
//        } else {
//            print("No product Found")
//
//        }
//
//    }
//
//    func receiptValidation(transaction: SKPaymentTransaction, productIdentifier: String){
//
//        // SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
//        // iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
//
//
//        //구매영수증 정보
//        let receiptFileURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptFileURL!)
//        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//
//        print(receiptString)
//
//        SKPaymentQueue.default().finishTransaction(transaction)
//
//        button.backgroundColor =.red
//    }
//
//}
//
//extension InAppViewController:SKPaymentTransactionObserver {
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//
//            switch transaction.transactionState {
//
//
//            case .purchased:
//                print("transaction Approved. \(transaction.payment.productIdentifier)")
//
//            case .failed:
//                print("failed")
//                SKPaymentQueue.default().finishTransaction(transaction)
//
//
//            @unknown default:
//                break
//            }
//        }
//    }
//
//
//
//}
