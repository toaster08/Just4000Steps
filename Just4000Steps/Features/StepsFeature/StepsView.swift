//
//  ContentView.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/12.
//

import SwiftUI
import ComposableArchitecture
import UserNotifications

struct StepsView: View {

    let store: StoreOf<StepFeature>
    let targetSteps = 500
    let userNotificationUtil = UserNotificationUtil.shared
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.loading {
                    ProgressView("Loading...")
                } else if let error = viewStore.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                } else {
                    Spacer()
                    PieChart(
                        value: CGFloat(viewStore.steps.first?.count ?? 0),
                        maxValue: CGFloat(targetSteps),
                        barWidth: 20,
                        barPadding: 0,
                        chartBackgroundColor: Color.white,
                        chartTintColor: Color.green.opacity(0.5),
                        animationDuration: 0.8
                    )
                    .frame(width: 200, height: 200)
                    .onAppear {
                        print("🚀\(viewStore.steps.first?.count)")
                    }
                }
                Spacer()
                
                VStack(spacing: 20) {
                    Button("Load Steps") {
                        viewStore.send(.requestAuthorization)
                    }
                    
                    Button("Request Notification Permission") {
                        requestNotificationPermission()
                    }
                    
                    Button("Schedule Notification") {
                        scheduleNotification()
                    }
                }
            }
            .onAppear {
                viewStore.send(.requestAuthorization)
            }
        }
    }
    
    func requestNotificationPermission() {
        userNotificationUtil.requestPermission { isGranted in
            if isGranted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func scheduleNotification() {
        userNotificationUtil.scheduleNotification(
            content:
                    .init(
                        identifier:  UUID().uuidString,
                        title: "昨日の歩数についてお伝えします",
                        body:  "🚶昨日は4000歩を歩いたようです",
                        timeInterval: 5
                    )
        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(
            store: Store(initialState: StepFeature.State(), reducer: {
                let healthStore = HealthStore()
                StepFeature(environment: .init(healthService: healthStore))
            })
        )
    }
}
