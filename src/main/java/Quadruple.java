package main.java;
public class Quadruple{
    private String op;
    private String arg1;
    private String arg2;
    private String result;
    private int type;

    public Quadruple(){
        this.op = "";
        this.arg1 = "";
        this.arg2 = "";
        this.result = "";
        this.type = 0;
    }

    public Quadruple(String op, String arg1, String arg2, String result){
        this.op = op;
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.result = result;
    }

    public String getOp(){
        return op;
    }

    public String getArg1(){
        return arg1;
    }

    public String getArg2(){
        return arg2;
    }

    public String getResult(){
        return result;
    }

    public int getType(){
        return type;
    }

    public void setOp(String op){
        this.op = op;
    }

    public void setArg1(String arg1){
        this.arg1 = arg1;
    }

    public void setArg2(String arg2){
        this.arg2 = arg2;
    }

    public void setResult(String result){
        this.result = result;
    }

    @Override
    public String toString(){
        return "(" + op + ", " + arg1 + ", " + arg2 + ", " + result + ")";
    }

    public void setType(int type){
        this.type = type;
    }

}