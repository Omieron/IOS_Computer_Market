//
//  MainVC.swift
//  OmerFarukAsil_Project
//
//  Created by Ömer Faruk Asil on 30.12.2025.
//

import UIKit
import Kingfisher

class MainVC: UIViewController {

    @IBOutlet weak var mainAdsImd: UIImageView!
    @IBOutlet weak var limitedAdsImg: UIImageView!
    
    @IBOutlet weak var christmasAds: UIImageView!
    @IBOutlet weak var mouseAds: UIImageView!
    
    @IBOutlet weak var gamingView: UIView!
    @IBOutlet weak var officeView: UIView!
    @IBOutlet weak var workstationView: UIView!
    
    let xmlCategoryData = DataSoruce()
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainAdsImd.image = UIImage(named: "HomeBanner")
        limitedAdsImg.image = UIImage(named: "BigSale")
        christmasAds.image = UIImage(named: "monitorAds")
        mouseAds.image = UIImage(named: "mouseAds")
        
        styleView(gamingView)
        styleView(officeView)
        styleView(workstationView)
        
        xmlCategoryData.populateFromXML {

            self.setupTapGestures()
        }
    }
    
    func setupTapGestures() {
        let gamingTap = UITapGestureRecognizer(target: self, action: #selector(gamingTapped))
        gamingView.isUserInteractionEnabled = true
        gamingView.addGestureRecognizer(gamingTap)
        
        let officeTap = UITapGestureRecognizer(target: self, action: #selector(officeTapped))
        officeView.isUserInteractionEnabled = true
        officeView.addGestureRecognizer(officeTap)
        
        let workstationTap = UITapGestureRecognizer(target: self, action: #selector(workstationTapped))
        workstationView.isUserInteractionEnabled = true
        workstationView.addGestureRecognizer(workstationTap)
    }
    
    @objc func gamingTapped() {
        if let gamingCategory = xmlCategoryData.rootCategories.first(where: { $0.id == 1 }) {
            selectedCategory = gamingCategory
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            performSegue(withIdentifier: "mainToProducts", sender: self)
        }
    }
    
    @objc func officeTapped() {
        if let officeCategory = xmlCategoryData.rootCategories.first(where: { $0.id == 2 }) {
            selectedCategory = officeCategory
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            performSegue(withIdentifier: "mainToProducts", sender: self)
        }
    }
    
    @objc func workstationTapped() {
        if let workstationCategory = xmlCategoryData.rootCategories.first(where: { $0.id == 3 }) {
            selectedCategory = workstationCategory
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            performSegue(withIdentifier: "mainToProducts", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToProducts",
           let productsVC = segue.destination as? ProductsVC,
           let category = selectedCategory {
            productsVC.selectedCategory = category
        }
    }
    
    func styleView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
    }
}
