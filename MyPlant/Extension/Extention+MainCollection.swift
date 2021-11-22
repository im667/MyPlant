//
//  File.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import Foundation
import UIKit


extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count < 1 ? 1 : tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        let row = tasks[indexPath.row]
        
        if tasks.count < 1 {
        
            cell.mainImageView!.backgroundColor = UIColor(red: 238/255, green: 248/255, blue: 239/255, alpha: 1)
            cell.mainImageView!.image = UIImage(named: "exPlant.png")
            cell.mainImageView.contentMode = .center
            
            cell.mainImageView.clipsToBounds = true
            cell.mainImageView.layer.cornerRadius = 5
            
            cell.nickNameLabel.text = "추가해주세요"
            cell.nickNameLabel.font = UIFont().subTitle
            cell.nickNameLabel.textColor = .lightGray
            cell.progressBar.progress = 0
            cell.progressBar.trackTintColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
           
        } else {
           
            cell.mainImageView!.backgroundColor = UIColor(red: 238/255, green: 248/255, blue: 239/255, alpha: 1)
//            cell.mainImageView!.image = row.profileImg
            cell.mainImageView.contentMode = .center
            
            cell.mainImageView.clipsToBounds = true
            cell.mainImageView.layer.cornerRadius = 5
            
            cell.nickNameLabel.text = row.nickName
            cell.nickNameLabel.font = UIFont().subTitle
            cell.nickNameLabel.textColor = .systemGray
            cell.progressBar.progress = 1
            cell.progressBar.progressTintColor = UIColor(red: 132/255, green: 222/255, blue: 226/255, alpha: 1)
            cell.progressBar.trackTintColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
           
            cell.dateLabel.text = "\(row.startDate)"
            cell.dateLabel.font = UIFont().pBold
            cell.dateLabel.textColor = .systemGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let row = tasks[indexPath.row]
        
//        if   {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else { return }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
            
//        } else {
//
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: ModalViewController.identifier) as! ModalViewController
//            let nav = UINavigationController(rootViewController: vc)
//
//            nav.modalPresentationStyle = .automatic
//
//            present(nav, animated: true, completion: nil)
//
//        }
        
    }
    
    
}
