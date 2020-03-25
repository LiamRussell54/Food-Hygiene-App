 //
//  SearchViewController.swift
//  15071057_Assignment
//
//  Created by Liam Russell on 05/03/2018.
//  Copyright © 2018 Liam Russell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //all of the outlets needed for the search function
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectSegment: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    var restaurants = [Restaurant]()
    
    //the ammount of rows is based on the size of the restaraunt array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    /*creates a cell for each restaraunt, using business name
     and rating value to fill the cell content*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! RestarauntTableViewCell
        cell.restarauntLabel?.text = restaurants[indexPath.row].BusinessName
        cell.ratingImage?.image = UIImage.init(imageLiteralResourceName:"fhrs_\(restaurants[indexPath.row].RatingValue)_en-gb.jpg")
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set table views and search bar data source and delegate
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when the search button on the keyboard is clicked call the load restaurants function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //encode the search value to remove errors
        let search = (searchBar.text!).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //load restaurants is called, passing the search text from the search bar
        loadRestaraunts(searchValue: search!)
    }
    
    //loads restaurants using search value passed
    func loadRestaraunts(searchValue: String) {
        
        /*checks to see if the user would like to search by name or postcode
         0 is name and 1 is postcode */
        if selectSegment.selectedSegmentIndex == 0
        {
            //if the user is searching by name, use the url to search by business name passing the search value into the url
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(searchValue)")
            
            URLSession.shared.dataTask(with: url!) {(data, respnse, error) in
                
                guard let data = data else { print("error with data"); return}
                do{
                    self.restaurants = try JSONDecoder().decode([Restaurant].self, from: data);
                    //interupt main thread, update table with data recieved
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData();
                    }
                } catch let err {
                    print("Error:", err)
                }
                
                }.resume()//start network call
        } 
        else {
        //else the user must be searching by postcode, use the url to search by postcode passing the search value into the url
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(searchValue)")
        
        URLSession.shared.dataTask(with: url!) {(data, respnse, error) in
            
            guard let data = data else { print("error with data"); return}
            do{
                self.restaurants = try JSONDecoder().decode([Restaurant].self, from: data);
                //interupt main thread, update table with data recieved
                DispatchQueue.main.async {
                    self.searchTableView.reloadData();
                }
            } catch let err {
                print("Error:", err)
            }
            
            }.resume()//start network call
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*when a table view cell is clicked set the segue destination as
         the details view controller and pass the values of the restaurant clicked*/
        if let cell = sender as? UITableViewCell{
            let i = searchTableView.indexPath(for: cell)!.row
            if segue.identifier == "details"{
                let dvc = segue.destination as! DetailsViewController
                dvc.theRestaurant = self.restaurants[i]
            }
        }
    }

}
