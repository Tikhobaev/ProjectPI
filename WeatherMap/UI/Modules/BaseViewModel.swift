//
//  BaseViewModel.swift
//  WeatherApp
//
//  Created by Dmitry Lemaykin on 31.03.2020.
//  Copyright © 2020 Dmitry Lemaykin. All rights reserved.
//
//  Base class for all ViewModel's in the app.

import Foundation

public protocol BaseViewModeling: class {
    var isLoading: Bool { get }
    
    var didChange: (() -> Void)? { get set }
    var didGetError: ((_ message: String) -> Void)? { get set }
}

public class BaseViewModel: NSObject, BaseViewModeling {
    
    public var isLoading = false {
        didSet {
            didChange?()
        }
    }
    
    public var didChange: (() -> Void)? {
        didSet {
            didChange?()
        }
    }
    
    public var didGetError: ((_ message: String) -> Void)?
}



