//
//  ViewController.swift
//  FunFact
//
//  Created by Vasu Chand on 19/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit
import SVProgressHUD
import PopupDialog
import CoreData
import Toaster

class HomePageVC: UIViewController {

    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mHisotryBtn: UIButton!
    
    var mDataSource = [DataSource]()
    private let cell_identifier = "HomaPageCVC"
    private var msgForDisplay:String?
    var dataController:CoreDataController!
    var factsRes: [Facts] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        registerNib()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func registerNib(){
        let cellNib = UINib.init(nibName: cell_identifier, bundle: nil)
        mCollectionView.register(cellNib, forCellWithReuseIdentifier: cell_identifier)
    }

    private func configureDataSource(){
        //Random
        let random = DataSource(cellType: .number(""), desc: "Random Number Facts")
        //Cat
        let cat = DataSource(cellType: .cat, desc: "Cat Facts")
        //Math
        let math = DataSource(cellType: .math, desc: "Math Facts")
        //fun
        let fun = DataSource(cellType: .fun, desc: "Fun Facts")
        
        mDataSource.append(random)
        mDataSource.append(math)
        mDataSource.append(fun)
        mDataSource.append(cat)
        
    }
    
    @IBAction func historyBtnPressed(_ sender: Any) {
       performSegue(withIdentifier: "HistoryVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryVC" {
            
            if let vc = segue.destination as? HistoryVC {
                
                vc.dataController = dataController
            }
        }
    }
}
extension HomePageVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_identifier, for: indexPath) as! HomaPageCVC
        
        let dataObj = mDataSource[indexPath.row]
        cell.configureUI(obj: dataObj)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width)/2-24, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard Reachability.isConnectedToNetwork() else{
            Toast(text: "No Internet Connection !!!").show()
            return
        }
        
        let obj = mDataSource[indexPath.row]
        SVProgressHUD.show(withStatus: "Processing...")
    
        switch obj.cellType {
        case .cat:
            FactsEngine.getCatFacts { [weak self](response, error) in
                SVProgressHUD.dismiss()
                guard let self = self else{return}
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data.fact
                self.showPOPUP("Cat")
            }
        case .fun:
            FactsEngine.getRandomJokes { (response, error) in
               SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data.value?.joke
                self.showPOPUP("Fun")
            }
        case .number(_):
            FactsEngine.getNumberTrivia { (response, error) in
                SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data.text
                self.showPOPUP("Number")
            }
        case .math:
            FactsEngine.getMathRandomFacts { (response, error) in
                SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data
                self.showPOPUP("Math")
            }


        }
        
    }
    private func showPOPUP(_ category:String?){
        let popup = PopupDialog(title: nil, message: msgForDisplay, image: nil)
        
        let buttonOne = DefaultButton(title: "OK", dismissOnTap: false) {
            self.dismiss(animated: true, completion: nil)
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
        
        let fact = Facts(context: dataController.viewContext)
        fact.category = category
        fact.value = msgForDisplay
        do{
            try self.dataController.viewContext.save()
        }catch{
            print("Error while saving .....\(error.localizedDescription)  ....")
        }
    }
    
    
}

