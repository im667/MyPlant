//
//  SettingViewController.swift
//  MyPlant
//
//  Created by mac on 2021/11/18.
//

import UIKit
import Zip
import MobileCoreServices

class SettingViewController: UIViewController {

    
    
    @IBOutlet weak var backupDataButton: UIButton!
    
    
    @IBOutlet weak var shareDataButton: UIButton!
    
    
    @IBOutlet weak var restoreDataButton: UIButton!
    
    
    @IBOutlet weak var openSource: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        backupDataButton.clipsToBounds = true
        backupDataButton.layer.cornerRadius = 10
        
        
        shareDataButton.clipsToBounds = true
        shareDataButton.layer.cornerRadius = 10
        
        restoreDataButton.clipsToBounds = true
        restoreDataButton.layer.cornerRadius = 10
        
        openSource.clipsToBounds = true
        openSource.layer.cornerRadius = 10
     
    }
    
    @IBAction func backupDataButton(_ sender: UIButton) {
        
        //복구 1. import MobileCoreService + 파일앱 열기 + 확장자
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        self.present(documentPicker,animated: true, completion: nil)
        
    }
    
    
    func documentDirectoryPath()->String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            return directoryPath
        } else {
            return nil
        }
    }
    
    func presentActivityViewController() {
        //압축파일 경로가져오기
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        
        self.present(vc,animated: true, completion: nil)
    }

    
    @IBAction func shareDataButton(_ sender: UIButton) {
        
        presentActivityViewController()
        
    }
    
    
    
    @IBAction func restoreDataButton(_ sender: UIButton) {
        
        var urlPaths = [URL]()
        
        //1.도큐먼트 폴더 위치 ( desktop/mac/ios/~~~~default.realm)
        if let path = documentDirectoryPath(){
            //2.백업하고자 하는 파일 경로 확인
            //이미지 같은 경우, 백업편의성을 위해 폴더를 생성하고, 폴더내에 이미지를 저장하는 것이 효율적
            let realm = (path as NSString).appendingPathComponent("default.realm")
            
            //2-1.파일의 존재여부 확인
            if FileManager.default.fileExists(atPath: realm){
                //5. URL 배열에 백업파일 추가
                urlPaths.append(URL(string: realm)!)
            } else {
                print("백업할 파일이 없습니다.")
            }
        }
        
        
        
        //3. 백업 4번배열에 대해 압축파일 만들기
        do {
           
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive") // Zip
            print("압축경로 \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
          print("Something went wrong")
        }
        
    }
    
    
    @IBAction func openSource(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        
      
        guard let vc = sb.instantiateViewController(withIdentifier: "OpenSourceViewController") as? OpenSourceViewController else { return }
        
            
        self.navigationController?.pushViewController(vc, animated: true)
            
        
    }
    
    
}


extension SettingViewController:UIDocumentPickerDelegate{
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function)
        
        //복구 - 2.선택한 파일에 대한 경로 가져와야함~~~~~!
        //ex. iphone/jack/fileapp/archive.zip
        guard let selectedFileURL = urls.first else {return}
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        //복구 - 3. 압축해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path){
          //기존에 복구하고자 하는 ZIP파일을 도큐먼트에 위치한 zip에 압축해제 하면 됨!
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: {progress in
                    print("progress:\(progress)")
                    //복구가 완료되었습니다. 메시지, 얼럿
                }, fileOutputHandler: {unzippedFile in
                                  print("unzippedFile\(unzippedFile)")
                })
            } catch {
                print("error")
            }
        } else {
            //파일앱의 Zip -> 도큐먼트 폴더에 복사
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: {progress in
                    print("progress:\(progress)")
                    //복구가 완료되었습니다. 메시지, 얼럿
                }, fileOutputHandler: {unzippedFile in
                                  print("unzippedFile\(unzippedFile)")
                })
            } catch {
                print("error")
            }
            
        }
        
        
    }
}
