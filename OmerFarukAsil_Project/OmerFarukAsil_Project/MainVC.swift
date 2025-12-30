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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainAdsImd.image = UIImage(named: "HomeBanner")
        limitedAdsImg.image = UIImage(named: "BigSale")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
