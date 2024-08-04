import SwiftUI

struct SavedRoutinesView: View {
    @EnvironmentObject var routineManager: RoutineManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(routineManager.routines) { routine in
                    NavigationLink(destination: RoutineBuilderView(routine: routine)) {
                        Text(routine.name)
                    }
                }
                .onDelete(perform: deleteRoutines)
            }
            .navigationTitle("Saved Routines")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteRoutines(at offsets: IndexSet) {
        routineManager.routines.remove(atOffsets: offsets)
        routineManager.saveRoutines()
    }
}

struct SavedRoutinesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedRoutinesView().environmentObject(RoutineManager())
    }
}
