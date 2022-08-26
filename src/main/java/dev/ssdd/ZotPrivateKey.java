package dev.ssdd;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

import static dev.ssdd.BigIntPlayground.*;

public class ZotPrivateKey {

    private final BigInteger on; // O(n)
    private final BigInteger d // d
    ;
    public ZotPrivateKey(int bitLen, int nx, ZotKeyPair zotKeyPair, Encrypto encrypto) {
        SecureRandom secureRandom = new SecureRandom();
        BigInteger p = new BigInteger(bitLen, nx, secureRandom);//prime no p
        BigInteger q = new BigInteger(bitLen, nx, secureRandom);//prime no q

        // p*q
        BigInteger n = p.multiply(q);
        // p-1
        BigInteger pm1 = p.subtract(BigInteger.ONE);
        // q-1
        BigInteger qm1 = q.subtract(BigInteger.ONE);
        on = pm1.multiply(qm1);
        // e
        BigInteger e = new BigInteger(bitLen, nx, new SecureRandom());
        d = e.modInverse(on); //d*e mod O(n)

        try{
            assertEquals(e.multiply(d).mod(on));
            zotKeyPair.publicKey = new ZotPublicKey(e, n);
            encrypto.keyPair = zotKeyPair;
        }catch (AssertionError er){
            er.printStackTrace();
        }
    }

    private void assertEquals(BigInteger mod) throws AssertionError{
        if (!BigInteger.ONE.equals(mod)) throw new AssertionError("defect in generating keys.");
    }

    public String decrypt(byte[] decode) {
        return new String(writeBigInt((convertBytesToBigInt(decode).multiply(d)).mod(on)), StandardCharsets.UTF_8);
    }

    @Override
    public String toString() {
        return "Algo: RSA\n" + "modulus: "+on + "\nprivate exponent: "+d;
    }
}
