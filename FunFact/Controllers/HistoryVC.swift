//
//  HistoryVC.swift
//  FunFact
//
//  Created by Vasu Chand on 28/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UIViewController {

    @IBOutlet weak var mTblView: UITableView!
    
    private let cell_identifier = "HistoryTblCell"
    private var mDataSource:[Facts] = []
    
    var dataController:CoreDataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        mTblView.delegate = self
        mTblView.dataSource = self
        setupFetchedResults()
        // Do any additional setup after loading the view.
    }
    func configureDataSource(){
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func setupFetchedResults() {
        let fetchRequest:NSFetchRequest<Facts> = Facts.fetchRequest()
        
        if let result =  try? dataController.viewContext.fetch(fetchRequest){
            mDataSource = result
            mTblView.reloadData()
        }else{
            print("Error while fetching Pins from CoreData.....")
        }
    }

    func registerNib(){
        let cellNib = UINib.init(nibName: cell_identifier, bundle: nil)
        mTblView.register(cellNib, forCellReuseIdentifier: cell_identifier)
    }
}
extension HistoryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as? HistoryTblCell
        let data = mDataSource[indexPath.row]
        cell?.configureUIWith(data.category ?? "", data.value ?? "")
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let obj = mDataSource[indexPath.row];
            mTblView.beginUpdates()
            mDataSource.remove(at: indexPath.row)
            mTblView.deleteRows(at: [indexPath], with: .none)
            mTblView.endUpdates()
            
            dataController.viewContext.delete(obj)
            try? dataController.viewContext.save()
            print("Items deleted ...")
        }
    }
    
}
