//
//  Place.swift
//  Saving Places
//
//  Created by Christian Alvarez on 12/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import Foundation

class Place: NSObject, NSCoding {
    
    private var _name: String?
    private var _longitude: Double?
    private var _latitude: Double?
    
    enum Keys {
        static let Name = "name"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
    }
    
    
    //MARK: - Necessary init methods
    override init() { }
    
    init(name: String, longitude: Double, latitude: Double) {
        _name = name
        _longitude = longitude
        _latitude = latitude
    }
    
    //MARK: - Getters and Setters
    
    var name: String? {
        get {
            return _name
        }
        
        set {
            _name = newValue
        }
    }
    
    var longitude: Double? {
        get {
            return _longitude
        }
        
        set {
            _longitude = newValue
        }
    }
    
    var latitude: Double? {
        get {
            return _latitude
        }
        
        set {
            _latitude = newValue
        }
    }
    
    //MARK: - NSCoder required methods
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: Keys.Name)
        aCoder.encode(_longitude, forKey: Keys.Longitude)
        aCoder.encode(_latitude, forKey: Keys.Latitude)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let nameObject = aDecoder.decodeObject(forKey: Keys.Name) as? String {
            _name = nameObject
            _longitude = aDecoder.decodeObject(forKey: Keys.Longitude) as? Double
            _latitude = aDecoder.decodeObject(forKey: Keys.Latitude) as? Double
        
        }
        
    }
    
    
    
    
    
}
