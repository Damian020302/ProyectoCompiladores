package main.byacc;

import java.util.List;
import main.java.*;

public class ParserValExtended extends ParserVal{
    public Type tipo; // Representa el tipo semántico
    public String dir; // Dirección temporal
    public String base; // Identificador base (usado en estructuras y arreglos)
    public List<Integer> lista; // Lista auxiliar, por ejemplo, para argumentos o índices

    // Constructores
    public ParserValExtended() {
        super();
        this.tipo = null; // Valor por defecto
        this.dir = null;
        this.base = null;
        this.lista = null;
    }

    public ParserValExtended(Type tipo, String dir, String base, List<Integer> lista) {
        super();
        this.tipo = tipo;
        this.dir = dir;
        this.base = base;
        this.lista = lista;
    }

    public ParserValExtended(String sval) {
        super(sval); // Llama al constructor original de ParserVal
        this.tipo = null;
        this.dir = null;
        this.base = null;
        this.lista = null;
    }

    public ParserValExtended(int ival) {
        super(ival); // Llama al constructor original de ParserVal
        this.tipo = null;
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