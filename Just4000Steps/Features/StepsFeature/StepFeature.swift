//
//  StepFeature.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/14.
//

import Foundation
import ComposableArchitecture

enum AppError: Error, Equatable {
    case someErrorCondition
    case anotherErrorCondition
}

struct StepFeature: Reducer {
    struct State: Equatable {
        var steps: [Step] = []
        var loading: Bool = false
        var error: AppError?
    }

    enum Action: Equatable {
        case requestAuthorization
        case authorizationResult(Bool)
        case setSteps([Step])
        case setLoading(Bool)
        case setError(AppError?)
    }
    struct StepsEnvironment {
        var healthService: HealthServiceProtocol
    }
    
    let environment: StepsEnvironment

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .requestAuthorization:
                return .run { send in
                        let success = await environment.healthService.requestAuthorization()
                        await send(.authorizationResult(success))
                }
        case .authorizationResult(let success):
            if success {
                state.loading = true
                return .run { send in
                    let steps = await environment.healthService.fetchSteps()
                    await send(.setSteps(steps))
                }
            } else {
                state.error = .someErrorCondition
                return .none
            }
        case .setSteps(let steps):
            state.steps = steps
            print("🚀:\(steps)")
            print(steps)
            state.loading = false
            return .none
        case .setLoading(let loading):
            state.loading = loading
            return .none
        case .setError(let error):
            state.error = error
            state.loading = false
            return .none
        }
    }
}
