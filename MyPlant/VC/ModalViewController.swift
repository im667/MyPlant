//
//  ModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit

class ModalViewController: UIViewController {
    
    static let identifier = "ModalViewController"
    
    var days:[Int] = [1,2,3,4,5,6,7,10,14,21,30,60,90]
    var picker = UIPickerView()
    var toolBar = UIToolbar()

    @IBOutlet weak var modalTitleLabel: UILabel!
    
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var nickName: UITextView!
    
    
    @IBOutlet weak var infoSelectDayLabel: UILabel!
    
    @IBOutlet weak var daysButton: UIButton!
    
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backBtn.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(isClickedBackBtn), for: .touchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 128/255, green: 166/255, blue: 34/255, alpha: 1)
        
        let saveBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(isClickedSaveBtn))
        
        self.navigationItem.leftBarButtonItem = backBarBtn
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        
        nickName.isScrollEnabled = false
        nickName.delegate = self
        nickName.text =  "식물 이름을 입력해주세요."
        nickName.textColor = UIColor.darkGray
        nickName.becomeFirstResponder()
        nickName.selectedTextRange = nickName.textRange(from: nickName.beginningOfDocument, to: nickName.endOfDocument)
        
        //design
       
        
        daysButton.backgroundColor = .systemGray5
        daysButton.clipsToBounds = true
        daysButton.layer.cornerRadius = 5
        daysButton.tintColor = .systemGray2
        
        dateButton.backgroundColor = .systemGray5
        dateButton.clipsToBounds = true
        dateButton.layer.cornerRadius = 5
        dateButton.tintColor = .systemGray2
        
      
    }
    
    
    
    @objc func isClickedBackBtn (){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func isClickedSaveBtn() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func daysButton(_ sender: UIButton) {
    
        
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
            toolBar.items = [UIBarButtonItem.init(title: "저장", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    
    
    @IBAction func DateButton(_ sender: UIButton) {
    }
    
}


