//
//  HistoryTblCell.swift
//  FunFact
//
//  Created by Vasu Chand on 29/05/19.
//  Copyright © 2019 Vasu Chand. All rights reserved.
//

import UIKit

class HistoryTblCell: UITableViewCell {

    @IBOutlet weak var mCategoryLbl: UILabel!
    @IBOutlet weak var mValueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureUIWith(_ category:String, _ desc:String){
        mCategoryLbl.text = category
        mValueLbl.text = desc
    }
    
}
