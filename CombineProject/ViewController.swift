//
//  ViewController.swift
//  CombineProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/03/20.
//  Copyright © 2020 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import Combine
import Foundation

protocol Publisher {
    associatedtype Output
    associatedtype Failure : Error
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}

public protocol Subscriber : CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure : Error
    
    func receive(subscription: Subscription)
    func receive(_ input: Self.Input) -> Subscribers.Demand
    func receive(completion: Subscribers.Completion<Self.Failure>)
}

protocol Subject : AnyObject, Publisher {
    func send(_ value: Self.Output)
    func send(completion: Subscribers.Completion<Self.Failure>)
    func send(subscription: Subscription)
}

class ViewController: UIViewController {
    
    let textLbl = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textLbl)
        sink()
        publisher()
        currentValueSubject()
        passthroughSubject()
        
        // Do any additional setup after loading the view.
    }
    
    func sink(){
        let name = "Gui"
        let publisher = Just(name)
        
        publisher.sink(receiveCompletion: { (_) in
            print("finished")
        }) { (value) in
            print(value)
        }
        
    }
    
    func publisher(){
        let helloPublisher = "Hello Combine".publisher
        let fibonacciPublisher = [0,1,1,2,3,5].publisher
        
        // Without Error
        helloPublisher.sink { (value) in
            print(value)
        }
        
        // Can have error
        fibonacciPublisher.sink(receiveCompletion: { (completion) in
            switch completion{
            case .finished:
                print("finished")
            case .failure(let never):
                print("error")
            }
        }) { (value) in
            print(value)
        }
    }
    
    func currentValueSubject(){
        let currentValueSubject = CurrentValueSubject<String,Never>("Initial")
        
        currentValueSubject.send("Hello ")
        currentValueSubject.send("World!")
        
        currentValueSubject.sink(receiveCompletion: { (completion) in
            switch (completion){
            case .finished:
                print("finished")
            case .failure(let never):
                print("error")
            }
        }) { (value) in
            print(value)
        }
        
        currentValueSubject.send("Print this")
    }
    
    func passthroughSubject(){
         let passthroughSubject = PassthroughSubject<String,Error>()
        
          passthroughSubject.sink(receiveCompletion: { (completion) in
            switch (completion){
            case .finished:
                print("finished")
            case .failure(let never):
                print("error")
            }
        }) { (value) in
            print(value)
        }
        
        passthroughSubject.send("Print that plz")
    }
    
}

