//
//  ViewController.swift
//  ObservableSample
//
//  Created by devtak on 2017. 6. 12..
//  Copyright © 2017년 devtak. All rights reserved.
//

import UIKit

class ChildView: UIView, AppDelegateEvent {
    override init(frame: CGRect) {
        super.init(frame: frame)
        AppDelegate.instance.addObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AppDelegate.instance.removObserver(self)
    }
    
    func appDelegateEnterBackground() {
        print("ChildView::appDelegateEnterBackground")
    }
    
}


class ViewController: UIViewController {
    
    fileprivate var childView: ChildView!
    
    deinit {
        AppDelegate.instance.removObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AppDelegate.instance.addObserver(self)
        self.childView = ChildView()
        self.view.addSubview(self.childView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension ViewController: AppDelegateEvent {
    
    func appDelegateEnterBackground() {
        print("ViewController::appDelegateEnterBackground")
    }
    
    func appDelegateEnterForground() {
        print("ViewController::appDelegateEnterForground")
    }
}
