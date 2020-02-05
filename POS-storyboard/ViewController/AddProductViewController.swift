//
//  AddProductViewController.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/12.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var category_id = ""
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    var chooseArray:[String] = []
    @IBOutlet weak var chooseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "新增細項", style: UIBarButtonItem.Style.done, target: self, action: #selector(AddProductViewController.addChhoseClick(_:))),UIBarButtonItem(title: "儲存", style: UIBarButtonItem.Style.done, target: self, action: #selector(AddProductViewController.saveClick(_:)))]
        
    }
    @objc func addChhoseClick(_ sender:UIButton){
        chooseArray.insert("Choose", at: chooseArray.count - 1)
        chooseArray.insert("AddAnswer", at: chooseArray.count - 1)
        chooseTableView.reloadData()
    }
    @objc func saveClick(_ sender:UIButton){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chooseArray[indexPath.row] == "Choose" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddChooseTableViewCell") as! AddChooseTableViewCell
            cell.selectionStyle = .none
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteChhoseClick(_:)), for: UIControl.Event.touchUpInside)
            return cell
        }
        else if chooseArray[indexPath.row] == "AddAnswer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell") as! AddTableViewCell
            cell.titleLabel.text = "新增選項"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddChooseAnswerTableViewCell") as! AddChooseAnswerTableViewCell
            cell.selectionStyle = .none
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAnswerClick(_:)), for: UIControl.Event.touchUpInside)
            return cell
        }
    }
    
    @objc func deleteChhoseClick(_ sender:UIButton) {
        
    }
    @objc func deleteAnswerClick(_ sender:UIButton) {
        chooseArray.remove(at: sender.tag)
        chooseTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chooseArray[indexPath.row] == "AddAnswer" {
            chooseArray.insert("Answer", at: indexPath.row - 1)
            chooseTableView.reloadData()
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
