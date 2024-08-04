import SwiftUI

struct RoutineDetailView: View {
    var routine: DanceRoutine
    
    var body: some View {
        List {
            ForEach(routine.steps) { step in
                VStack(alignment: .leading) {
                    Text(step.name)
                        .font(.headline)
                    Text(step.description)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(routine.name)
    }
}

struct RoutineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineDetailView(routine: DanceRoutine(name: "Sample Routine", steps: [
            DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil),
            DanceStep(name: "Quarter Turn", description: "A quarter turn to the right", videoURL: nil)
        ]))
    }
}
