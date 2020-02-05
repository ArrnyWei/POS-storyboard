//
//  MainViewController.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/9.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var revenueProductTableView: UITableView!
    
    var categoryArray:[Category] = []
    var productArray:[ProductM] = []
    var revenueProductArray:[RevenueProductM] = []
    var currentCategory_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.revenueProductTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "選項", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MainViewController.menuClick(_:))),UIBarButtonItem(title: "登出", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MainViewController.logoutClick(_:)))]
        
        
        reloadCategoryData()
        
    }
    
    @objc func logoutClick(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func menuClick(_ sender:UIButton){
           
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revenueProductArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView {
            return categoryArray.count + 1
        }
        else {
            return productArray.count + 1
        }
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UItable
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RevenueProductTableViewCell") as! RevenueProductTableViewCell
        
        cell.titleLabel.text = revenueProductArray[indexPath.row].totalChooseAnswer
        cell.amountLabel.text = "\(revenueProductArray[indexPath.row].amount)"
        cell.countLabel.text = "\(revenueProductArray[indexPath.row].count)"
        cell.countStepper.value = Double(revenueProductArray[indexPath.row].count)
        cell.countStepper.tag = indexPath.row
        cell.countStepper.addTarget(self, action: #selector(MainViewController.revenueProductStepperAction(_:)), for: UIControl.Event.valueChanged)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(MainViewController.deleteClick(_:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    @objc func revenueProductStepperAction(_ sender:UIStepper){
        
    }
    
    @objc func deleteClick(_ sender:UIButton){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            if indexPath.row == categoryArray.count {
                cell.categoryLabel.text = "新增類別"
            }
            else{
                cell.categoryLabel.text = categoryArray[indexPath.row].name
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            if indexPath.row == productArray.count{
                cell.nameLabel.text = "新增產品"
                cell.priceLabel.text = ""
            }
            else {
                cell.nameLabel.text = productArray[indexPath.row].name
                cell.priceLabel.text = "$ \(productArray[indexPath.row].price) 元"
            }
            return cell
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView {
            if indexPath.row == self.categoryArray.count {
                //新增類別
                let alertController = UIAlertController(title: "清輸入名稱", message: nil, preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (textfield) in
                    textfield.placeholder = "請輸入類別名稱"
                }
                
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: { (action) in
                    let tempTextField = alertController.textFields![0];
                    let result = CoreDataConnect.coreDataConnect.insert("Category", attributeInfo: ["name" : tempTextField.text!])
                    if result{
                        print("新增成功")
                    }
                    else {
                        print("新增失敗")
                    }
                    self.reloadCategoryData()
                }))
                
                alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                //切換產品
                currentCategory_id = String(categoryArray[indexPath.row].id)
                reloadProductDatay()
            }
        }
        else {
            //點選產品跳出選項以及選擇數量畫面
            if indexPath.row == self.productArray.count{
                //切換產品新增頁面
                performSegue(withIdentifier: "mainToAddProduct", sender: nil)
            }
            else {
                //選擇畫面
            }
        }
    }
    
    func reloadCategoryData(){
        self.categoryArray = CoreDataConnect.coreDataConnect.fetch(myEntityName: "Category", predicate: nil, sort: nil, limit: nil) as! [Category]
        
        self.categoryCollectionView.reloadData()
    }
    
    func reloadProductDatay(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToAddProduct"{
            let destination = segue.destination as! AddProductViewController
            destination.category_id = currentCategory_id
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

}
