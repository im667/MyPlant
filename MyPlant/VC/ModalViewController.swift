//
//  ModalViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit
import MobileCoreServices

class ModalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    static let identifier = "ModalViewController"
    
    var days:[Int] = [1,2,3,4,5,6,7,10,14,21,30,60,90]
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    let imagePickerVC: UIImagePickerController! = UIImagePickerController()
    //선택된 이미지 데이터
    var captureImage: UIImage!
   
    
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
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 128/255, green: 166/255, blue: 34/255, alpha: 1)
        
        let saveBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(isClickedSaveBtn))
        
        self.navigationItem.leftBarButtonItem = backBarBtn
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        nickName.delegate = self
        nickName.placeholder = "식물 이름을 입력해주세요."
        nickName.textColor = UIColor.darkGray
        nickName.clipsToBounds = false
        nickName.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 25)
        nickName.layer.borderWidth = 1
        nickName.layer.borderColor = UIColor.white.cgColor
     
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    @objc func imageTapped(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "사진추가", message: "사진을 선택해주세요", preferredStyle: .actionSheet)
       
        let openCamera = UIAlertAction(title: "사진 촬영", style: .default){ action
            in
            self.imagePickerVC.sourceType = .camera
            self.present(self.imagePickerVC, animated: true, completion: nil)
           
        }
        let albumImage = UIAlertAction(title: "앨범에서 찾기", style: .default){ action
            in
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                self.imagePickerVC.delegate = self
                self.imagePickerVC.sourceType = .photoLibrary
                self.imagePickerVC.mediaTypes = [kUTTypeImage as String]
                //잘라내기 편집 기능 지원
                self.imagePickerVC.allowsEditing = true
                
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
                plantImageView.image = editedImage
                captureImage = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                plantImageView.image = originalImage
                captureImage = originalImage
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //취소버튼 클릭시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func keyboardWillShow(_ sender: Notification) {

            self.view.frame.origin.y = -150 // Move view 150 points upward

        }



     @objc func keyboardWillHide(_ sender: Notification) {

            self.view.frame.origin.y = 0 // Move view to original position

        }


    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
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
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem.init(title: "저장", style: .done, target: self, action: #selector(onDoneButtonTapped))
//            toolBar.items =
        
        toolBar.setItems([flexSpace, done], animated: true)
            self.view.addSubview(toolBar)
        
        
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    @IBAction func DateButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "키우기 시작한 날짜", message: "날짜를 선택해주세요!", preferredStyle: .alert)
        //얼럿 커스터마이징
        //1.얼럿안에 안에 들어와서 그른가,,,
        //2,,스토리보드 인식이 안되나 DatePickerViewController()
        //3.스토리보드 씬 + 클래스 -> 화면 전환 코드
        
//        let contentView = DatePickerViewController()
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController")as? DatePickerViewController else {
            print("DatePickerViewController error")
            return
        }
        contentView.view.backgroundColor = .white
//        contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) //녹색괴물이 나온다~
        contentView.preferredContentSize.height = 200
        alert.setValue(contentView, forKey: "contentViewController")
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "확인", style: .default){ _ in
            
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            //확인 버튼을 눌렀을 때 버튼의 타이틀 변경
            self.dateButton.setTitle(value, for: .normal)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
        
    }
    
    
  




