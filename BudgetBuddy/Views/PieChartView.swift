//
//  PieChartView.swift
//  BudgetBuddy
//
//  Created by Tino on 27/9/21.
//

import SwiftUI

struct Sector: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    private let offset = Angle(degrees: 90.0)
    
    init(startAngle: Angle, endAngle: Angle, clockwise: Bool = false) {
        self.startAngle = startAngle - offset
        self.endAngle = endAngle - offset
        self.clockwise = clockwise
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.maxX, rect.maxY) * 0.9 / 2
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        path.closeSubpath()
        
        return path
    }
}

struct SectorView: View {
    let startAngle: Angle
    let endAngle: Angle
    let colour: Color
    let label: String?
    let labelOffset: Double
    let labelSize = 20.0
    
    private let offset = Angle(degrees: 90)
    
    private var labelPoint: CGPoint {
        let midAngleRad = startAngle.radians + (endAngle.radians - startAngle.radians) / 2.0 - offset.radians
                return CGPoint(x: labelOffset * cos(midAngleRad),
                               y: labelOffset * sin(midAngleRad))
    }
    
    @State private var isSelected = false
    
    var body: some View {
        Sector(startAngle: startAngle, endAngle: endAngle)
            .fill(colour)
            .scaleEffect(isSelected ? 1.1 : 1)
            .shadow(radius: isSelected ? 20.0 : 0.0)
            .overlay {
                labelOverlay
            }
            .onTapGesture {
                withAnimation {
                    isSelected.toggle()
                }
            }
    }
    
    @ViewBuilder
    private var labelOverlay: some View {
        if label != nil && isSelected {
            Text(label!)
                .font(.system(size: labelSize))
                .bold()
                .padding(3)
                .foregroundColor(.white)
                .background(.black.opacity(0.3))
                .cornerRadius(10)
                .offset(x: labelPoint.x, y: labelPoint.y)
                .scaleEffect(isSelected ? 1.2 : 1)
        }
    }
}

struct PieChartView: View {
    // inputs
    let data = [10,20, 40.0, 2].sorted(by: >)
    let colours: [Color] = [.red, .green, .blue, .yellow, .pink]
    var linearGradient: LinearGradient {
        LinearGradient (
            colors: [.red, .green, .yellow],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            let total = data.reduce(0, +)
            let angles = data.map { $0 * 360.0 / total }
            let percentages = data.map { $0 / total * 100 }
            var sum = 0.0
            let runningAngles = angles.map { angle -> Double in
                sum += angle
                return sum
            }
            
            ZStack {
                ForEach(0..<runningAngles.count) { i in
                    let startAngle = i == 0 ? 0.0 : runningAngles[i - 1] // the staring angle is the previous one
                    SectorView(
                        startAngle: Angle(degrees: startAngle),
                        endAngle: Angle(degrees: runningAngles[i]),
                        colour: colours[i],
                        label: "\(data[i]) (\(String(format: "%.1f%%", percentages[i])))",
                        labelOffset: 80
                    )
                        .zIndex(1)
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
    }
}
