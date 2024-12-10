package main.byacc;

import java.util.List;

public class ParserValExtended extends ParserVal {
    public int tipo; // Representa el tipo semántico
    public String dir; // Dirección temporal
    public String base; // Identificador base (usado en estructuras y arreglos)
    public List<Integer> lista; // Lista auxiliar, por ejemplo, para argumentos o índices

    // Constructores
    public ParserValExtended() {
        super();
        this.tipo = -1; // Valor por defecto
        this.dir = null;
        this.base = null;
        this.lista = null;
    }

    public ParserValExtended(int tipo, String dir, String base, List<Integer> lista) {
        super();
        this.tipo = tipo;
        this.dir = dir;
        this.base = base;
        this.lista = lista;
    }

    public ParserValExtended(String sval) {
        super(sval); // Llama al constructor original de ParserVal
        this.tipo = -1;
        this.dir = null;
        this.base = null;
        this.lista = null;
    }

    @Override
    public String toString() {
        return "ParserValExtended{" +
                "tipo=" + tipo +
                ", dir='" + dir + '\'' +
                ", base='" + base + '\'' +
                ", lista=" + lista +
                '}';
    }
}