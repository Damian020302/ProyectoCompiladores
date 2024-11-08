public interface Type {
    String getName();        
    short getItems();
    short getTam();    
    int getParenId();
    SymbolTable getParentStruct();
}
