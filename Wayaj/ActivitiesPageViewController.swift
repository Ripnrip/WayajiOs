//
//  ActivitiesPageViewController.swift
//  Wayaj
//
//  Created by Zenun Vucetovic on 10/12/17.
//  Copyright © 2017 GRC. All rights reserved.
//

import UIKit
import Magnetic

class ActivitiesPageViewController: UIPageViewController, MagneticDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var magnetic: Magnetic!
    var magnetic2: Magnetic!
    var magnetic3: Magnetic!
    var magnetic4: Magnetic!
    
    var save1: UIButton!
    var save2: UIButton!
    var save3: UIButton!
    var save4: UIButton!
    
    var shouldNotShowQuestionaire:Bool!
    
    
    
    var activities = ["Snorkeling","Scuba ","Kayak","Ski","Snowboard","Freestyle ski ","Ice skating","Climbing","Hiking","Sailing","Kitesurf","Windsurf","Surf","Extreme sports","Jet ski","Waterski","Fishing","Ziplines","Spa","Yoga ","Beach volley","Bike","Horseback Riding"];
    
    //add cross country ski after fixing layouts
    var attractions = ["Wildlife","Local crafts ","Nightlife ","Art ","History ","Religion","Temples ","Breweries ","Vineyards ","Food specialties ","Shopping ","Hot springs","Scenery"];
    var naturalSetting = ["Urban","Country","Beach","Mountain","River","Lake","Jungle","Rain Forest","Desert"];
    var hotel = ["Pool","Spa","Kid-friendly","Pet-friendly","Adults only","Feng-shui designed","Free wifi","Farm"];
    
    var activitiesNodes = [String]()
    var attractionsNodes = [String]()
    var naturalSettingNodes = [String]()
    var hotelNodes = [String]()
    
    
    
    
    var vCs = [UIViewController(),UIViewController(),UIViewController(),UIViewController()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        
        let saveButton   = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = saveButton
        
        let magneticView = MagneticView(frame: self.view.bounds)
        magneticView.backgroundColor = UIColor(hex: "F0F8FF")
        magnetic = magneticView.magnetic
        let magneticView2 = MagneticView(frame: self.view.bounds)
        magneticView2.backgroundColor  = UIColor(hex: "F0F8FF")
        magnetic2 = magneticView2.magnetic
        let magneticView3 = MagneticView(frame: self.view.bounds)
        magneticView3.backgroundColor  = UIColor(hex: "F0F8FF")
        magnetic3 = magneticView3.magnetic
        let magneticView4 = MagneticView(frame: self.view.bounds)
        magneticView4.backgroundColor  = UIColor(hex: "F0F8FF")
        magnetic4 = magneticView4.magnetic
        
        
        magnetic.magneticDelegate = self
        magnetic2.magneticDelegate = self
        magnetic3.magneticDelegate = self
        magnetic4.magneticDelegate = self
        
        
        UIColor(hex: "F5B700")
        UIColor(hex: "DC0073")
        UIColor(hex: "4EA3FF")
        UIColor(hex: "138A36")
        
        for item in activities {
            let node = Node(text: item, image: UIImage(named: "earth"), color: UIColor(hex: "F5B700"), radius: 39)
            magnetic.addChild(node)
        }
        
        for item in attractions {
            let node = Node(text: item, image: UIImage(named: "earth"), color: UIColor(hex: "DC0073"), radius: 40)
            magnetic2.addChild(node)
        }
        
        for item in naturalSetting {
            let node = Node(text: item, image: UIImage(named: "earth"), color: UIColor(hex: "4EA3FF"), radius: 50)
            magnetic3.addChild(node)
        }
        
        for item in hotel {
            let node = Node(text: item, image: UIImage(named: "earth"), color: UIColor(hex: "138A36"), radius: 50)
            magnetic4.addChild(node)
        }
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.text = "Activities - Page 1/4"
        label.textColor = UIColor(hex: "478147")
        label.backgroundColor = .clear
        label.font = UIFont(name: "Helvetica", size: 20)
        label.center = CGPoint(x: magneticView.bounds.width / 2, y: 90)
        label.textAlignment = .center
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label2.text = "Attractions - Page 2/4"
        label2.textColor = UIColor(hex: "478147")
        label2.font = UIFont(name: "Helvetica", size: 20)
        label2.center = CGPoint(x: magneticView2.bounds.width / 2, y: 90)
        label2.textAlignment = .center
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
        label3.text = "Natural Setting - Page 3/4"
        label3.textColor = UIColor(hex: "478147")
        label3.font = UIFont(name: "Helvetica", size: 20)
        label3.center = CGPoint(x: magneticView3.bounds.width / 2, y: 90)
        label3.textAlignment = .center
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label4.text = "Hotel - Page 4/4"
        label4.textColor = UIColor(hex: "478147")
        label4.font = UIFont(name: "Helvetica", size: 20)
        label4.center = CGPoint(x: magneticView4.bounds.width / 2, y: 90)
        label4.textAlignment = .center
        magneticView.addSubview(label)
        magneticView.bringSubview(toFront: label)
        magneticView2.addSubview(label2)
        magneticView2.bringSubview(toFront: label2)
        magneticView3.addSubview(label3)
        magneticView3.bringSubview(toFront: label3)
        magneticView4.addSubview(label4)
        magneticView4.bringSubview(toFront: label4)
        //self.view.bringSubviewToFront(label);
        
        save1 = UIButton(frame: CGRect(x: (magneticView.bounds.width / 2) - 77, y: magneticView.bounds.height - 100, width: 154, height: 34))
        save1.setTitle("SAVE", for: .normal)
        save1.backgroundColor = UIColor(hex: "4BBE4B")
        save1.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        save2 = UIButton(frame: CGRect(x: (magneticView.bounds.width / 2) - 77, y: magneticView.bounds.height - 100, width: 154, height: 34))
        save2.setTitle("SAVE", for: .normal)
        save2.backgroundColor = UIColor(hex: "4BBE4B")
        save2.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        save3 = UIButton(frame: CGRect(x: (magneticView.bounds.width / 2) - 77, y: magneticView.bounds.height - 100, width: 154, height: 34))
        save3.setTitle("SAVE", for: .normal)
        save3.backgroundColor = UIColor(hex: "4BBE4B")
        save3.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        save4 = UIButton(frame: CGRect(x: (magneticView.bounds.width / 2) - 77, y: magneticView.bounds.height - 100, width: 154, height: 34))
        save4.setTitle("SAVE", for: .normal)
        save4.backgroundColor = UIColor(hex: "4BBE4B")
        save4.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        save1.layer.cornerRadius = 5
        save2.layer.cornerRadius = 5
        save3.layer.cornerRadius = 5
        save4.layer.cornerRadius = 5
        
        
        magneticView.addSubview(save1)
        magneticView.bringSubview(toFront: save1)
        magneticView2.addSubview(save2)
        magneticView2.bringSubview(toFront: save2)
        magneticView3.addSubview(save3)
        magneticView3.bringSubview(toFront: save3)
        magneticView4.addSubview(save4)
        magneticView4.bringSubview(toFront: save4)
        
        
        shouldNotShowQuestionaire = (UserDefaults.standard.bool(forKey: "userViewedInitialTutorial2"))
        
        if shouldNotShowQuestionaire == false {
            
            save1.isHidden = false
            save2.isHidden = false
            save3.isHidden = false
            save4.isHidden = false
            
        } else {
            save1.isHidden = true
            save2.isHidden = true
            save3.isHidden = true
            save4.isHidden = true
        }
        
        
        
        vCs[0].view.addSubview(magneticView)
        vCs[3].view.addSubview(magneticView2)
        vCs[2].view.addSubview(magneticView3)
        vCs[1].view.addSubview(magneticView4)
        
        
        setViewControllers([vCs[0]], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vCs.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return vCs.last
        }
        
        guard vCs.count > previousIndex else {
            return nil
        }
        
        return vCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vCs.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = vCs.count
        
        guard orderedViewControllersCount != nextIndex else {
            return vCs.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return vCs[nextIndex]
    }
    
    
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        // handle node selection
        
        
        if magnetic == self.magnetic {
            
            activitiesNodes.append(node.text!)
            print(node.text!)
            
        } else if magnetic == magnetic2 {
            
            attractionsNodes.append(node.text!)
            print(node.text!)
            
        } else if magnetic == magnetic3 {
            naturalSettingNodes.append(node.text!)
            print(node.text!)
            
        } else if magnetic == magnetic4 {
            
            hotelNodes.append(node.text!)
            print(node.text!)
            
        } else {
            
            
            
        }
        
        
        
        
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        // handle node deselection
        
        if magnetic == self.magnetic {
            
            activitiesNodes = activitiesNodes.filter { $0 != node.text! }
            
            
        } else if magnetic == magnetic2 {
            
            attractionsNodes = attractionsNodes.filter { $0 != node.text! }
            
        } else if magnetic == magnetic3 {
            naturalSettingNodes = naturalSettingNodes.filter { $0 != node.text! }
            
        } else if magnetic == magnetic4 {
            
            hotelNodes = hotelNodes.filter { $0 != node.text! }
            
        } else {
            
            
            
        }
        
    }
    
    
    @objc func saveButtonTapped(){
        
        if activitiesNodes.count > 0 {
            UserDefaults.standard.setValue(activitiesNodes, forKey: "favoriteActivitiesDefault")
        }
        if attractionsNodes.count > 0 {
            UserDefaults.standard.setValue(attractionsNodes, forKey: "favoriteActivitiesAttractions")
        }
        if naturalSettingNodes.count > 0 {
            UserDefaults.standard.setValue(naturalSettingNodes, forKey: "favoriteActivitiesNaturalSetting")
        }
        if hotel.count > 0 {
            UserDefaults.standard.setValue(hotelNodes, forKey: "favoriteActivitiesHotel")
        }
        
        print(activitiesNodes)
        print(attractionsNodes)
        print(naturalSettingNodes)
        print(hotelNodes)
        
        let alert = UIAlertController(title: "Activities updated!", message: "Click \"Continue\" to continue", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { action in
            
            if self.shouldNotShowQuestionaire == false {
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                self.navigationController?.popViewController(animated: true)
                
            }
        })
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
