//
//  ContentModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/21.
//

import UIKit
import MobileCoreServices
import RealmSwift

class ContentModalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    static let identifier = "ContentModalViewController"
    let localRealm = try! Realm()
    let imagePickerVC: UIImagePickerController! = UIImagePickerController()
    var picker = UIPickerView()
    var captureImage : UIImage!
    var imageSelect = false
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerVC.delegate = self
        
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
        
        //image
        imageView.contentMode = .scaleAspectFill
      
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
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
                imageView.image = editedImage
                captureImage = editedImage
                
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = originalImage
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
    }
    
    
    @objc func isClickedSaveBtn(){
        
        let realm = try! Realm()

                let feeds = feed(feedTitle:titleTextField.text!, feedContent:contentTextView.text!, regDate: Date())
        
        let predicate = NSPredicate(format: "_id == %@", plant()._id)

        if let parent = realm.objects(plant.self).filter(predicate).first {

            feeds.feedTitle = self.titleTextField.text!
            feeds.feedContent = self.contentTextView.text!
            feeds.regDate = Date()

                    do {
                        try realm.write {
                            parent.feeds.append(objectsIn: [feeds])
                            saveImageToDocumentDirectory(imageName: "\(feeds._id).jpg", image: imageView.image!)
                            realm.add(feeds)
                            print("saveToDo")
                            
                        }
                    } catch let e as NSError {
                        print("\(e.description)")
                    }
                }
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
        navigationController?.dismiss(animated: true, completion: nil)
    }


}

