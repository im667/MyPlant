//
//  ContentViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit
import RealmSwift
import MobileCoreServices
import SwiftUI
import UserNotifications

class ContentViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    var task: Results<plant>!
    var feedTask: Results<feed>!
    
    let localRealm = try! Realm()
    var id : ObjectId?
    let imagePickerVC: UIImagePickerController! = UIImagePickerController()
    let unc = UNUserNotificationCenter.current()
    
    //선택된 이미지 데이터
    var captureImage: UIImage!
    var alram = false
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var waterResetButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var daysLable: UILabel!
    
    @IBOutlet weak var daysStartDateLabel: UILabel!
    
    @IBOutlet weak var waterDayLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var editButton: UIButton!
    

    @IBOutlet weak var ChangeIconImageView: UIImageView!
    
    @IBOutlet weak var alramSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let predicate = NSPredicate(format: "_id == %@", id!)

        task = localRealm.objects(plant.self).filter(predicate)
        feedTask = localRealm.objects(feed.self).sorted(byKeyPath: "regDate", ascending: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissEditNotification(_:)), name: DidDismissEditViewController, object: nil)
        
        print(task!)
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backBtn.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(isClickedBackBtn), for: .touchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.leftBarButtonItem = backBarBtn
      
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.estimatedRowHeight = 168
        feedTableView.rowHeight = UITableView.automaticDimension
        DispatchQueue.main.async {
                    self.tableViewHeight.constant = self.feedTableView.contentSize.height
                }

        
        profileImage.image =  loadImageFromDocumentDirectory(imageName: "\(task.first!._id).jpg") == nil ? UIImage(named: "basicImg") : loadImageFromDocumentDirectory(imageName: "\(task.first!._id).jpg")
        profileImage.contentMode = .scaleAspectFill
        
        
        
        nickName.text = task.first!.nickName
      
        
     
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyy.MM.dd"
        let startDate = format.date(from:format.string(from: task.first!.startDate))!
        let endDate = format.date(from:format.string(from: Date()))!
        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        daysLable.text = "🪴\(days)일+"
        daysLable.sizeToFit()
        daysStartDateLabel.text = format.string(from: task.first!.startDate) + " ~"
        
        waterDayLabel.text = String(task.first!.waterDay) + "일"
        
        progressBar.progress = progressDate()
           
        
    
        
        
        progressBar.progressTintColor = UIColor(red: 132/255, green: 222/255, blue: 226/255, alpha: 1)
        
        if progressDate() > 0 {
            waterResetButton.layer.isHidden = true
        progressBar.trackTintColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
        } else {
                progressBar.trackTintColor = UIColor(red: 226/255, green: 132/255, blue: 132/255, alpha: 1)
            waterResetButton.layer.isHidden = false
        }
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressBar.progress = progressDate()
           
        progressBar.progressTintColor = UIColor(red: 132/255, green: 222/255, blue: 226/255, alpha: 1)
        
        if progressDate() > 0 {
            waterResetButton.layer.isHidden = true
        progressBar.trackTintColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
        } else {
                progressBar.trackTintColor = UIColor(red: 226/255, green: 132/255, blue: 132/255, alpha: 1)
            waterResetButton.layer.isHidden = false
        }
        
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

        
        if mediaType.isEqual(kUTTypeImage as NSString as String){
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as?
                UIImage {
                profileImage.image = editedImage
                captureImage = editedImage
                saveImageToDocumentDirectory(imageName: "\(id!).jpg", image: captureImage)
                
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                profileImage.image = originalImage
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

    
    
    
    @objc func didDismissEditNotification(_ noti: Notification) {
 

        let predicate = NSPredicate(format: "_id == %@", id!)

        task = localRealm.objects(plant.self).filter(predicate)
        nickName.text = task.first!.nickName
        
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyy.MM.dd"
        let startDate = format.date(from:format.string(from: task.first!.startDate))!
        let endDate = format.date(from:format.string(from: Date()))!
        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        daysLable.text = "🪴\(days)일+"
        daysLable.sizeToFit()
        daysStartDateLabel.text = format.string(from: task.first!.startDate) + " ~"
        
        waterDayLabel.text = String(task.first!.waterDay)
        
        }

    @objc func isClickedBackBtn() {
        print(progressDate())
        navigationController?.popViewController(animated: true)
    }

    
    
    @IBAction func isClickedAddFeedBtn(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "ContentModalViewController") as? ContentModalViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true, completion: nil)
    }
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
          
          let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
          let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
          let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
          
          if let directoryPath = path.first {
              
              let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
              return UIImage(contentsOfFile: imageURL.path)
          }
          
          return nil
      }
    
    @IBAction func isClickedEditButton(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
        guard let vc = sb.instantiateViewController(identifier: EditViewController.identifier) as? EditViewController else {return}
        
        vc.task = task.first
        
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
        
    }
    @IBAction func alramSwitch(_ sender: UISwitch) {
       
//        alramSwitch.isOn = true // Set the event to be called when switching On / Off of Switch.
//        alramSwitch.addTarget(self, action: #selector(requestNotificationAuthorization()), for: UIControl.Event.valueChanged)

        
    }
    
    func progressDate() -> Float {
        let afterWaterDate = task?.first!.afterWaterDate
        let regDate = task?.first!.regDate
        let today = Date()
        
        let dateGap = Calendar.current.dateComponents([.second], from: today, to: afterWaterDate!)
        
        let dateGap2 = Calendar.current.dateComponents([.second], from: regDate!, to: afterWaterDate!)

        
        if dateGap2.second! > 0 || dateGap.second! > 0 {
            return (Float(dateGap.second! * 100 / dateGap2.second!) / 100)
        } else {
            return  0
        }
        
    }
    
    
    
    
    @objc func requestNotificationAuthorization() {
        let options = UNAuthorizationOptions(arrayLiteral: [.badge, .sound, .alert])
        unc.requestAuthorization(options: options){ [weak self] success, error in
            if success {
                self?.sendLocalNotification(seconds: 5)
            } else {
                print("error")
            }
        }
    }
    
    private func sendLocalNotification(seconds:Double){
        let content = UNMutableNotificationContent()
        content.title = "MyPlant"
        content.body = "알림이와요"
        content.userInfo = ["targetScene": "splash"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: String(describing: task!.first?._id), content: content, trigger: trigger)
        
        unc.add(request){ error in
            print("error")
        }
        
    }
    
    @IBAction func isClickedWaterResetButton(_ sender: UIButton) {
        
      
        guard let afterWaterDay = Calendar.current.date(byAdding: .day, value: task!.first!.waterDay, to: task!.first!.regDate) else { return }
      
        try! localRealm.write{
            task.first?.regDate = Date()
            task.first?.afterWaterDate = afterWaterDay
        }
        
        
    }
}
