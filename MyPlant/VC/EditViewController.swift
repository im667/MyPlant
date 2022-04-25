//
//  EditViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/24.
//

import UIKit
import RealmSwift



let DidDismissEditViewController:Notification.Name = Notification.Name("DidDismissEditViewController")

class EditViewController: UIViewController {
  
    

    static let identifier = "EditViewController"
    
    var task:plant!
    let localRealm = try!Realm()
    var days:[Int] = [1,2,3,4,5,6,7,10,14,21,30,60,90]
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    let unc = UNUserNotificationCenter.current()
    
    @IBOutlet weak var notiSwitch: UISwitch!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    @IBOutlet weak var editNickNameTextField: UITextField!
    
    
    @IBOutlet weak var editWaterDayButton: UIButton!
    
    @IBOutlet weak var editStartDayButton: UIButton!
    
    @IBOutlet weak var successButton: UIButton!
    
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        editNickNameTextField.sizeToFit()
        
        editNickNameTextField.delegate = self
        editNickNameTextField.text = task!.nickName
        editNickNameTextField.placeholder = "닉네임을 작성해주세요"
        editNickNameTextField.textColor = UIColor.darkGray
        editNickNameTextField.clipsToBounds = false
        editNickNameTextField.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 25)
        editNickNameTextField.layer.borderWidth = 1
        editNickNameTextField.layer.borderColor = UIColor.white.cgColor
        
        notiSwitch.isOn = task.notiIsOn
        
        editWaterDayButton.setTitle("\(task!.waterDay)", for: .normal)
        editWaterDayButton.backgroundColor = .systemGray5
        editWaterDayButton.clipsToBounds = true
        editWaterDayButton.layer.cornerRadius = 5
        editWaterDayButton.tintColor = .systemGray2
        
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        format.dateFormat = "yyyy년 MM월 dd일"
        
        editStartDayButton.setTitle(format.string(from: task!.startDate), for: .normal)
        editStartDayButton.backgroundColor = .systemGray5
        editStartDayButton.clipsToBounds = true
        editStartDayButton.layer.cornerRadius = 5
        editStartDayButton.tintColor = .systemGray2
        
        successButton.clipsToBounds = true
        successButton.layer.cornerRadius = 10
        
        dismissButton.clipsToBounds = true
        dismissButton.layer.cornerRadius = 10
        
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 10
        
    }
    

   
    @IBAction func notiSwith(_ sender: UISwitch) {
        
        if sender.isOn == true {
            
            try! localRealm.write{
                self.unc.addNotificationRequest(by: task)
            task.notiIsOn = true
            }
            
        } else {
            try! localRealm.write{
            task.notiIsOn = false
                self.unc.removePendingNotificationRequests(withIdentifiers: [String(describing:task._id)])
            }
        }
    }
    
    @IBAction func isClickedEditWaterDay(_ sender: UIButton) {
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.selectRow(days.firstIndex(of: task!.waterDay) ?? task!.waterDay, inComponent: 0, animated: true)
        self.editWaterDayButton.setTitle("\(task!.waterDay)", for: .normal)
        
        
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
        self.editWaterDayButton.setTitle("\(self.days[row])", for: .normal)
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        
         let afterWaterDay = Calendar.current.date(byAdding: .day, value: task!.waterDay, to: task!.regDate)
            
        
        try! localRealm.write{
            task?.afterWaterDate = afterWaterDay!
            task?.waterDay = Int(editWaterDayButton.currentTitle!) ?? 00
            task?.regDate = task!.regDate
        }
        
        
    }
    
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
        
    
    
    
    
    @IBAction func isClickedEditStartDay(_ sender: UIButton) {
        
        
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
            
            self.editStartDayButton.setTitle(value, for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func isClickedSuccessButton(_ sender: UIButton) {
        
        if editNickNameTextField.text == ""  {
         
            let alert = UIAlertController(title: "올바른 형식이 아닙니다.", message: "프로필 정보를 완성해주세요.", preferredStyle: UIAlertController.Style.alert)
            
            let ok = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let task = task
      
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        
         let afterWaterDay = Calendar.current.date(byAdding: .day, value: task!.waterDay, to: task!.regDate)
            
        guard let date =  editStartDayButton.currentTitle, let value = format.date(from: date) else {return}
            
            
        
        try! localRealm.write{
            task?.afterWaterDate = afterWaterDay!
            task?.nickName = editNickNameTextField.text ?? ""
            task?.waterDay = Int(editWaterDayButton.currentTitle!) ?? 00
            task?.regDate = task!.regDate
            task?.startDate = value
        }
        
       
        dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: DidDismissEditViewController, object: nil, userInfo: nil)
        
        }
   }
                
           
    
    func deleteImageToDocumentDirectory(imageName:String) {
        //이미지 저장 경로 설정: 도큐먼트 폴더(위치:.documentDirectory)
        //1. Desktop/user/mac~~~~~/folder/222.png
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2.이미지 파일 이름
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        
        if FileManager.default.fileExists(atPath: imageURL.path){
            
            //4-2.기존경로에 있는 이미지 삭제
            do{
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제완료")
            } catch {
                print("이미지를 삭제하지 못했습니다.")
            }
            
        }
        
    }
    
    
    @IBAction func isClickedDissmissButton(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func isClickedDeleteButton(_ sender: UIButton) {
      
        deleteImageToDocumentDirectory(imageName: "\(task!._id).jpg")
        self.unc.removePendingNotificationRequests(withIdentifiers: [String(describing:task._id)])
        let taskToDelete = task!
        try! localRealm.write {
          localRealm.delete(taskToDelete)
        }
       
        
//
//        let sb = UIStoryboard(name: "Content", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: AlertViewController.identifier) as! AlertViewController
//        let nav = UINavigationController(rootViewController: vc)

//        nav.modalPresentationStyle = .overCurrentContext
        dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: DidDismissEditViewController, object: nil, userInfo: nil)
//        present(nav, animated: false, completion: nil)
      
    }
    
    
 

 
    
    
}






