import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class LiveVariableAnalyzer {
    private ControlFlowGraph cfg;


    public LiveVariableAnalyzer(ControlFlowGraph cfg){
        this.cfg = cfg;
    }

    public Map<BasicBlock, LiveVariableSets> analyze() {
        Map<BasicBlock, LiveVariableSets> liveVarSets = initializeSets();
        boolean changed = true;

        return liveVarSets;
    }


    private Map<BasicBlock, LiveVariableSets> initializeSets() {
        Map<BasicBlock, LiveVariableSets> liveVarSets = new HashMap<>();

        return liveVarSets;
    }


    private Set<String> computeOut(BasicBlock block, Map<BasicBlock, LiveVariableSets> liveVarSets) {
        Set<String> out = new HashSet<>();


        return out;
    }


    private Set<String> computeIn(BasicBlock block, Set<String> use, Set<String> def, Set<String> out) {
        Set<String> in = new HashSet<>();
        Set<String> outMinusDef = new HashSet<>(out);

        return in;
    }

    /**
     * Clase auxiliar que encapsula los conjuntos in, out, use y def de un bloque básico.
     */
    public static class LiveVariableSets {
        public Set<String> in = new HashSet<>();
        public Set<String> out = new HashSet<>();
        public Set<String> use = new HashSet<>();
        public Set<String> def = new HashSet<>();

        public LiveVariableSets(Set<String> use, Set<String> def) {
            this.use = use;
            this.def = def;
        }

        @Override
        public String toString() {
            return "in: " + in + ", out: " + out + ", use: " + use + ", def: " + def;
        }
    }
}