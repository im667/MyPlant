//
//  ContentModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/21.
//

import UIKit
import RealmSwift

class ContentModalViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
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

        addKeyboardObserver()
        
        scrollView.keyboardDismissMode = .onDrag
        
        titleTextField.delegate = self
        titleTextField.placeholder = "식물 이름을 입력해주세요."
        titleTextField.textColor = UIColor.darkGray
        titleTextField.clipsToBounds = false
        titleTextField.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 25)
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.white.cgColor
        
        
        contentTextView.delegate = self
        contentTextView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)
       
        contentTextView.isScrollEnabled = false
        textViewDidChange(contentTextView)
    }
    
        
        
    private func addKeyboardObserver() {
            // Register Keyboard notifications
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
        }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {

        guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return
            }
            
        scrollView.contentInset.bottom = keyboardFrame.size.height
            
            let firstResponder = UIResponder.currentFirstResponder
            
            if let textView = firstResponder as? UITextView {
                scrollView.scrollRectToVisible(textView.frame, animated: true)
            }

        }



     @objc func keyboardWillHide(_ sender: Notification) {

         let contentInset = UIEdgeInsets.zero
             scrollView.contentInset = contentInset
             scrollView.scrollIndicatorInsets = contentInset // Move view to original position

        }


    
    
    
    @objc func isClickedBackBtn (){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func isClickedSaveBtn() {
        navigationController?.dismiss(animated: true, completion: nil)
    }


}
