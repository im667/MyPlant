//
//  ContentModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/21.
//

import UIKit
import MobileCoreServices
import RealmSwift
import AVFoundation
import Photos

let DidDismissContentModalViewController:Notification.Name = Notification.Name("DidDismissContentModalViewController")


class ContentModalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    static let identifier = "ContentModalViewController"
    let localRealm = try! Realm()

    var task: Results<plant>!
    var feedTask: Results<feed>!
    var id : ObjectId!
   
    var SelectedFeed = false
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
        
        let predicate = NSPredicate(format: "_id == %@", id!)

           feedTask = localRealm.objects(feed.self).filter(predicate).sorted(byKeyPath: "regDate", ascending: false)
        
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
        
        if SelectedFeed == false {
        
        titleTextField.delegate = self
        titleTextField.placeholder = "제목을 입력해주세요."
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
            
        } else {
            
            titleTextField.delegate = self
            titleTextField.placeholder = "제목을 입력해주세요."
            titleTextField.text = feedTask.first?.feedTitle
            titleTextField.textColor = UIColor.darkGray
            titleTextField.clipsToBounds = false
            titleTextField.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 25)
            titleTextField.layer.borderWidth = 1
            titleTextField.layer.borderColor = UIColor.white.cgColor
            
            contentTextView.text = feedTask.first?.feedContent
            contentTextView.delegate = self
            contentTextView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 16)
            contentTextView.textColor = UIColor.darkGray
            contentTextView.isScrollEnabled = false
            textViewDidChange(contentTextView)
            
            //image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.image = loadImageFromDocuments(imageName: "\(String(describing: id!)).jpg") == nil ? UIImage(named: "basicImg") : loadImageFromDocuments(imageName: "\(String(describing: id!)).jpg")
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
        }
        
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
        
        let alert = UIAlertController(title: "내 식물 사진추가", message: "사진을 선택해주세요", preferredStyle: .actionSheet)
       
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
                if SelectedFeed  {
                saveImageToDocumentDirectory(imageName: "\(id!).jpg", image: captureImage)
                }
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
    
    
    func saveImageToDocumentDirectory(imageName:String, image:UIImage)  {
        //1. 이미지 저장할 경로 설정 : Document 폴더
        
        if imageSelect {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath = documentDirectory.appendingPathComponent("feedImage")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        //Desktop/~~/~~/folder/222.png
        let imageURL = filePath.appendingPathComponent(imageName)
        
        //3. 이미지 압축(optional) image.pngData()
        guard let data = image.pngData() else { return }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인 (만약 최종 경로에 동일한 파일이 있는 경우)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            }
            catch {
                print("이미지 삭제하지 못했습니다.")
            }
        }
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        }
        catch {
            print("이미지 저장 실패")
        }
    }
    }
    
    
    
    
    func loadImageFromDocuments(imageName:String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
               
               let filePath = documentDirectory.appendingPathComponent("feedImage")
               if !FileManager.default.fileExists(atPath: filePath.path) {
                   do {
                       try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                   } catch {
                       print(error.localizedDescription)
                   }
               }
               
               let imageURL = filePath.appendingPathComponent(imageName)
               return UIImage(contentsOfFile: imageURL.path)
    }
    
    

    
    
    
    @objc func isClickedBackBtn (){
        
//        dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: DidDismissEditViewController, object: nil, userInfo: nil)
//        navigationController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
//
    }
    
    
    @objc func isClickedSaveBtn(){
        
        let realm = try! Realm()

        let feeds = MyPlant.feed(feedTitle:titleTextField.text!, feedContent:contentTextView.text!, regDate: Date())
        
        
        if SelectedFeed == false {
        
        let predicate = NSPredicate(format: "_id == %@", id!)
        
        if let parent = realm.objects(plant.self).filter(predicate).first {

            feeds.feedTitle = self.titleTextField.text!
            feeds.feedContent = self.contentTextView.text!
            feeds.regDate = Date()


                        try! realm.write {
                            parent.feeds.append(objectsIn: [feeds])
                            realm.add(feeds)
                 
                            saveImageToDocumentDirectory(imageName: "\(feeds._id).jpg", image: imageView.image!)
                       
                            print("saveToDo")
         
                            
                        }

                }
        } else {
    
            let predicate = NSPredicate(format: "_id == %@", id!)
            if let feedTask = realm.objects(feed.self).filter(predicate).first {
          
                try! localRealm.write{
                  
                    feedTask.feedTitle = self.titleTextField.text!
                    feedTask.feedContent = self.contentTextView.text!
                    feedTask.regDate = feedTask.regDate
               
                    
                }
                   
            
            }
        }
        NotificationCenter.default.post(name: DidDismissContentModalViewController, object: nil, userInfo: nil)
        print("Realm is located at:", localRealm.configuration.fileURL!)
        
        
//
//        dismiss(animated: false, completion: nil)
          
        navigationController?.popViewController(animated: true)

    }
}
