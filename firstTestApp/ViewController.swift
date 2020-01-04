//
//  ViewController.swift
//  firstTestApp
//
//  Created by Николай Костин on 05.01.2020.
//  Copyright © 2020 Николай Костин. All rights reserved.
//

import UIKit
import Alamofire

struct RecipeModel{
    var uuid: String
    var name: String
//    var images: [String]?
    var description: String?
    var instructions: String
    var difficulty: Int
}

struct RecipeStore{
    var recipes: [RecipeModel]
}
class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    
     var recipes = [RecipeModel]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = recipes[indexPath.row].name
        return cell
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        request("https://test.kode-t.ru/recipes").responseJSON { response in
            switch response.result{
            case .success(let value):
                guard let recipesTemp = value as? [String:Any] else{ print("err"); return}
                guard let list = recipesTemp["recipes"] as? [[String:Any]] else {print("err2"); return }
                for recipe in list {
                    let name = recipe["name"] as? String ?? "no"
                    let uuid = recipe["uuid"] as? String ?? "no"
                    let description = recipe["description"] as? String ?? "no"
                    let instructions = recipe["instructions"] as? String ?? "no"
                    let difficulty = recipe["difficulty"] as? Int ?? 0
                    self.recipes.append(RecipeModel(uuid: uuid, name: name, description: description, instructions: instructions, difficulty: difficulty))
                   
                }
                print(self.recipes.count)
                self.table.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        print("viewDidLoad ended")
    }


}

