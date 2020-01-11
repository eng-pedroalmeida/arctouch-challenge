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
    
    var time: Double
    let timeUpdated: (_ time: Double) -> Void
    let timeFinished: () -> Void
    
    init(timeInSeconds: Double, timeUpdated: @escaping (_ time: Double) -> Void, timeFinished: @escaping (() -> Void)) {
        self.time = timeInSeconds
        self.timeUpdated = timeUpdated
        self.timeFinished = timeFinished
    }
    
    deinit {
        print("Stopwatch successfully deinited")
        deinitTimer()
    }
    
    func isFinished() -> Bool {
        if let from = self.from, Date().timeIntervalSince1970 - from.timeIntervalSince1970 > time {
            return true
        }
        
        return false
    }
    
    func start() {
        let action: (Timer) -> Void = { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.time -= strongSelf.kInterval
            strongSelf.timeUpdated(strongSelf.time)
            if strongSelf.time <= 0.0 {
                strongSelf.timeFinished()
                strongSelf.deinitTimer()
            }
        }
        
        from = Date()
        timer = Timer.scheduledTimer(withTimeInterval: kInterval,
                                     repeats: true, block: action)
    }
    
    func stop() {
        deinitTimer()
    }
    
    private func deinitTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
