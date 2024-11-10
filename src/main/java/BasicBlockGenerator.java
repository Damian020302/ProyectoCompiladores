import java.util.*;

public class BasicBlockGenerator {
    public ControlFlowGraph generateCFG(List<Quadruple> intercode){
        ControlFlowGraph cfg = new ControlFlowGraph();
        BasicBlock currentBlock = new BasicBlock();
        Map<String, BasicBlock> labelToBlock = new HashMap<>();
        for(Quadruple instruction : intercode){
            if(isLabel(instruction.getOp()) || isJump(instruction.getOp())){
                if (isLabel(instruction.getOp())) {
                    if(!currentBlock.getInstructions().isEmpty()){
                        cfg.addBasicBlock(currentBlock);
                        currentBlock = new BasicBlock();
                    }
                    labelToBlock.put(instruction.getResult(), currentBlock);
                }
                currentBlock.addInstruction(instruction);
                if (isJump(instruction.getOp())) {
                    cfg.addBasicBlock(currentBlock);
                    currentBlock = new BasicBlock(); //Como es la última, se debe agregar       
                }
            }            
        }
        if(!currentBlock.getInstructions().isEmpty()){ //Verifica que si no está vacio, que lo agregue a la cfg
            cfg.addBasicBlock(currentBlock);
        }
        setSuccessors(cfg, labelToBlock);
        return cfg;
}

    private boolean isLabel(String operator){
        return operator.equals("LABEL");
    }

    private boolean isJump(String operator){
        return operator.equals("JUMP");
    }

    private void setSuccessors(ControlFlowGraph cfg, Map<String, BasicBlock> labelToBlock){
        List<BasicBlock> blocks = cfg.getBasicBlocks();

        for(int i = 0; i < blocks.size(); i++){
            BasicBlock block = blocks.get(i);
            Quadruple lastInstruction = block.getInstructions().get(block.getInstructions().size() - 1);
            String op = lastInstruction.getOp();
            if (op.equals("goto") || op.equals("return")) {
                BasicBlock target = labelToBlock.get(lastInstruction.getResult());
                block.addSuccessor(target);
            } else if (op.equals("if")) {
                BasicBlock target = labelToBlock.get(lastInstruction.getResult());
                block.addSuccessor(target);
                target = blocks.get(i+1);
                block.addSuccessor(target);
            } else{
                BasicBlock target = blocks.get(i+1);;
                block.addSuccessor(target);
            }
        }
    }
}
