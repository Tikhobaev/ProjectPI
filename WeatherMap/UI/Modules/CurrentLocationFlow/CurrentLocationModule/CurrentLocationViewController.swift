//
//  CurrentLocationViewController.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

enum WeekdaysWeatherSectionType: Hashable {
    case only
}

protocol CurrentLocationViewControllerRouting: BaseRouting {
    
}

protocol CurrentLocationViewModeling: BaseViewModeling {
    
    var currentLocationWeatherModel: CurrentLocationWeatherModel? { get }
    
}

typealias WeekdaysWeatherDataSource = UITableViewDiffableDataSource<WeekdaysWeatherSectionType, WeekdayWeatherModel>
typealias WeekdaysWeatherSnapshot = NSDiffableDataSourceSnapshot<WeekdaysWeatherSectionType, WeekdayWeatherModel>

final class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var todayWeatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weekdaysWeatherTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    private var dataSource: WeekdaysWeatherDataSource!
    
    var router: CurrentLocationViewControllerRouting?
    var viewModel: CurrentLocationViewModeling? {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekDayWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekDayWeatherTableViewCell else {
                return UITableViewCell()
            }
    
            cell.configure(with: model)
            
            return cell
        })
    }
    
    func update() {
        guard isViewLoaded else {
            return
        }
        
        guard let model = viewModel?.currentLocationWeatherModel else {
            return
        }
        cityNameLabel.text = model.cityName
        todayWeatherLabel.text = "ПОГОДА СЕГОДНЯ:"
        weatherDescriptionLabel.text = model.weatherDescription.description
        tempLabel.text = model.tempC + "º"
        humidityLabel.text = "Влажность: " + model.humidity + "%"
        weatherImageView.image = UIImage(weatherCodeString: model.weatherCode)
        windSpeedLabel.text = "Скорость ветра: \(model.windSpeedMPSDescription)"
        
        updateTableView(animatingDifferences: true)
    }
    
    func updateTableView(animatingDifferences: Bool) {
        var snapshot = WeekdaysWeatherSnapshot()
        
        snapshot.appendSections([.only])
        
        let items = viewModel?.currentLocationWeatherModel?.weekdaysWeather ?? []
        
        snapshot.appendItems(items, toSection: .only)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

}

extension CurrentLocationViewController: UITableViewDelegate {
    
}
