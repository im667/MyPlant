//
//  Extension+ContentTableView.swift
//  MyPlant
//
//  Created by mac on 2021/11/20.
//

import Foundation
import UIKit

extension ContentViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((task.first?.feeds.isEmpty) != nil)  {
            return (task.first?.feeds.count)!
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()  }
        
        cell.feedTitleLabel.text = ""
        cell.feedContentLabel.text = "isContent"
        cell.colorView.clipsToBounds = true
        cell.colorView.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "ContentModalViewController") as? ContentModalViewController else { return }
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true, completion: nil)
    }
}
