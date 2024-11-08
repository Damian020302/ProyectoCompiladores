import java.util.HashMap;
import java.util.Optional;

public class TypeTableImpl implements TypeTable{
    private HashMap<Integer, Type> types = new HashMap<>();
    private int idActual = 0;

    @Override
    public int getTam(int id) {
        if (types.containsKey(id)) {
            return types.get(id).getTam();
        } else {
            return -1;
        }
    }

    @Override
    public int getItems(int id) {
        if (types.containsKey(id)) {
            return types.get(id).getItems();
        } else {
            return -1;
            
        }
    }

    @Override
    public String getName(int id) {
        if (types.containsKey(id)) {
            return types.get(id).getName();
        } else {
            return null;
            
        }
    }

    @Override
    public int getParenId(int id) {
        if (types.containsKey(id)) {
            return types.get(id).getParenId();
        } else {
            return -1;
            
        }
    }

    @Override
    public SymbolTable getParentStruct(int id) {
        if (types.containsKey(id)) {
            return types.get(id).getParentStruct();
        } else {
            return null;   
        }
    }

    @Override
    public Optional<Type> getType(int id) {
        return Optional.ofNullable(types.get(id));
    }

    @Override
    public int addType(String name, int items, int parent) {
        Type type = new TypeImpl(name, (short) items, (short) 0, parent, null);
        types.put(idActual, type);
        return idActual++;
    }

    @Override
    public int addType(String name, SymbolTable parent) {
        Type type = new TypeImpl(name, (short) 0, (short) 0, -1, parent);
        types.put(idActual, type);
        return idActual++;
    }

}
