//
//  RoomDetailsTableViewCell.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 17/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import UIKit

class RoomDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var roomDetailsCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        roomDetailsCellView.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
