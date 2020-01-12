//
//  CountDownTimer.swift
//  Quiz Challenge
//
//  Created by Pedro Almeida on 10/01/20.
//  Copyright © 2020 Pedro Almeida. All rights reserved.
//

import Foundation

class CountDownTimer {
    private let kInterval = 1.0
    private var timer: Timer?
    private(set) var from: Date?
    
    let totalTime: Double
    var time: Double
    let timeUpdatedAction: (_ time: Double) -> Void
    let timeFinishedAction: () -> Void
    
    init(time: Double, timeUpdatedAction: @escaping (_ time: Double) -> Void, timeFinishedAction: @escaping (() -> Void)) {
        self.totalTime = time
        self.time = time
        self.timeUpdatedAction = timeUpdatedAction
        self.timeFinishedAction = timeFinishedAction
    }
    
    deinit {
        deinitTimer()
    }
    
    func isFinished() -> Bool {
        if let from = self.from, Date().timeIntervalSince1970 - from.timeIntervalSince1970 > time {
            return true
        }
        
        return false
    }
    
    func update() {
        if let from = self.from, Date().timeIntervalSince1970 - from.timeIntervalSince1970 != time {
            print("passed seconds: \(Date().timeIntervalSince1970 - from.timeIntervalSince1970)")
            time = round(totalTime - (Date().timeIntervalSince1970 - from.timeIntervalSince1970))
            tick()
        }
    }

    func start() {
        let action: (Timer) -> Void = { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.time -= strongSelf.kInterval
            strongSelf.tick()
        }
        
        from = Date()
        timer = Timer.scheduledTimer(withTimeInterval: kInterval,
                                     repeats: true, block: action)
    }
    
    func stop() {
        deinitTimer()
    }
    
    private func tick() {
        timeUpdatedAction(time)
        if time <= 0.0 {
            timeFinishedAction()
            deinitTimer()
        }
    }
    
    private func deinitTimer() {
        timer?.invalidate()
        timer = nil
        time = totalTime
    }
    
}
