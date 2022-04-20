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
        if !tasks.isEmpty {
            return tasks.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
      
        
        if tasks.isEmpty {
        
          
            cell.mainImageView!.image = UIImage(named: "exPlant.png")
            cell.mainImageView.contentMode = .center
            
            cell.mainImageView.clipsToBounds = true
            cell.mainImageView.layer.cornerRadius = 5
            
            cell.nickNameLabel.text = "추가해주세요"
            cell.nickNameLabel.font = UIFont().subTitle
            cell.nickNameLabel.textColor = .lightGray
            cell.progressBar.progress = 0
           
            cell.dateLabel.isHidden = true
           
           
        } else {
           
            
            
            let row = tasks[indexPath.row]
           
            
            cell.mainImageView!.backgroundColor = UIColor(red: 238/255, green: 248/255, blue: 239/255, alpha: 1)
            cell.mainImageView!.image = loadImageFromDocuments(imageName: "\(row._id).jpg") == nil ? UIImage(named: "basicImg") : loadImageFromDocuments(imageName: "\(row._id).jpg")
            
            cell.mainImageView.contentMode = .scaleAspectFill
            
            cell.mainImageView.clipsToBounds = true
            cell.mainImageView.layer.cornerRadius = 5
            
            cell.nickNameLabel.text = row.nickName
            cell.nickNameLabel.font = UIFont().subTitle
            cell.nickNameLabel.textColor = .systemGray
            
            
            
            func progressDate() -> Float {
                let afterWaterDate = row.afterWaterDate
                let regDate = row.regDate
                let today = Date()
                
                let dateGap = Calendar.current.dateComponents([.second], from: today, to: afterWaterDate)
                
                let dateGap2 = Calendar.current.dateComponents([.second], from: regDate, to: afterWaterDate)

                
                if dateGap2.second! > 0 || dateGap.second! > 0 {
                    return (Float(dateGap.second! * 100 / dateGap2.second!) / 100)
                } else {
                    return  0
                }
                
            }
            
            cell.progressBar.progress = progressDate()
            cell.progressBar.progressTintColor = UIColor(red: 132/255, green: 222/255, blue: 226/255, alpha: 1)
            cell.progressBar.trackTintColor = UIColor(red: 240/255, green: 237/255, blue: 237/255, alpha: 1)
           
            let format = DateFormatter()
            format.locale = Locale(identifier: "ko_KR")
            format.dateFormat = "yyyy.MM.dd"
            
            let startDate = format.date(from:format.string(from: row.startDate))!
            let endDate = format.date(from:format.string(from: Date()))!
            let interval = endDate.timeIntervalSince(startDate)
            let days = Int(interval / 86400)
            cell.dateLabel.isHidden = false
            if days == 0  {
                cell.dateLabel.text = "🌱반가워요"
            } else {
                cell.dateLabel.text = "🪴 \(days)일 +"
            }
            
        
            cell.dateLabel.font = UIFont().pBold
            cell.dateLabel.textColor = .systemGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let row = tasks[indexPath.row]
        
        if  !tasks.isEmpty  {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else { return }
        
            
        self.navigationController?.pushViewController(vc, animated: true)
            
            let row = tasks[indexPath.row]
              
            vc.id = row._id
            
            
        } else {

            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ModalViewController.identifier) as! ModalViewController
            let nav = UINavigationController(rootViewController: vc)

            nav.modalPresentationStyle = .automatic

            present(nav, animated: true, completion: nil)

        }
        
    }
    

    
    
}
