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
        1
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
    
    
    
    
}
