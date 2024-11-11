import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
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
        while (changed) {
            changed = false;
            for (BasicBlock block : cfg.getBasicBlocks()) {
                Set<String> out = computeOut(block, liveVarSets);
                Set<String> in = computeIn(block, liveVarSets.get(block).use, liveVarSets.get(block).def, out);
                if (!out.equals(liveVarSets.get(block).out) || !in.equals(liveVarSets.get(block).in)) {
                    liveVarSets.get(block).in = in;
                    liveVarSets.get(block).out = out;
                    changed = true;
                }
            }
        }
        return liveVarSets;
    }


    private Map<BasicBlock, LiveVariableSets> initializeSets() {
        Map<BasicBlock, LiveVariableSets> liveVarSets = new HashMap<>();
        for (BasicBlock block : cfg.getBasicBlocks()) {
            LiveVariableSets sets = new LiveVariableSets(new HashSet<>(), new HashSet<>());
            block.setLiveVariableSets(sets);
            Set<String> use = new HashSet<>();
            Set<String> def = new HashSet<>();
            for (Quadruple instruction : block.getInstructions()) {
                // Si la instrucción tiene un resultado, es una variable definida
                if (instruction.getResult() != null && !instruction.getResult().isEmpty()) {
                    def.add(instruction.getResult());
                }
                // Si la instrucción tiene un argumento 1 o 2, son variables usadas
                if (instruction.getArg1() != null && !instruction.getArg1().isEmpty()) {
                    use.add(instruction.getArg1());
                }
                if (instruction.getArg2() != null && !instruction.getArg2().isEmpty()) {
                    use.add(instruction.getArg2());
                }
            }
            sets.use = use;
            sets.def = def;
        }
        return liveVarSets;
    }


    private Set<String> computeOut(BasicBlock block, Map<BasicBlock, LiveVariableSets> liveVarSets) {
        Set<String> out = new HashSet<>();
        for (BasicBlock successor : block.getSuccessors()) {
            out.addAll(liveVarSets.get(successor).in);
        }

        return out;
    }


    private Set<String> computeIn(BasicBlock block, Set<String> use, Set<String> def, Set<String> out) {
        Set<String> in = new HashSet<>();
        in.remove(def);
        in.addAll(use);
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