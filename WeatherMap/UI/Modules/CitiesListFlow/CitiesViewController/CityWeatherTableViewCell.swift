//
//  CityWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

final class CityWeatherTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = typeName
    
    var cityWeatherModel: CityWeatherModel? = nil
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var dayTemeratureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: CityWeatherModel) {
        self.cityWeatherModel = model
        cityNameLabel.text = model.cityName
        weatherDescriptionLabel.text = model.weatherDescription
        dayTemeratureLabel.text = model.tempC + "º"
        weatherImageView.image = UIImage(weatherCodeString: model.weatherCode)
    }

}
