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

class HomePageVC: UIViewController {

    @IBOutlet weak var mCollectionView: UICollectionView!    
    var mDataSource = [DataSource]()
    private let cell_identifier = "HomaPageCVC"
    private var msgForDisplay:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        registerNib()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.reloadData()
        // Do any additional setup after loading the view.
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
                self.showPOPUP()
            }
        case .fun:
            FactsEngine.getRandomJokes { (response, error) in
               SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data.value?.joke
                self.showPOPUP()
            }
        case .number(_):
            FactsEngine.getNumberTrivia { (response, error) in
                SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data.text
                self.showPOPUP()
            }
        case .math:
            FactsEngine.getMathRandomFacts { (response, error) in
                SVProgressHUD.dismiss()
                guard let data = response else {
                    self.msgForDisplay = error?.localizedDescription
                    return
                }
                self.msgForDisplay = data
                self.showPOPUP()
            }


        }
        
    }
    private func showPOPUP(){
        let popup = PopupDialog(title: nil, message: msgForDisplay, image: nil)
        
        let buttonOne = DefaultButton(title: "OK", dismissOnTap: false) {
            self.dismiss(animated: true, completion: nil)
        }
        popup.addButtons([buttonOne])
        self.present(popup, animated: true, completion: nil)
    }
}

