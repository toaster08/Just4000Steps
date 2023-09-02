//
//  HealthStore.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/12.
//

import Foundation
import HealthKit
import ComposableArchitecture

protocol HealthServiceProtocol {
    func fetchSteps() async -> [Step]
    func requestAuthorization() async -> Bool
}

class HealthStore: HealthServiceProtocol {
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func fetchSteps() async -> [Step] {
        return await calculateSteps()
     }
    
    private func calculateSteps() async -> [Step] {
        let stepType = HKWorkoutType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let anchorDate = Date.mondayAt12AM()
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: daily
        )
        
        return await withCheckedContinuation { continuation in
                query.initialResultsHandler = { query, statisticsCollection, error in
                    var stepsArray: [Step] = []
                    if let statisticsCollection = statisticsCollection {
                        statisticsCollection
                            .enumerateStatistics(
                                from: startOfDay,
                                to: now) { statistics, stop in
                                    let count = statistics.sumQuantity()?.doubleValue(for: .count())
                                    let step = Step(count: Int(count ?? 0), date: statistics.startDate)
                                    stepsArray.append(step)
                                }
                    }
                    continuation.resume(returning: stepsArray)
                }
                
                if let healthStore = self.healthStore {
                    healthStore.execute(query)
                }
            }
    }
        
    func requestAuthorization() async -> Bool {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        guard let healthStore else { return false}

        return await withCheckedContinuation { continuation in
               healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
                   continuation.resume(returning: success)
               }
           }
    }
}
