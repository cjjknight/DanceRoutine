import SwiftUI

struct DanceStepsView: View {
    @EnvironmentObject var routineManager: RoutineManager
    
    var body: some View {
        List {
            ForEach(routineManager.availableSteps) { step in
                VStack(alignment: .leading) {
                    Text(step.name)
                        .font(.headline)
                    Text(step.description)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Dance Steps")
    }
}

struct DanceStepsView_Previews: PreviewProvider {
    static var previews: some View {
        DanceStepsView().environmentObject(RoutineManager())
    }
}
