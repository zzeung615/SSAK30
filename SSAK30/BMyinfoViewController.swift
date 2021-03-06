//
//  BMyinfoViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

class BMyinfoViewController: UIViewController, BMyInfoQueryModelProtocol, BMyInfoBuyListQueryModelProtocol, UITableViewDataSource, UITableViewDelegate{


    var feedItem: NSArray = NSArray()
    var feedItem2: NSArray = NSArray()
    var uSeqno: String = String(UserDefaults.standard.integer(forKey: "uSeqno"))
    var thiryCash:String?
    var myCash:Int = 0
    var totalCash:Int = 0
    var usePrice:Int = 0
    
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var tvMyBuyList: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = UIImage(named: "person.png")
        
        self.reloadInputViews()
        // 다 내가(tableViewController) 할거다 선언.
        self.tvMyBuyList.delegate = self
        self.tvMyBuyList.dataSource = self
        self.tvMyBuyList.rowHeight = 115
        
        imgUserImage.image = UIImage(named: "emptyImage.png")
        self.imgUserImage.layer.cornerRadius = self.imgUserImage.frame.height/2
        self.imgUserImage.layer.borderWidth = 1
        self.imgUserImage.layer.borderColor = UIColor.clear.cgColor
        self.imgUserImage.clipsToBounds = true
        
        let queryModel = BMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno)
        
        let queryModel2 = BMyInfoBuyListQueryModel()
        queryModel2.delegate = self
        queryModel2.downloadItems(uSeqno: uSeqno)

    }
    func itemDownloaded(items: NSArray) {
        feedItem = items
        let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        
        if item.uImage!.isEmpty {
            self.imgUserImage.image = UIImage(named: "emptyImage.png")
        } else {
            //Firbase 이미지 불러오기
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imgRef = storageRef.child("uImage").child(item.uImage!)
            
            imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
                if error != nil {
                    self.imgUserImage.image = UIImage(named: "emptyImage.png")
                } else {
                    self.imgUserImage.image = UIImage(data: data!)
                }
            }
        }
        
        lblName.text = item.uName
        lblCash.text = item.totalCash
    }
    func buyListitemDownloaded(items: NSArray) {
        feedItem2 = items
    
        self.tvMyBuyList.reloadData()
        }
    
    
    override func viewWillAppear(_ animated: Bool) { // 입력 후 DB 에서 다시 읽어들이기
        let queryModel = BMyInfoQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return feedItem2.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell", for: indexPath) as! BMyInfoTableViewCell
        // Configure the cell...
        let item: BMyInfoDBModel = feedItem2[indexPath.row] as! BMyInfoDBModel // 배열로 되어있는 것을 class(DBModel) 타입으로 바꾼다.
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sbImage").child(item.sellImage!)
        
        if !item.sellImage!.isEmpty {
            imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
                if error != nil {
                    cell.imgImage.image = UIImage(named: "emptyImage.png")
                } else {
                    cell.imgImage.image = UIImage(data: data!)
                }
            }
        } else {
            cell.imgImage.image = UIImage(named: "emptyImage.png")
        }
        cell.lblTitle.text = (item.sellTitle)
        cell.lblPrice.text = (item.priceEA!)
        return cell
    }
    
    @IBAction func btnUpdateMyInfo(_ sender: UIButton) {
//        let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel
//        let checkAlert = UIAlertController(title: "알림", message: "비밀번호를 입력하세요.", preferredStyle: UIAlertController.Style.alert)
//        let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
//            let insertPW = checkAlert.textFields![0].text
//            let password = item.uPassword
//            if(insertPW == password){
//                print("OK")
////                self.navigationController?.popViewController(animated: true)
//            }else{
//                print("FAIL")
//                let checkAlert = UIAlertController(title: "알림", message: "비밀번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//                let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
//                checkAlert.addAction(onAction)
//            }
//        })
//        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
//        checkAlert.addAction(onAction)
//        checkAlert.addAction(cancelAction)
//        checkAlert.addTextField()
//        present(checkAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnChargeCash(_ sender: UIButton) {
        let resultAlert = UIAlertController(title: "충전", message: "충전하실 금액을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "충전하기", style: UIAlertAction.Style.default, handler: {ACTION in
            self.myCash = Int(self.lblCash.text!)!
            self.usePrice = Int(resultAlert.textFields![0].text!)!
            self.totalCash = self.myCash + self.usePrice
            self.lblCash.text = String(self.totalCash)
            let queryModel = BChargeCashQueryModel()
            queryModel.updateItem(uSeqno: self.uSeqno, thiryCash: String(self.totalCash), usePrice: String(self.usePrice))
            })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        resultAlert.addAction(onAction)
        resultAlert.addAction(cancelAction)
        resultAlert.addTextField()
        present(resultAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
            if segue.identifier == "sgUpdate"{
                
                let detailView = segue.destination as! BUpdateInfoViewController
                
                let item: BMyInfoDBModel = feedItem[0] as! BMyInfoDBModel

                let uName = String(item.uName!)
                let uImage = String(item.uImage!)
                let uPassword = String(item.uPassword!)
                let uPhone = String(item.uPhone!)
                let uEmail = String(item.uEmail!)
                
                detailView.receiveItems(uSeqno, uName, uImage, uPassword, uPhone, uEmail)
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
}//------
