//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 09.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

protocol CityWeatherViewRouting: BaseRouting {
    func navigateBack(animated: Bool, _ completion: (() -> Void)?)
}

protocol CityWeatherViewModeling: BaseViewModeling {
    var cityWeatherModel: CityWeatherModel? { get }
}

final class CityWeatherViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityNameLabel: UINavigationItem!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weekdaysWeatherTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    
    private var dataSource: WeekdaysWeatherDataSource!
    
    var router: CityWeatherViewRouting?
    var viewModel: CityWeatherViewModeling? {
        didSet {
            viewModel?.didChange = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.update()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupDataSource()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        SynchronizationService.shared.updateData(completion: { [weak self] (hasInternetConnection) -> Void in
            if !hasInternetConnection {
                self?.showErrorAlert(message: "Нет соединения с интернетом")
            }
        })
        
        refreshControl.endRefreshing()
        UIView.animate(withDuration: 1, animations: {
            self.scrollView.contentOffset = CGPoint.zero
        })
    }
    
    private func setupDataSource() {
        dataSource = WeekdaysWeatherDataSource(tableView: weekdaysWeatherTableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeekDayWeatherTableViewCell.reuseIdentifier, for: indexPath) as? CityWeekDayWeatherTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            
            return cell
        })
    }
    
    func update() {
        guard let model = viewModel?.cityWeatherModel else {
            return
        }
        
        cityNameLabel.title = model.cityName
        weatherDescriptionLabel.text = model.weatherDescription.description
        weatherImageView.image = UIImage(weatherCodeString: model.weatherCode)
        tempLabel.text = model.tempC + "º"
        humidityLabel.text = "Влажность: " + model.humidity + "%"
        windSpeedLabel.text = "Скорость ветра: \(model.windSpeedMPSDescription)"
        updateTableView(animatingDifferences: true)
    }
    
    func updateTableView(animatingDifferences: Bool) {
        var snapshot = WeekdaysWeatherSnapshot()
        
        snapshot.appendSections([.only])
        
        let items = viewModel?.cityWeatherModel?.weekdaysWeather ?? []
        
        snapshot.appendItems(items, toSection: .only)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        router?.navigateBack(animated: true, nil)
    }
    
}

extension CityWeatherViewController: UITableViewDelegate {
    
}

