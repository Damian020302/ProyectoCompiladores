import java.util.Optional;

public interface SymbolTableStack {
    void push(SymbolTable table);
    SymbolTable pop();
    Optional<SymbolTable> peek();
    Optional<SymbolTable> base();
    Optional<SymbolTable> lookup(String id); //Busca un sìmbolo en la cima o en la base

}