//
//  Just4000StepsApp.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/12.
//

import SwiftUI
import ComposableArchitecture

@main
struct Just4000StepsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
                StepsView(
                    store: Store(
                        initialState: StepFeature.State(),
                        reducer: {
                            let healthStore = HealthStore()
                            StepFeature(environment: .init(healthService: healthStore))
                        }
                    )
                )
        }
    }
}
