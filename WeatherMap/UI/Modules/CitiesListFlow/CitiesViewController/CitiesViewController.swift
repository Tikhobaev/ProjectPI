//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

enum CitiesSectionType: Hashable {
    case only
}

protocol CitiesViewControllerRouting: BaseRouting {
    func presentCityWeatherViewController(cityWeatherModel: CityWeatherModel?, _ completion: (() -> Void)?)
}

protocol CitiesViewModeling: BaseViewModeling {
    
    var citiesWeatherModels: [CityWeatherModel] { get }
    
    var noNetworkConnection: (() -> Void)? { get set }
    var didRecieveLocationNotFoundError: (() -> Void)? { get set }
    var didAddCitySuccessfully: ((String) -> Void)? { get set }
    var didGetEmptyNameForRequest: (() -> Void)? { get set }
    var didGetRepeatingCity: (() -> Void)? { get set }
    
    func checkAndAddLocation(_ locationName: String)
}


typealias CitiesSnapshot = NSDiffableDataSourceSnapshot<CitiesSectionType, CityWeatherModel>
final class CitiesDataSource: UITableViewDiffableDataSource<CitiesSectionType, CityWeatherModel> {
    
    let unremovableCities = ["Москва", "Минск"]
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cityWeatherTableViewCell = tableView.cellForRow(at: indexPath) as? CityWeatherTableViewCell, let cityName = cityWeatherTableViewCell.cityWeatherModel?.cityName else {
            return true
        }
        if unremovableCities.contains(cityName) {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let cityWeatherTableViewCell = tableView.cellForRow(at: indexPath) as? CityWeatherTableViewCell, let cityNameForDeletion = cityWeatherTableViewCell.cityWeatherModel?.cityName else {
            return
        }
        if editingStyle == .delete {
            CoreDataService.shared.removeCityWeatherEntity(for: cityNameForDeletion)
        }
    }

}

final class CitiesViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    private var dataSource: CitiesDataSource!

    var router: CitiesViewControllerRouting?
    var viewModel: CitiesViewModeling? {
        didSet {
            viewModel?.didRecieveLocationNotFoundError = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "Место с таким названием не найдено. Возможно, вы допустили ошибку. Попробуйте еще раз ввести это название или сделайте его более подробным (укажите область, страну)")
                }
            }
            viewModel?.didAddCitySuccessfully = { [weak self] (locationName) in
                DispatchQueue.main.async { [weak self] in
                    self?.showMessageAlert(message: "Локация \(locationName) успешно добавлена")
                }
            }
            
            viewModel?.noNetworkConnection = { [weak self] () in
                DispatchQueue.main.async { [weak self] in
                    self?.showMessageAlert(message: "Нет соединения с интернетом")
                }
            }
            
            viewModel?.didGetEmptyNameForRequest = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "Пожалуйста, укажите название города")
                }
            }
            
            viewModel?.didGetRepeatingCity = { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.showErrorAlert(message: "Этот город уже есть в списке")
                }
            }
            
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
        citiesTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        SynchronizationService.shared.updateData(completion: { [weak self] (hasInternetConnection) -> Void in
            if !hasInternetConnection {
                self?.showErrorAlert(message: "Нет соединения с интернетом")
            }
        })
        
        refreshControl.endRefreshing()
        UIView.animate(withDuration: 1, animations: {
            self.citiesTableView.contentOffset = CGPoint.zero
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
    }
    
    func update() {
        guard isViewLoaded else {
            return
        }
        updateTableView(animatingDifferences: true)
    }
    
    func updateTableView(animatingDifferences: Bool) {
        var snapshot = CitiesSnapshot()
        
        snapshot.appendSections([.only])
        
        let items = viewModel?.citiesWeatherModels ?? []
        
        snapshot.appendItems(items, toSection: .only)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func setupDataSource() {
        dataSource = CitiesDataSource(tableView: citiesTableView, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier:  CityWeatherTableViewCell.reuseIdentifier, for: indexPath) as? CityWeatherTableViewCell else {
                return UITableViewCell()
            }
    
            cell.configure(with: model)
            
            return cell
        })
    }
    
    private func presentAddNewCityAlertController() {
        let ac = UIAlertController(title: "Название города", message: "Введите название города", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Название города"
            textField.autocapitalizationType = .sentences
            textField.textContentType = .addressCity
            textField.autocorrectionType = .yes
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            ac.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] (_) in
            guard let textField = ac.textFields?.first,
                  let locationName = textField.text else {
                return
            }
            self?.viewModel?.checkAndAddLocation(locationName)
        }
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func addNewCity(_ sender: Any) {
        presentAddNewCityAlertController()
    }
    
}

extension CitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CityWeatherTableViewCell else {
            return
        }
        
        router?.presentCityWeatherViewController(cityWeatherModel: cell.cityWeatherModel, nil)
    }
    
}
