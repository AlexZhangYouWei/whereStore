//
//  AppDelegate.h
//  專題
//
//  Created by user44 on 2017/9/27.
//  Copyright © 2017年 user44. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
    //class ViewController: UIViewController {
    
  //  var reference: DatabaseReference!
    //var refHandle: DatabaseHandle?
    
    //override func viewDidLoad() {
      //  super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        // var ref: DatabaseReference!
        //
        // ref = Database.database().reference()
        // var database = Database.database()
        
        
        
        
        
        // // 新增節點資料
        // reference = Database.database().reference().child("movie")
        //
        // var movieReview: [String : AnyObject] = [String : AnyObject]()
        // movieReview["movieId"] = "0000001" as AnyObject
        // movieReview["movieName"] = "玩命關頭8" as AnyObject
        // movieReview["movieReview"] = "緊張刺激，不可不看！" as AnyObject
        // movieReview["userName"] = "20170424" as AnyObject
        //
        // let childRef = reference.childByAutoId() // 隨機生成的節點唯一識別碼，用來當儲存時的key值
        // let movieReviewReference = reference.child(childRef.key)
        //
        // movieReviewReference.updateChildValues(movieReview) { (err, ref) in
        // if err != nil{
        // print("err： \(err!)")
        // return
        // }
        //
        // print(ref.description())
        // }
        
        
        
        // 新增 修改 節點資料
        // reference = Database.database().reference()
        // //特定節點新增(會覆蓋節點內資料小心使用)
        // reference.child("movie").child("setValue").setValue(["username": "yui"]) 
        // //在新產生id的節點內新增
        // reference.childByAutoId().setValue(["new3" : "03"])
        
        
        
        
        // //listen 資料的更動
        // refHandle = reference.observe(.value, with: { (snapshot) in
        //
        // if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
        // }
        // let ddd = snapshot.childSnapshot(forPath: "movie").value as? [String : AnyObject] ?? [:]
        // let ccc = snapshot.childSnapshot(forPath: "movieId").value as? [String : AnyObject] ?? [:]
        // let postDict = snapshot.value as? [String : AnyObject] ?? [:]
        // // ...
        // print(postDict)
        // print(ddd)
        // print(ccc)
        // })
        
        
        
        
        
        
        
        
        
        // // 查詢節點資料
        // Database.database().reference().child("movie").child("setValue").observe(.value, with: {
        // (snapshot) in
        //
        // if let dictionaryData = snapshot.value as? [String: AnyObject]{
        // print(dictionaryData)
        // print("key " + snapshot.key)
        // }
        //
        // }, withCancel: nil)
        
        // //特殊查詢
        // let Ref = Database.database().reference()
        // //設定要取最新的幾筆資料
        // let myDataBaseQuery = Ref.queryLimited(toLast: 2)
        //
        //
        // let myDataBaseHandle = myDataBaseQuery.observe(.childAdded, with: { (snapashot) in
        // if let data = snapashot.value{
        // print(data)
        // }
        // })
        
        
        
        
        
        
        // // 刪除節點資料
        // Database.database().reference().child("4545").child("userName").removeValue { (error, ref) in
        // if error != nil{
        // print(error!)
        // return
        // }
        //
        // print("remove data success...")
        // }
        
        

    


@end

