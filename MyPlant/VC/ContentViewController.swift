//
//  ContentViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    

    @objc func isClickedBackBtn() {
        navigationController?.popViewController(animated: true)
    }

}
