//
//  PieChartView.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/15.
//

import SwiftUI

struct PieChart: View {
    var value: CGFloat
    var maxValue: CGFloat
    var barWidth: CGFloat
    var barPadding: CGFloat
    var chartBackgroundColor: Color
    var chartTintColor: Color
    var animationDuration: Double
    
    // Computed properties
    private var percentage: CGFloat {
        if value <= 0 || maxValue <= 0 {
            return 0.0
        } else if value >= maxValue {
            return 1.0
        } else {
            return value / maxValue
        }
    }
    
    private var endAngle: Angle {
        Angle(radians: (2 * Double.pi * Double(percentage)) - (Double.pi / 2))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .stroke(chartBackgroundColor, lineWidth: barWidth + 5)
                .shadow(radius: 2)
            Circle()
                     .trim(from: 0.0, to: percentage)
                     .stroke(chartTintColor,
                             style: StrokeStyle(lineWidth: barWidth - (barPadding * 2), lineCap: .round))
                     .rotationEffect(.radians(-Double.pi / 2))
                     .animation(.easeInOut(duration: animationDuration))
            Text("\(String(format: "%.f", value)) 歩")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
}

struct RoundedEndsCircle: Shape {
    var percentage: CGFloat
    private var capsuleRadius: CGFloat = 5

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.5
        
        // 基本の円を描画
        path.addArc(center: center, radius: radius, startAngle: .degrees(-90), endAngle: .degrees(Double(percentage * 360) - 90), clockwise: false)
        
        // 先端を丸くするためのカプセルの部分を描画
        let endAngle = Angle.degrees(Double(percentage * 360) - 90)
        let x = center.x + radius * cos(CGFloat(endAngle.radians))
        let y = center.y + radius * sin(CGFloat(endAngle.radians))
        path.addArc(center: CGPoint(x: x, y: y), radius: capsuleRadius, startAngle: endAngle, endAngle: endAngle + .degrees(180), clockwise: false)

        return path
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(
            value: 50,
            maxValue: 100,
            barWidth: 20,
            barPadding: 0,
            chartBackgroundColor: Color.white,
            chartTintColor: Color.green.opacity(0.5),
            animationDuration: 0.8
        )
        .frame(width: 200, height: 200)
    }
}
