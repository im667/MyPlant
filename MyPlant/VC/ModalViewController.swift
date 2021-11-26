//
//  ModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit
import MobileCoreServices
import RealmSwift
import SwiftUI

let DidDismissModalViewController: Notification.Name = Notification.Name("DidDismissModalViewController")


class ModalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    static let identifier = "ModalViewController"
    let localRealm = try! Realm()
    
    var days:[Int] = [1,2,3,4,5,6,7,10,14,21,30,60,90]
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    let imagePickerVC: UIImagePickerController! = UIImagePickerController()
    //선택된 이미지 데이터
    var captureImage: UIImage!
    var imageSelect = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var modalTitleLabel: UILabel!
    
    @IBOutlet weak var plantImageView: UIImageView!
    

    @IBOutlet weak var nickName: UITextField!
    
    
    @IBOutlet weak var infoSelectDayLabel: UILabel!
    
    @IBOutlet weak var daysButton: UIButton!
    
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backBtn.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(isClickedBackBtn), for: .touchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        imagePickerVC.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 128/255, green: 166/255, blue: 34/255, alpha: 1)
        
        let saveBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(isClickedSaveBtn))
        
        self.navigationItem.leftBarButtonItem = backBarBtn
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        addKeyboardObserver()
        scrollView.keyboardDismissMode = .onDrag
    
        
        nickName.delegate = self
        nickName.placeholder = "식물 이름을 입력해주세요."
        nickName.textColor = UIColor.darkGray
        nickName.clipsToBounds = false
        nickName.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 25)
        nickName.layer.borderWidth = 1
        nickName.layer.borderColor = UIColor.white.cgColor
     

        
        plantImageView.contentMode = .scaleAspectFill
        

        daysButton.setTitle("선택", for: .normal)
        daysButton.backgroundColor = .systemGray5
        daysButton.clipsToBounds = true
        daysButton.layer.cornerRadius = 5
        daysButton.tintColor = .systemGray2
        
        
        dateButton.setTitle("날짜 선택", for: .normal)
        dateButton.backgroundColor = .systemGray5
        dateButton.clipsToBounds = true
        dateButton.layer.cornerRadius = 5
        dateButton.tintColor = .systemGray2
        
        
        
        //image
      
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        plantImageView.isUserInteractionEnabled = true
        plantImageView.addGestureRecognizer(tapGestureRecognizer)

      
      
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


    
    
    @objc func imageTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "사진추가", message: "사진을 선택해주세요", preferredStyle: .actionSheet)
       
        let openCamera = UIAlertAction(title: "사진 촬영", style: .default){ action
            in
            self.imagePickerVC.allowsEditing = true
            self.imagePickerVC.sourceType = .camera
            self.present(self.imagePickerVC, animated: true, completion: nil)
            
           
        }
        let albumImage = UIAlertAction(title: "앨범에서 찾기", style: .default){ action
            in
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.imagePickerVC.allowsEditing = true
                self.imagePickerVC.delegate = self
                self.imagePickerVC.sourceType = .photoLibrary
                self.present(self.imagePickerVC, animated: true, completion: nil)
                self.imagePickerVC.mediaTypes = [kUTTypeImage as String]
           
            } else {
                print("포토앨범에 접근할 수 없습니다")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        alert.addAction(openCamera)
        alert.addAction(albumImage)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        imageSelect = true
        
        if mediaType.isEqual(kUTTypeImage as NSString as String){
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as?
                UIImage {
                plantImageView.image = editedImage
                captureImage = editedImage
                
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                plantImageView.image = originalImage
                captureImage = originalImage
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func saveImageToDocumentDirectory(imageName:String, image:UIImage) {
        //이미지 저장 경로 설정: 도큐먼트 폴더(위치:.documentDirectory)
        //1. Desktop/user/mac~~~~~/folder/222.png
        
        if imageSelect {
            
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2.이미지 파일 이름
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3.이미지 압축 (image.pngDage())
        guard let data = image.pngData() else { return }
                
        
        
        //4.이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인
        
        if FileManager.default.fileExists(atPath: imageURL.path){
            
            //4-2.기존경로에 있는 이미지 삭제
            do{
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제완료")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
            
        }
        
        //5. 이미지를 도큐먼트에 저장
        do{
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 못함")
        }
        }
    }

    
    
  
    
    
  
    
    @objc func isClickedBackBtn (){
        navigationController?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: DidDismissModalViewController, object: nil, userInfo: nil)
    }
    
    
    @objc func isClickedSaveBtn() {
        
        
        if let waterDayString = daysButton.currentTitle {
            
            if let waterDay = Int(waterDayString) {
                
                print(waterDay)
                let format = DateFormatter()
                format.dateFormat = "yyyy년 MM월 dd일"
                
                guard let date =  dateButton.currentTitle, let value = format.date(from: date) else {return}
                
               
                let task = plant(nickName: nickName.text!, waterDay: waterDay, startDate: value, regDate: Date())
                
                try! localRealm.write {
                    localRealm.add(task)
                    saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: plantImageView.image!)
                    
                }
             
            }
        }

          print("Realm is located at:", localRealm.configuration.fileURL!)
        NotificationCenter.default.post(name: DidDismissModalViewController, object: nil, userInfo: nil)
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
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        
        let done = UIBarButtonItem.init(title: "저장", style: .done, target: self, action: #selector(onDoneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem.init(title: "취소", style: .done, target: self, action: #selector(onCancelButtonTapped))
        
        toolBar.setItems([cancel,flexSpace,done], animated: true)
            self.view.addSubview(toolBar)
        
        
    }
    
    @objc func onDoneButtonTapped() {
        let row = self.picker.selectedRow(inComponent: 0)
        self.daysButton.setTitle("\(self.days[row])", for: .normal)
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    @IBAction func DateButton(_ sender: UIButton) {
        
        
        
        let alert = UIAlertController(title: "키우기 시작한 날짜", message: "날짜를 선택해주세요!", preferredStyle: .alert)
   
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController")as? DatePickerViewController else {
            print("DatePickerViewController error")
            return
        }
        contentView.view.backgroundColor = .white
        contentView.preferredContentSize.height = 200
        alert.setValue(contentView, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "확인", style: .default){ _ in
            
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            self.dateButton.setTitle(value, for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
        
    }
    
    
  




