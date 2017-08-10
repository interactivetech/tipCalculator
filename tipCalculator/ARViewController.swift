//
//  ARViewController.swift
//  tipCalculator
//
//  Created by Andrew Mendez on 8/7/17.
//  Copyright © 2017 Andrew Mendez. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    var midPoint: CGPoint!
    var cursor: SCNNode!
    
    @IBOutlet var moveLabel: UILabel!
    
    @IBOutlet var arSCNView: ARSCNView!
    
    var bill: String!
    var tip: [Double] = []
    var finalBill: String!
    @IBOutlet var tipSelector: UISegmentedControl!
    var textNode: SCNNode!
    var loaded:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
//        scnView = self.view as! ARSCNView
        midPoint = CGPoint(x: arSCNView.bounds.midX,y:arSCNView.bounds.midY)
        arSCNView.delegate = self
        let session = ARSession()
        arSCNView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        arSCNView.session = session
        
        arSCNView.antialiasingMode = .multisampling4X
        arSCNView.automaticallyUpdatesLighting = false
        setupScene()
        tipSelector.alpha = 0.0
        // initalize session
        loaded = false
        
    }
    
    
    
    func setupScene(){
        
        // create plane as cursor
        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIColor.orange
        plane.firstMaterial?.transparency = 0.5

        cursor = SCNNode(geometry: plane)
        
        cursor.rotation = SCNVector4Make(1, 0, 0, -.pi/2)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(cursor)
        arSCNView.scene = scene
        print("1) View Loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("2) View about to appear")
        let sessionConfig = ARWorldTrackingSessionConfiguration()
        sessionConfig.planeDetection = .horizontal
        //        sessionConfig.isLightEstimationEnabled = true
        arSCNView.session.run(sessionConfig)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("3) View appeared!")
        //here load the segment control
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        arSCNView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
         guard let screenCenter = self.midPoint else {return}
//        print(screenCenter)
        //run hitTest from center of iphone screen
         DispatchQueue.main.async {
            let results = self.arSCNView.hitTest(screenCenter, types: .featurePoint)
        //get featurePoint and transform
        let result = results.last
        
        //set point to transform
        if let transform = result?.worldTransform{
//            print(SCNVector3(transform.columns.3.x,transform.columns.3.y,transform.columns.3.z))
            self.cursor.position = SCNVector3(transform.columns.3.x,transform.columns.3.y,transform.columns.3.z)
        }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARAnchor {
            //trigger load of animation
            if (!self.loaded){
                
                
            DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.tipSelector.alpha = 1.0
                self.cursor.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
                self.moveLabel.alpha = 0.0
                self.textNode = self.createText(string: self.finalBill)
                self.textNode.geometry?.subdivisionLevel = 2
                self.textNode.scale = SCNVector3(0.0,0.0,0.0)
                self.textNode.position = self.cursor.position
                self.self.textNode.rotation = SCNVector4Make(1, 0, 0, -.pi/4)
                DispatchQueue.main.async {
                    self.arSCNView.scene.rootNode.addChildNode(self.textNode)
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1.5
                    self.textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
                    SCNTransaction.commit()
                }
                
                
            }}
                self.loaded = true

            }//end if
        }
    }
    
    @IBAction func calcBill(_ sender: Any) {
        
        displayBillTipAndFinalBill()
    }
    func displayBillTipAndFinalBill(){
        
        let tipAmount = tip[tipSelector.selectedSegmentIndex]
        let bill = parseBillValue(text: self.bill)
        let finalB = bill * tipAmount + bill
        let finalBillString = formatValue(number: finalB)
//        print(tipAmount, finalB, finalBillString)
        let pos = self.textNode.position
        self.textNode.removeFromParentNode()
        self.textNode = self.createText(string: finalBillString)
        self.textNode.geometry?.subdivisionLevel = 1
        self.textNode.scale = SCNVector3(0.0,0.0,0.0)
        self.textNode.position = pos
        self.textNode.rotation = SCNVector4Make(1, 0, 0, -.pi/4)
        DispatchQueue.main.async {
            self.arSCNView.scene.rootNode.addChildNode(self.textNode)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.75
            self.textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
            SCNTransaction.commit()
            
        }
        
    }
    
    func parseBillValue(text str:String?) -> Double{
        
        //get current locale
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.decimal// set to decimal so its parsable
        //get correct decimal based on current locale
        return formatter.number(from:str!)?.doubleValue ?? 0.00
        
        
    }
    
    func formatValue(number: Double) -> String{
        
        // get the current locale on the user's device
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.currency
        //format value to current locale
        let number = NSNumber(value: number)
        let text = formatter.string(from: number)!
        return text
        
    }
    
    func appearAnimation(node: SCNNode)  {
//        let transaction = SCNTransaction()
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        node.scale = SCNVector3Make(0.005, 0.005, 0.005)
        SCNTransaction.commit()
    }
    
    func createText(string: String) -> SCNNode{
        
        //create text geometry
        let geometry = SCNText(string: string, extrusionDepth: 2.0)
//        chamferRadius = 3.0;
        //color texture
        geometry.materials = [textFrontMaterial(),textFrontMaterial(),textSideMaterial(),textFrontMaterial(),textFrontMaterial()]
        //attach to node
        let node = SCNNode(geometry:geometry)
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        let center = SCNVector3Make((min.x+max.x)/2, (min.y+max.y)/2, (min.z+max.z)/2)
        
        node.pivot = SCNMatrix4MakeTranslation(center.x,0, 0)
        //return value
        return node
    }
    
    func textFrontMaterial() ->SCNMaterial {
        let material = SCNMaterial()
        //set diffuse contents
        material.diffuse.contents = UIColor.white
        //set reflective contebts
        material.reflective.contents = UIColor.white
        //set reflective intensity
        material.reflective.intensity = 0.5
        //return material
        
        return material;
    }
    
    func textSideMaterial() -> SCNMaterial{
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        material.reflective.contents = UIColor.white
        material.reflective.intensity = 0.5
        
        return material
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
