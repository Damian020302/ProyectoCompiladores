import java.util.ArrayList;

public class SymbolImpl implements Symbol {
    private int dir;
    private int type;
    private String cat;
    private ArrayList<Integer> args;
    
    /**
     * Constructor
     */
    public SymbolImpl(int dir, int type, String cat, ArrayList<Integer> args){
        this.dir = dir;
        this.type = type;
        this.cat = cat;
        this.args = args;
    }

    @Override
    public int getDir() {
        return dir;
    }

    @Override
    public int getType() {
        return type;
    }

    @Override
    public String getCat() {
        return cat;
    }

    @Override
    public ArrayList<Integer> getArgs() {
        return args;
    }
}
