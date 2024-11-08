import java.util.ArrayList;
import java.util.Optional;

public class SymbolTableStackImpl implements SymbolTableStack{
    private ArrayList<SymbolTable> stack = new ArrayList<>();

    @Override
    public void push(SymbolTable symbolTable) {
        stack.add(symbolTable);
    }

    @Override
    public SymbolTable pop() {
        if (!stack.isEmpty()) {
            return stack.remove(stack.size() - 1);
        }
        throw new IllegalStateException("Stack is empty");
    }

    @Override
    public Optional<SymbolTable> peek() {
        if (!stack.isEmpty()) {
            return Optional.of(stack.get(stack.size() - 1));
        }
        return Optional.empty();
    }

    @Override
    public Optional<SymbolTable> base() {
        if (!stack.isEmpty()) {
            return Optional.of(stack.get(0));
        }
        return Optional.empty();
    }

    @Override
    public Optional<SymbolTable> lookup(String id) {
        for (int i = stack.size() - 1; i >= 0; i--) {
            Optional<Symbol> symbol = stack.get(i).lookup(id);
            if (symbol.isPresent()) {
                return Optional.of(stack.get(i));
            }
        }
        return Optional.empty();
    }
}