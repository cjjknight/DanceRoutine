import SwiftUI

struct EditRoutineView: View {
    @EnvironmentObject var routineManager: RoutineManager
    @State var routine: DanceRoutine
    
    var body: some View {
        VStack {
            TextField("Routine Name", text: $routine.name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            List {
                ForEach(routine.steps) { step in
                    Text(step.name)
                }
                .onMove(perform: moveSteps)
                .onDelete(perform: deleteSteps)
            }
            .navigationBarTitle(Text("Edit Routine"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
            
            Button("Save Changes") {
                if let index = routineManager.routines.firstIndex(where: { $0.id == routine.id }) {
                    routineManager.routines[index] = routine
                    routineManager.saveRoutines()
                }
            }
            .padding()
        }
    }
    
    private func moveSteps(from source: IndexSet, to destination: Int) {
        routine.steps.move(fromOffsets: source, toOffset: destination)
    }
    
    private func deleteSteps(at offsets: IndexSet) {
        routine.steps.remove(atOffsets: offsets)
    }
}

struct EditRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        EditRoutineView(routine: DanceRoutine(name: "Sample Routine", steps: [
            DanceStep(name: "Basic Step", description: "The basic step of Quickstep", videoURL: nil)
        ])).environmentObject(RoutineManager())
    }
}
