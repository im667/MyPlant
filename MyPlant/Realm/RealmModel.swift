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
    @Persisted var feed: String = "" // 내용 : 필수
    @Persisted var writeDate = Date() //작성 날짜: 필수
    @Persisted var regDate = Date() //등록 날짜 :필수
   //PK(필수) ObjectID 사용
    @Persisted(primaryKey: true) var _id: ObjectId
   
    convenience init(diaryTitle:String, feed:String, writeDate:Date, regDate:Date){
        self.init()
        
        self.nickName = nickName
        self.feed = feed
        self.writeDate = writeDate
        self.regDate = regDate
    }
}
