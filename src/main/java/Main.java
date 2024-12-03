package main.java;

import main.byacc.Parser;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Scanner;

public class Main {
	public static void main(String args[]) {
		if (args.length == 0) {
			System.out.println("Uso: java Main [archivo_de_entrada]");
			System.out.println("Si no se proporciona un archivo de entrada, se leerá de la consola.");
		}

		if (args.length > 0) {
			try {
				Parser parser = new Parser(new FileReader(args[0]));
				System.out.println("Iniciando análisis sintáctico.");
				parser.parse();
			} catch (FileNotFoundException fnfe) {
				System.err.println("Error: No fue posible leer del archivo de entrada: " + args[0]);
				System.exit(1);
			}
		} else {
			Scanner scanner = new Scanner(System.in);
			while (true) {
				System.out.print("Ingrese una expresión: ");
				String expresion = scanner.nextLine();
				if (expresion.equalsIgnoreCase("salir")) {
					break;
				}
				try {
					Parser parser = new Parser(new java.io.StringReader(expresion));
					System.out.println("Iniciando análisis sintáctico.");
					parser.parse();
				} catch (Exception e) {
					System.err.println("Error: " + e.getMessage());
				}
			}
		}
	}
}
