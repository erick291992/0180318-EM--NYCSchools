//
//  SchoolViewController.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import UIKit


class SchoolViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    // MARK:- Variables
    var school:School!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        // Setup Navigation Controller
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        // Loading scores data
        if let schoolScores = school.schoolsScores {
            self.mathLabel.text = schoolScores.sat_math_avg_score
            self.readingLabel.text = schoolScores.sat_critical_reading_avg_score
            self.writingLabel.text = schoolScores.sat_writing_avg_score
            requestPhoto(for: school.address)
        } else {
            requestSchores()
            requestPhoto(for: school.address)
        }
        
        // Setting name of School
        nameLabel.text = school.school_name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @IBAction func getDirections(_ sender: UIButton) {
        UrlAppLauncher.launchMapUsingAddress(address: school.address)
    }
    
    // MARK:- Methods
    // Api call to request school test scores
    func requestSchores(){
        Service.shared.getSchoolScores(dbn: school.dbn) { (schoolScores, error) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    Alert.showBasic(title: "Error", message: "error getting school scores", vc: self!)
                }
                return
            } else {
                if let schoolScores = schoolScores {
                    DispatchQueue.main.async { [weak self] in
                        self?.school.schoolsScores = schoolScores
                        self?.mathLabel.text = self?.school.schoolsScores?.sat_math_avg_score
                        self?.readingLabel.text = self?.school.schoolsScores?.sat_critical_reading_avg_score
                        self?.writingLabel.text = self?.school.schoolsScores?.sat_writing_avg_score
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        Alert.showBasic(title: "Not Found", message: "no scores found", vc: self!)
                    }
                }
            }

        }
    }
    
    // Google Api call to request image for given location
    func requestPhoto(for address: String){
        imageActivityIndicator.startAnimating()
        Service.shared.getFirstPhotoForPlace(address: address) { (image, error) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    Alert.showBasic(title: "Error", message: "error getting image", vc: self!)
                    self?.imageActivityIndicator.stopAnimating()
                }
                return
            } else {
                if let image = image {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                        self?.imageActivityIndicator.stopAnimating()
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        Alert.showBasic(title: "Not Found", message: "no image found", vc: self!)
                        self?.imageActivityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
}
