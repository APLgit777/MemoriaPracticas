import java.io.*;
import java.util.*;

// --- MAIN ---
public class menuUsuarios {
    private static final String FILENAME = "usuarios.txt";

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        ArrayList<Usuario> usuarios = cargarUsuarios();

        int opcion;
        do {
            System.out.println("\n--- MENÚ DE USUARIOS ---");
            System.out.println("1. Agregar usuario");
            System.out.println("2. Modificar usuario");
            System.out.println("3. Eliminar usuario");
            System.out.println("4. Mostrar Usuarios");
            System.out.println("5. Salir");
            System.out.print("Opción: ");
            opcion = sc.nextInt();
            sc.nextLine();
            System.out.println();

            switch (opcion) {
                case 1 -> agregarUsuario(sc, usuarios);
                case 2 -> modificarUsuario(sc, usuarios);
                case 3 -> eliminarUsuario(sc, usuarios);
                case 4 -> muestraUsuario(usuarios);
                case 5 -> System.out.println("Saliendo del programa.");
                default -> System.out.println("Opción no válida.");
            }
            guardarUsuarios(usuarios);
        } while (opcion != 5);

        sc.close();
    }

    // --- Métodos del menú ---

    private static void agregarUsuario(Scanner sc, ArrayList<Usuario> usuarios) {
        System.out.print("Nombre de usuario: ");
        String name = sc.nextLine();
        System.out.print("Contraseña: ");
        String password = sc.nextLine();
        usuarios.add(new Usuario(name, password));
        System.out.println("Usuario agregado correctamente.");
    }

    private static void modificarUsuario(Scanner sc, ArrayList<Usuario> usuarios) {
        System.out.print("Ingrese el nombre del usuario a modificar: ");
        String nombre = sc.nextLine();
        for (Usuario u : usuarios) {
            if (u.getName().equalsIgnoreCase(nombre)) {
                System.out.print("Nuevo nombre: ");
                u.setName(sc.nextLine());
                System.out.print("Nueva contraseña: ");
                u.setPassword(sc.nextLine());
                System.out.println("Usuario modificado.");
                return;
            }
        }
        System.out.println("Usuario no encontrado.");
    }

    private static void eliminarUsuario(Scanner sc, ArrayList<Usuario> usuarios) {
        System.out.print("Ingrese el nombre del usuario a eliminar: ");
        String nombre = sc.nextLine();
        Iterator<Usuario> it = usuarios.iterator();
        while (it.hasNext()) {
            Usuario u = it.next();
            if (u.getName().equalsIgnoreCase(nombre)) {
                it.remove();
                System.out.println("Usuario eliminado.");
                return;
            }
        }
        System.out.println("Usuario no encontrado.");
    }

    private static void muestraUsuario(ArrayList<Usuario> usuarios) {
        if (usuarios.isEmpty()) {
            System.out.println("No hay usuarios registrados.");
        } else {
            System.out.println("Usuarios registrados:");
            for (Usuario u : usuarios) {
                System.out.println("- " + u.toString());
            }
        }
    }
    

    // --- Archivo ---

    private static ArrayList<Usuario> cargarUsuarios() {
        ArrayList<Usuario> lista = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILENAME))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] partes = linea.split(",");
                if (partes.length == 2) {
                    lista.add(new Usuario(partes[0], partes[1]));
                }
            }
        } catch (IOException e) {
        }
        return lista;
    }

    private static void guardarUsuarios(ArrayList<Usuario> usuarios) {
        try (PrintWriter pw = new PrintWriter(new FileWriter(FILENAME))) {
            for (Usuario u : usuarios) {
                pw.println(u.getName() + "," + u.getPassword());
            }
        } catch (IOException e) {
            System.out.println("Error al guardar usuarios: " + e.getMessage());
        }
    }
}

