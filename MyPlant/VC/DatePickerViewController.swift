//
//  DatePickerViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/19.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.locale = Locale(identifier: "ko_kr")
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
    }
}
