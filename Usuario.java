public class Usuario {
    private String name;
    private String password;

    public Usuario(String name, String password) {
        this.name = name;
        this.password = password;
    }

    // Getters
    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }

    // Setters
    public void setName(String name) {
        this.name = name;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "Usuario: " + name + ", Contraseña: " + password;
    }
}
