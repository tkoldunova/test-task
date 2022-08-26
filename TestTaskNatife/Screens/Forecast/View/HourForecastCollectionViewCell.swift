//
//  HourForecastCollectionViewCell.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit

class HourForecastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempretureLabel: UILabel!
    
    func configure(time: String, temperature: Double, image: UIImage?) {
        self.timeLabel.text = time
        self.tempretureLabel.text = String(format: "%.1f", temperature) + "º"
        if let image = image {
            self.weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
            self.weatherImageView.tintColor = UIColor.white
            
        }
        
    }
}
