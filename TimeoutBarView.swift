import SwiftUI

struct TimeoutBarView: View {
    @State private var remainingTime: Double = 0
    @State private var totalTime: Double = 300
    @State private var timer: Timer?
    @State private var timerRunning: Bool = false
    
    var body: some View {
        DraggableProgressBar(value: $remainingTime, maxValue: $totalTime, active: $timerRunning)
            .frame(height: 20)
            .onChange(of: timerRunning) { isRunning in
                if isRunning {
                    startTimer()
                } else {
                    stopTimer()
                }
            }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }
    
    private func startTimer() {
        timer?.invalidate()
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                timerRunning = true
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timer?.invalidate()
                    timerRunning = false
                }
            }
        }
    }
}

struct DraggableProgressBar: View {
    @Binding var value: Double
    @Binding var maxValue: Double
    @Binding var active: Bool
    
    var formattedTime: String {
        let minutes = Int(value / 60)
        let seconds = Int(value.truncatingRemainder(dividingBy: 60))
        return String(format: "%2d:%02d", minutes, seconds)
    }
    
    func calculateNewValue(gesture: DragGesture.Value) {
        let newValue = gesture.location.x
        let roundedValue = (newValue / 5).rounded() * 5
        if roundedValue >= 0 && roundedValue <= maxValue {
            value = roundedValue
        }
    }
    func calculatePosition(geometry: GeometryProxy, offset: CGFloat? = nil) -> CGFloat {
        let position = (self.value / self.maxValue) * geometry.size.width
        if let offset {
            if position + offset < 0 {
                return 0
            }
            return position + offset
        }
        return position
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .zIndex(0)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundStyle(.secondary)
                    /*.onTapGesture { point in
                        let newValue = Double(point.x / geometry.size.width) * maxValue
                        let roundedValue = (newValue / 5).rounded() * 5
                        if roundedValue >= 0 && roundedValue <= maxValue {
                            value = roundedValue
                        }
                    }*/
                    .onTapGesture() { active.toggle() }
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                calculateNewValue(gesture: gesture)
                            }
                    )
                
                HStack {
                    Image(systemName: active ? "stop.fill" : "play.fill")
                        .foregroundColor(.white)
                    Text("\(formattedTime)")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .zIndex(2)
                .onTapGesture { active.toggle() }
                .padding(10)
                .background(
                    Capsule()
                        .fill(active ? Color.red : Color.green)
                )
                .offset(x: calculatePosition(geometry: geometry, offset: -60))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            calculateNewValue(gesture: gesture)
                        }
                )
            
                Capsule()
                    .zIndex(1)
                    .frame(width: calculatePosition(geometry: geometry), height: geometry.size.height)
                    .foregroundColor(.primary)
                    .animation(.linear, value: value)
                    .onTapGesture { point in
                       active.toggle()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                calculateNewValue(gesture: gesture)
                            }
                    )
            }
            .background(.clear)
        }
    }
}

struct ContentProgressView: View {
    var body: some View {
        TimeoutBarView()
    }
}

struct ContentViewProgress_Previews: PreviewProvider {
    static var previews: some View {
        ContentProgressView()
    }
}
