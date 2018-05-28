//
//  ListTableViewCell.swift
//  Checklist
//
//  Created by Thao Doan on 5/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

protocol ListCellDelegate: class {
    func cellButtonTapped(_ cell: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    weak var delegate: ListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func toggleImage(isDone: Bool) {
        let imageName = isDone ? "checkbox" : "uncheck"
        
        guard let image = UIImage(named: imageName) else {return}
        
        checkButton.setImage(image, for: .normal)
        
    }
    
    func updateCell(list:List) {
        
        toggleImage(isDone: list.isDone)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkButtonTapped(_ sender: Any) {
        
        delegate?.cellButtonTapped(self)
    }
    
}
