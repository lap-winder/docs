//
//  WineInfoTasteNoteView.swift
//  Winder
//
//  Created by 이동규 on 2021/11/23.
//

import Foundation
import UIKit

//"intensity": "1.5",
//"acidity" : "3.5",
//"sweetness": "4.0",
//"tannic": "3.2",

class WineInfoTasteNoteView: UIView {
    @IBOutlet weak var tasteNoteintensitySlider: UISlider!
    @IBOutlet weak var tasteNoteTannicSlider: UISlider!
    @IBOutlet weak var tasteNoteSweetnessSlider: UISlider!
    @IBOutlet weak var tasteNoteAciditySlider: UISlider!
}
