import SwiftUI

struct SavedRoutinesView: View {
    @EnvironmentObject var routineManager: RoutineManager
    @State private var showingEditRoutine = false
    @State private var selectedRoutine: DanceRoutine?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(routineManager.routines) { routine in
                    NavigationLink(destination: RoutineDetailView(routine: routine)) {
                        Text(routine.name)
                    }
                    .swipeActions {
                        Button("Edit") {
                            selectedRoutine = routine
                            showingEditRoutine.toggle()
                        }
                        .tint(.blue)
                        
                        Button("Delete", role: .destructive) {
                            if let index = routineManager.routines.firstIndex(where: { $0.id == routine.id }) {
                                routineManager.routines.remove(at: index)
                                routineManager.saveRoutines()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Saved Routines")
            .navigationBarItems(trailing: EditButton())
            .sheet(item: $selectedRoutine) { routine in
                RoutineBuilderView(routine: routine)
                    .environmentObject(routineManager)
            }
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
