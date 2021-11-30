//
//  OpenSourceViewController.swift
//  MyPlant
//
//  Created by mac on 2021/12/01.
//

import UIKit

class OpenSourceViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backBtn.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(isClickedBackBtn), for: .touchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.leftBarButtonItem = backBarBtn
    }
    

    @objc func isClickedBackBtn() {
    
        navigationController?.popViewController(animated: true)
    }

}
