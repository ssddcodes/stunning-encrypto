import dev.ssdd.Encrypto;
import org.junit.Test;

public class ain2_public {
    @Test
    public void name() {
        //DES
        Encrypto encrypto = new Encrypto(Encrypto.DES, "the moon is scary sometimes"); //It's suggested to pass the hash of the password instead of plain text
        String val = "Hi from DES";
        String base64DESEncrypted = encrypto.encrypt(val);
        System.out.printf("Original value: %s\nEncryptedValue: %s\nDecryptedValue: %s", val, base64DESEncrypted, encrypto.decrypt(base64DESEncrypted));

        //RSA
        Encrypto encrypto1 = new Encrypto(Encrypto.RSA, 512);
        String val1 = "Hi from RSA e2ee";
        String base64RSAEncrypted = encrypto1.encrypt(val1, encrypto1.getPublicKey());
        System.out.printf("\n\nOriginal value: %s\nEncryptedValue: %s\nDecryptedValue: %s", val1, base64RSAEncrypted, encrypto1.decrypt(base64RSAEncrypted));
    }
}
