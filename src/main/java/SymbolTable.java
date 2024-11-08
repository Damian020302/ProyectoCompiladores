import java.util.HashMap;
import java.util.Optional;

public class SymbolTable {
    private HashMap<String, Symbol> symbols = new HashMap<>();
    private SymbolTable parent;

    public SymbolTable(SymbolTable parent) {
        this.parent = parent;
    }

    public void addSymbol(String id, Symbol symbol) {
        symbols.put(id, symbol);
    }

    public Optional<Symbol> lookup(String id) {
        if (symbols.containsKey(id)) {
            return Optional.of(symbols.get(id));
        } else if (parent != null) {
            return parent.lookup(id);
        }
        return Optional.empty();
    }
}
