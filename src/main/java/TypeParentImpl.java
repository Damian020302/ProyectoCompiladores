public class TypeParentImpl implements TypeParent {
    private int parenId;
    private SymbolTable parentStruct;

    public TypeParentImpl(int parenId, SymbolTable parentStruct) {
        this.parenId = parenId;
        this.parentStruct = parentStruct;
    }

    @Override
    public int getParenId() {
        return parenId;
    }

    @Override
    public SymbolTable getParentStruct() {
        return parentStruct;
    }
}