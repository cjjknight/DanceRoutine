import SwiftUI

struct DanceStepsView: View {
    let steps: [DanceStep] = [
        DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil),
        DanceStep(name: "Quarter Turn", description: "A quarter turn to the right", videoURL: nil)
        // Add more steps as needed
    ]
    
    var body: some View {
        List(steps) { step in
            VStack(alignment: .leading) {
                Text(step.name)
                    .font(.headline)
                Text(step.description)
                    .font(.subheadline)
            }
        }
        .navigationTitle("Dance Steps")
    }
}

struct DanceStepsView_Previews: PreviewProvider {
    static var previews: some View {
        DanceStepsView()
    }
}
