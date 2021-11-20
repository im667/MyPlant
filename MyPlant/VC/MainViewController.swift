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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.titleLabel.text = "내 식물"
        self.titleLabel.font = UIFont().title
        
        
//        let backBtn = UIButton(type: .custom)
//        backBtn.setImage(UIImage(named: "backBtn.png"), for: .normal)
//        backBtn.addTarget(self, action: #selector(isClickedBackBtn), for: .touchUpInside)
//        let backBarBtn = UIBarButtonItem(customView: backBtn)
//
//        self.navigationItem.leftBarButtonItem = backBarBtn
       
        
        //flow 레이아웃
        let layout = UICollectionViewFlowLayout()
        let spacing :CGFloat = 16 //Int연산 불가 type적용해야함.
        let width = UIScreen.main.bounds.width - (spacing * 1.5)
        
        //셀의 너비와 높이(CGsize(구조체))
        layout.itemSize = CGSize(width: width / 2.7, height: (width/2))
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.scrollDirection = .vertical
        
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        
        let nibName = UINib(nibName: MainCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
        
        UISearchBar.appearance().searchTextPositionAdjustment=UIOffset(horizontal: 10,vertical: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    
//    @objc func isClickedBackBtn() {
//        navigationController?.popViewController(animated: true)
//    }


 
    @IBAction func plusButton(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ModalViewController.identifier) as! ModalViewController
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true, completion: nil)
    }
    
}
