//
//  CityWeekDayWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

final class CityWeekDayWeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = typeName

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var dayTemeratureLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: WeekdayWeatherModel) {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        let stringDate = dateFormatter.string(from: model.date)
        weekDayLabel.text = stringDate
        
        weatherDescriptionLabel.text = model.weatherDescription
        dayTemeratureLabel.text = model.avgTempC + "º"
        nightTemperatureLabel.text = model.minTempC + "º"
        
        weatherImageView.image = UIImage(weatherCodeString: model.weatherCode)
    }

}
