//
//  RealmModel.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import Foundation
import RealmSwift


//Table 이름
//@Persisted 컬럼
class plant: Object {
    @Persisted var nickName: String = "" // 제목: 필수
    @Persisted var profileImg: String? = "" // 사진: 옵션 없으면 기본이미지 제공
    @Persisted var waterDay: Int // 물주기 : 필수
    @Persisted var startDate = Date() //키우기시작한 날짜: 필수
    @Persisted var regDate = Date() //등록 날짜 : 필수(필터용)
    
   //PK(필수) ObjectID 사용
    @Persisted(primaryKey: true) var _id: ObjectId
   
    convenience init(profileImg:String?, nickName:String, waterDay:Int, startDate:Date, regDate:Date){
        self.init()
        
        self.profileImg = profileImg ?? nil
        self.nickName = nickName
        self.waterDay = waterDay
        self.startDate = startDate
        self.regDate = regDate
    
    }
}

class feed: Object {
    @Persisted var feedTitle: String = "" // 제목: 필수
    @Persisted var feedImg: String? = "" // 사진: 옵션 없으면 기본이미지 제공
    @Persisted var feedContent: String // 내용 : 필수
    @Persisted var regDate = Date() //등록 날짜 :필수
   //PK(필수) ObjectID 사용
    @Persisted(primaryKey: true) var _id: ObjectId
   
    convenience init(feedImg:String?, feedTitle:String,feedContent:String, regDate:Date){
        self.init()
        
        self.feedImg = feedImg ?? nil
        self.feedTitle = feedTitle
        self.feedContent = feedContent
        self.regDate = regDate
    }
}
