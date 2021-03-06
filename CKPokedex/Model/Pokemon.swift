//
//  Pokemon.swift
//  CKPokedex
//
//  Created by Christopher Brandon Karani on 28/11/2017.
//  Copyright © 2017 Christopher Brandon Karani. All rights reserved.
//

import Foundation
import TRON
import RealmSwift
import Realm


class Pokemon: Object {
    let database : Realm = Database().realmDatabase
    @objc dynamic var name: String?
    @objc dynamic var urlString : String?
    
    var infomation : PokemonData? {
        didSet {
            let homeController = HomeController(networkService: PokemonNetwork())
            homeController.reloadAdapter()
        }
    }
    let networkService : NetworkService = PokemonNetwork()
    
    convenience init(name: String, urlString: String) {
        self.init()
        self.name = name
        self.urlString = urlString
        networkService.fetchPokemonData(with: urlString, completion: { [weak self] (data) in
            self?.infomation = data

            try! self?.database.write { [weak self] in
                self?.database.add(self!)
                self?.database.add(self!.infomation!)
            }
        })
    }
}

