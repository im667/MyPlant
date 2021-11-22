//
//  Extension+contentModal.swift
//  MyPlant
//
//  Created by mac on 2021/11/21.
//

import Foundation
import UIKit

extension ContentModalViewController:UITextFieldDelegate,UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == "내용을 입력해주세요." {
            contentTextView.text = nil
            contentTextView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.text = "내용을 입력해주세요."
            contentTextView.textColor = .lightGray
        }
    }
    

   
    
    func textViewDidChange(_ textView: UITextView) {
        print("\(contentTextView?.text ?? "nil")")
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimatedSize = contentTextView.sizeThatFits(size)
        contentTextView.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
        }
    }
    
}
