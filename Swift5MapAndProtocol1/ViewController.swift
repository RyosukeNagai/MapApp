//
//  ViewController.swift
//  Swift5MapAndProtocol1
//
//  Created by 長井崚介 on 2021/01/28.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
    
    //住所の中に入れる変数
    var addressString = ""
    
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locManager:CLLocationManager!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingButton.backgroundColor = .white
        settingButton.layer.cornerRadius = 20.0
        
        
    }
    

    @IBAction func longPressTap(_ sender: UILongPressGestureRecognizer) {
        
        //タップを開始した時
        if sender.state == .began{
            
            
        }else if sender.state == .ended{
            
            //タップを終了
            //タップした位置を指定して、MKMapView上の緯度、経度を取得する
            //緯度経度から住所に変換する
            
            let tapPoint = sender.location(in: view)
            //タップした位置(CGPoint)を指定してMKMapView上の緯度経度を取得する
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let lat = center.latitude
            let log = center.longitude
            convert(lat: lat, log: log)
            
        }
    }
    
    //緯度 lat、経度log
    func convert(lat: CLLocationDegrees,log:CLLocationDegrees){
          
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: log)
        
        //クロージャー
        geocoder.reverseGeocodeLocation(location) {
             (placeMark,error) in
            
            if let placeMark = placeMark{
                
                if let pm = placeMark.first{
                    
                    if pm.administrativeArea != nil || pm.locality != nil {
                        
                        self.addressString = pm.name! + pm.administrativeArea! + pm.locality!
                    }else{
                        
                        self.addressString = pm.name!
                        
                    }
                    
                    self.addressLabel.text = self.addressString
                    
                }
            }
        }
    }
    
    
    @IBAction func goToSearchVC(_ sender: Any) {
        
        //画面遷移
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next"{
            let nextVC = segue.description as! NextViewController
            //
        }
    }
    
    
}

