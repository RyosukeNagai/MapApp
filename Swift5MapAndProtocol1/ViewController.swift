//
//  ViewController.swift
//  Swift5MapAndProtocol1
//
//  Created by 長井崚介 on 2021/01/28.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UIGestureRecognizerDelegate,SearchLocationDelegate {
    
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
        
    /* オプショナルバインディング
         if 変数 != nil{
         
         }
         if let 変数 = 変数１{
         print(変数)
         }
         */
        
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
            
            let nextVC = segue.destination as! NextViewController
            nextVC.delegate = self
        }
    }
    
    //任されたデリゲートメソッド
    func searchLocation(idoValue: String, keidoValue: String) {
        
        if idoValue.isEmpty != true && keidoValue.isEmpty != true{
            
            let idoString = idoValue
            let keidoString = keidoValue
            
            //緯度、経度からコーディネート
            let coordinate = CLLocationCoordinate2DMake(Double(idoString)!, Double(keidoString)!)
            //表示する範囲を表示する
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            //領域を指定
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            //領域をmapViewに設定する
            mapView.setRegion(region, animated: true)
            
            //緯度経度から住所へ変換
            convert(lat: Double(idoString)!, log: Double(keidoString)!)
            
            //ラベルに表示
            addressLabel.text = addressString
            
        }else{
            addressLabel.text = "表示できません"
            
        }
        
    }
    
}

