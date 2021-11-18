//
//  Extension+Modal.swift
//  MyPlant
//
//  Created by mac on 2021/11/19.
//

import Foundation
import UIKit

extension ModalViewController:UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let days = days[row]
        return "\(days)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.daysButton.setTitle("\(days[row])  ", for: .normal)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if nickName.textColor == UIColor.lightGray {
            nickName.becomeFirstResponder()
            nickName.text = nil
            nickName.textColor = UIColor.systemGray2
        }
      }

      func textViewDidEndEditing(_ textView: UITextView) {
        if nickName.text.isEmpty {
            nickName.text = "식물 이름을 입력해주세요."
            nickName.textColor = UIColor.systemGray5
        }
      }
    
}

