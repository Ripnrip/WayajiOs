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
    
    var activities = ["Snorkeling","Scuba ","Kayak","Ski","Snowboard","Cross country ski","Freestyle ski ","Ice skating","Climbing","Hiking","Sailing","Kitesurf","Windsurf","Surf","Extreme sports","Jet ski","Waterski","Fishing","Ziplines","Spa","Yoga ","Beach volley","Bike","Horseback Riding"];
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
        
        self.navigationItem.rightBarButtonItem = saveButton

        let magneticView = MagneticView(frame: self.view.bounds)
        magnetic = magneticView.magnetic
        let magneticView2 = MagneticView(frame: self.view.bounds)
        magnetic2 = magneticView2.magnetic
        let magneticView3 = MagneticView(frame: self.view.bounds)
        magnetic3 = magneticView3.magnetic
        let magneticView4 = MagneticView(frame: self.view.bounds)
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
            let node = Node(text: item, image: UIImage(named: "earth"), color: UIColor(hex: "F5B700"), radius: 36)
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
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.text = "Activities"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: "Helvetica", size: 20)
        label.center = CGPoint(x: magneticView.bounds.width / 2, y: 90)
        label.textAlignment = .center
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label2.text = "Attractions"
        label2.textColor = .black
        label2.font = UIFont(name: "Helvetica", size: 20)
        label2.center = CGPoint(x: magneticView2.bounds.width / 2, y: 90)
        label2.textAlignment = .center
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label3.text = "Natural Setting"
        label3.textColor = .black
        label3.font = UIFont(name: "Helvetica", size: 20)
        label3.center = CGPoint(x: magneticView3.bounds.width / 2, y: 90)
        label3.textAlignment = .center
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label4.text = "Hotel"
        label4.textColor = .black
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
        
        UserDefaults.standard.setValue(activitiesNodes, forKey: "favoriteActivitiesDefault")
        UserDefaults.standard.setValue(attractionsNodes, forKey: "favoriteActivitiesAttractions")
        UserDefaults.standard.setValue(naturalSettingNodes, forKey: "favoriteActivitiesNaturalSetting")
        UserDefaults.standard.setValue(hotelNodes, forKey: "favoriteActivitiesHotel")

        print(activitiesNodes)
        print(attractionsNodes)
        print(naturalSettingNodes)
        print(hotelNodes)
        
        self.navigationController?.popViewController(animated: true)
        
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
