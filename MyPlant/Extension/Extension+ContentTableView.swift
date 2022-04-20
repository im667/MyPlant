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
     
        return feedTask.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()  }
        
  
        let row = feedTask[indexPath.row]
        
        
        
    
        cell.feedImageView.image = loadImageFromDocuments(imageName: "\(row._id).jpg") == nil ? UIImage(named: "basicImg") : loadImageFromDocuments(imageName: "\(row._id).jpg")
        
 
        
        if row.feedTitle == "" {
            cell.feedTitleLabel.text = "제목이 없습니다."
        } else {
            cell.feedTitleLabel.text = row.feedTitle
        }
        
        
        cell.feedImageView.contentMode = .scaleAspectFill
        cell.feedImageView.clipsToBounds = true
        cell.feedImageView.layer.cornerRadius = 10
        
        
        cell.feedContentLabel.text = row.feedContent
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
        
        let row = feedTask[indexPath.row]
        
        vc.id = row._id
        vc.SelectedFeed = true
      
//        let nav = UINavigationController(rootViewController: vc)
//
//        nav.modalPresentationStyle = .fullScreen
//
//        present(nav, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
   
        
        let deleteAction = UIContextualAction(style: .destructive, title: "", handler: { action, view, completionHandler in
                        completionHandler(true)
            
            let row = self.feedTask[indexPath.row]
            
                        // 메모 삭제시 alert
                        let alert = UIAlertController(title: "일기 삭제", message: "알기를 삭제합니다\n삭제하시겠습니까?", preferredStyle: .alert)
               
                        let ok = UIAlertAction(title: "삭제", style: .cancel) { _ in
                            let toDelete = self.task.first!.feeds[indexPath.row]
                            try! self.localRealm.write {
                                self.deleteImageFromDocumentDirectory(imageName: "\(row._id).jpg")
                                self.localRealm.delete(toDelete)
                           
                            }
                            self.feedTableView.reloadData()
                        }
                        let cancel = UIAlertAction(title: "취소", style: .default)
                
                        alert.addAction(ok)
                        alert.addAction(cancel)
                       
                        self.present(alert, animated: true, completion: nil)
                    })
        
        
            deleteAction.image = UIImage(systemName: "trash.fill")
                  return UISwipeActionsConfiguration(actions: [deleteAction])
                  
    }
    
    
}
