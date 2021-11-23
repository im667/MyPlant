//
//  MainViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit
import RealmSwift




class MainViewController: UIViewController {
    
    
    var tasks: Results<plant>!
    let localRealm = try! Realm()
 
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = localRealm.objects(plant.self).sorted(byKeyPath: "regDate", ascending: false)
        collectionView.reloadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        self.titleLabel.text = tasks.count == 0 ? "식물을 추가해주세요." : "내 식물 \(tasks.count)"
        self.titleLabel.font = tasks.count == 0 ? UIFont().subTitle : UIFont().title
        self.titleLabel.textColor = UIColor(red: 128/255, green: 166/255, blue: 34/255, alpha: 1)
        let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray, range:(titleLabel.text! as NSString).range(of: "내 식물"))
        
        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray3, range:(titleLabel.text! as NSString).range(of: "식물을 추가해주세요."))
        
        titleLabel.attributedText = attributedStr
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissModalNotification(_:)), name: DidDismissModalViewController, object: nil)
        
       
        
        //flow 레이아웃
        let layout = UICollectionViewFlowLayout()
        let spacing :CGFloat = 20 //Int연산 불가 type적용해야함.
        let width = UIScreen.main.bounds.width - (spacing * 1.5)
        
        //셀의 너비와 높이(CGsize(구조체))
        layout.itemSize = CGSize(width: width / 2.7, height: (width/1.8))
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        
        let nibName = UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
        
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffset(horizontal: 10,vertical: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = localRealm.objects(plant.self).sorted(byKeyPath: "regDate", ascending: false)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print(#function)
        collectionView.reloadData()
        
        let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray, range:(titleLabel.text! as NSString).range(of: "내 식물"))
        titleLabel.text = tasks.count == 0 ? "식물을 추가해주세요." : "내 식물 \(tasks.count)"
        titleLabel.attributedText = attributedStr
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    @objc func didDismissModalNotification(_ noti: Notification) {
 

            OperationQueue.main.addOperation { // DispatchQueue도 가능.
                self.collectionView.reloadData()
            }

        }
    
    func loadImageFromDocuments(imageName:String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return nil
    }

    func deleteImageFromDocuments( imageName:String ){
        //1. Desktop/user/mac~~~~~/folder/222.png
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2.이미지 파일 이름
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3.이미지 압축 (image.pngDage())
//        guard let data = image.pngData() else { return }
                
        
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
    }


 
    @IBAction func plusButton(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ModalViewController.identifier) as! ModalViewController
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true, completion: nil)
        
    }
    
}
