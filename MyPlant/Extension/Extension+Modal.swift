//
//  Extension+Modal.swift
//  MyPlant
//
//  Created by mac on 2021/11/19.
//

import Foundation
import UIKit

extension ModalViewController:UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate, UITextFieldDelegate {
   
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   

  
    
}

