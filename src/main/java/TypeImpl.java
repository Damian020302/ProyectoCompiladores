public class TypeImpl implements Type{
    private String name;
    private short items;
    private short tam;
    private int parenId;
    private SymbolTable parentStruct;
    
    public TypeImpl(String name, short items, short tam, int parenId, SymbolTable parentStruct){
        this.name = name;
        this.items = items;
        this.tam = tam;
        this.parenId = parenId;
        this.parentStruct = parentStruct;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public short getItems() {
        return items;
    }

    @Override
    public short getTam() {
        return tam;
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
