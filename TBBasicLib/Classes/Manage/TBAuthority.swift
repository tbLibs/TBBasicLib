//
//  TBAuthority.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/5/8.
//

import Foundation
import Contacts
import CoreLocation
import Photos
import AdSupport
import AppTrackingTransparency
import Speech

public class Authority {
    
    // 检查idfv权限状态
    public static func checkTrackingAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // 用户已授权
                    print("用户已授权")
                    completion(true)
                case .denied:
                    // 用户拒绝授权
                    print("用户已拒绝授权")
                    completion(false)
                case .notDetermined:
                    // 用户尚未做出选择，提供提示
                    print("用户尚未做出选择")
                    completion(false)
                case .restricted:
                    // 应用无法请求授权
                    print("应用无法请求授权")
                    completion(false)
                @unknown default:
                    print("未知状态")
                    completion(false)
                }
            }
        } else {
            completion(true)
        }
    }
    
    
    // 请求访问通讯录的权限
    public static func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                completion(granted)
            }
        case .restricted, .denied:
            completion(false)
        case .authorized:
            completion(true)
        case .limited:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    
    // 请求访问定位权限
    public static func requestLocationAccess() -> Bool? {
        let locationManager = CLLocationManager()
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // 请求权限后，会触发 CLLocationManagerDelegate 中的相应方法，处理权限结果
            locationManager.requestWhenInUseAuthorization()
            return nil
        case .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        @unknown default:
            return false
        }
    }
    
    
    /// 请求相机权限
    /// - Parameter successCallBack: 回调
    public static func requestCameraAccess(successCallBack: @escaping ((_ result: Bool) -> Void)) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if (authStatus == .authorized) {
            // 已授权，可以打开相机
            DispatchQueue.main.async {
                successCallBack(true)
            }
        } else if (authStatus == .denied) {
            // 没有权限
            DispatchQueue.main.async {
                successCallBack(false)
            }
        } else if (authStatus == .restricted) {
            //相机权限受限
            DispatchQueue.main.async {
                successCallBack(false)
            }
        } else if (authStatus == .notDetermined) {
            //首次 使用
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    DispatchQueue.main.async {
                        successCallBack(true)
                    }
                } else {
                    //用户首次拒接
                    DispatchQueue.main.async {
                        successCallBack(false)
                    }
                }
            })
        }
    }
    
    /// 请求语音识别权限
    /// - Parameter completion: completion
    public static func requestSpeechAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }
    
    /// 请求麦克风权限
    /// - Parameter completion: completion
    public static func requestMicAuthorization(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { auth in
            DispatchQueue.main.async {
                completion(auth)
            }
        }
    }
    
    
    
}


