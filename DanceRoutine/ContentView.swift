import SwiftUI

struct ContentView: View {
    @StateObject private var routineManager = RoutineManager()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DanceStepsView()) {
                    Text("View Dance Steps")
                }
                .padding()
                
                NavigationLink(destination: RoutineBuilderView().environmentObject(routineManager)) {
                    Text("Build Dance Routine")
                }
                .padding()
                
                List {
                    ForEach(routineManager.routines) { routine in
                        Text(routine.name)
                    }
                    .onDelete(perform: routineManager.deleteRoutine)
                }
                .navigationTitle("Saved Routines")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
