//
//  ViewController.swift
//  Embeded_Software
//
//  Created by 이태윤 on 2023/08/10.
//

import UIKit
import MessageUI
import UserNotifications

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var label_1: UILabel!
    
    @IBOutlet var label_2: UILabel!
    @IBOutlet var label_3: UILabel!
    
    @IBOutlet var label_4: UILabel!
    
    @IBOutlet var label_5: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { (didAllow, error) in
                    
                })
                UNUserNotificationCenter.current().delegate = self
        
        for index in 1...5{
            //Setting content of the notification
            let content = UNMutableNotificationContent()
            content.title = "[긴급 알림] 마약이 감지되었습니다."
            content.subtitle = "BLACK WRIST 앱을 열어 즉시 Content를 확인하십시오."
            content.body = "30초 안에 응답을 하지 않는 경우, 자동으로 사법 기관으로 문자가 전송됩니다."
            content.summaryArgument = "BW Worldwide"
            content.summaryArgumentCount = 40
            
            //Setting time for notification trigger
            //블로그 예제에서는 TimeIntervalNotificationTrigger을 사용했지만, UNCalendarNotificationTrigger사용법도 같이 올려놓을게요!
            //2. Use TimeIntervalNotificationTrigger
            let TimeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            //Adding Request
            // MARK: - identifier가 다 달라야만 Notification Grouping이 됩니닷..!!
            let request = UNNotificationRequest(identifier: "\(index)timerdone", content: content, trigger: TimeIntervalTrigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
                    
        label_1.text = "Black Wrist을(를) 통해,"
        label_2.text = "LSD 마약이 감지되었습니다."
        //label_3.text = "자동으로 사법 기관에 연락이 진행되며,"
        //label_4.text = "이를 무시하고 싶으신 경우, 30초 안에 Bar를 밀어주세요."
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(ViewController.send_auto_message), userInfo: nil, repeats: false)
    }

    
    
    
    @IBAction func no_slider(_ sender: UISlider) {
        let value = sender.value
        if value == 1 {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
    
    @objc func send_auto_message(){
        let phone_number = "911"
        let message = "BLACK WRIST를 통해 마약이 감지되었으나, 사용자가 반응을 하지 않습니다. 예상되는 마약 종류는 LSD이며, 현재 사용자의 위치는 서울특별시 강남구 테헤란로 114길 11입니다. 긴급히 출동을 요청드립니다."
        sendTextMessage(to: phone_number, message: message)
    }
    
    func sendTextMessage(to phoneNumber: String, message: String) {
            if MFMessageComposeViewController.canSendText() {
                let messageController = MFMessageComposeViewController()
                messageController.recipients = [phoneNumber]
                messageController.body = message
                messageController.messageComposeDelegate = self
                present(messageController, animated: true, completion: nil)
                
            } else {
                print("문자 메시지를 보낼 수 없습니다.")
            }
        }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
            case.cancelled:
                label_5.text = "메시지 전송이 취소되었습니다."
            case .sent:
                label_5.text = "메시지가 전송되었습니다."
            case .failed:
                label_5.text = "메시지 전송을 실패하였습니다."
            @unknown default:
                break
            }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController : UNUserNotificationCenterDelegate {
    //To display notifications when app is running  inforeground
    
    //앱이 foreground에 있을 때. 즉 앱안에 있어도 push알림을 받게 해줍니다.
    //viewDidLoad()에 UNUserNotificationCenter.current().delegate = self를 추가해주는 것을 잊지마세요.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
        
    }
}

