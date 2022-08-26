//
//  DayForecastTableViewCell.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minMaxTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            dayLabel.textColor = UIColor.blue
            minMaxTemperature.textColor = UIColor.blue
            weatherImageView.tintColor = UIColor.blue
        } else {
            dayLabel.textColor = UIColor.black
            minMaxTemperature.textColor = UIColor.black
            weatherImageView.tintColor = UIColor.black
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    func configure(timeInterval: Int, minMaxTemp: String, image: UIImage?) {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        self.dayLabel.text =  dateFormatter.string(from: date)
        self.minMaxTemperature.text = minMaxTemp
        if let image = image {
            self.weatherImageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        
    }
    
}
