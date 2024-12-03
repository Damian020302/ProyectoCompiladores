package main.java;
import java.util.List;
import java.util.ArrayList;

public class BasicBlock {
    private List<Quadruple> code = new ArrayList<>();
    private List<BasicBlock> successors = new ArrayList<>();
    private LiveVariableAnalyzer.LiveVariableSets LiveVariableSets;

    public void addInstruction(Quadruple instruction){
        code.add(instruction);
    }

    public List<Quadruple> getInstructions(){
        return code;
    }

    public void addSuccessor(BasicBlock block){
        successors.add(block);
    }

    public List<BasicBlock> getSuccessors(){
        return successors;
    }

    public LiveVariableAnalyzer.LiveVariableSets getLiveVariableSets(){
        return LiveVariableSets;
    }

    public void setLiveVariableSets(LiveVariableAnalyzer.LiveVariableSets LiveVariableSets){
        this.LiveVariableSets = LiveVariableSets;
    }

    @Override
    public String toString(){
        StringBuilder sb = new StringBuilder();
        for(Quadruple instruction : code){
            sb.append(instruction.toString());
            sb.append("\n");
        }
        return sb.toString();
    }
}
