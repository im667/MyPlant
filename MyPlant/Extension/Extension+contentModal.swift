//
//  Extension+contentModal.swift
//  MyPlant
//
//  Created by mac on 2021/11/21.
//

import Foundation


extension ContentModalViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
