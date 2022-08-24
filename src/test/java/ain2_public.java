import dev.ssdd.Encrypto;
import org.junit.Test;

public class ain2_public {
    @Test
    public void name() {
        Encrypto encrypto = new Encrypto("DES", "thepasswordxyz"); //It's suggested to pass the hash of the password instead of plain text
        String x = encrypto.encrypt("alo");
        System.out.println(x);
        System.out.println(encrypto.decrypt(x));
    }
}
