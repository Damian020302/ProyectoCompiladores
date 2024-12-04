package main.java;
import java.util.List;
import java.util.ArrayList;

public class ControlFlowGraph {
    private List<BasicBlock> basicBlocks = new ArrayList<>();
    public void addBasicBlock(BasicBlock block){
        basicBlocks.add(block);
    }

    public List<BasicBlock> getBasicBlocks(){
        return basicBlocks;
    }
}
