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
                
                NavigationLink(destination: SavedRoutinesView().environmentObject(routineManager)) {
                    Text("View Saved Routines")
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
