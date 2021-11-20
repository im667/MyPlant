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
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        cell.nickNameLabel.font = UIFont().subTitle
        cell.nickNameLabel.textColor = .darkGray
        
        cell.dateLabel.font = UIFont().pBold
        cell.dateLabel.textColor = .darkGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Content", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else { return }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
