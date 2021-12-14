//
//  SearchWineCell.swift
//  Winder
//
//  Created by 이동규 on 2021/11/17.
//

import Foundation
import UIKit

class SearchWineCell: UITableViewCell {
    
    // 기본적인 파싱 데이터 UI
    @IBOutlet weak var wineImageView: UIImageView!
    @IBOutlet weak var wineTitleLabel: UILabel!
    @IBOutlet weak var wineryLabel: UILabel!
    @IBOutlet weak var wineCountryAndRegionLabel: UILabel!
    @IBOutlet weak var wineCountryIcon: UIImageView!
    @IBOutlet weak var wineTypeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // UI만을 위한 유틸 요소
    @IBOutlet weak var backLabelWineType: UILabel! {
        didSet {
            backLabelWineType.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var backLabelRating: UILabel!
    @IBOutlet weak var backLabelPricing: UILabel!
    
    //+
}
