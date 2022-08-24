package dev.ssdd;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

public class ZotPrivateKey {

    BigInteger p, //prime no p
            q, //prime no q
            n, // p*q
            pm1, // p-1
            qm1, // q-1
            on, // O(n)
            e, // e
            d // d
    ;
    public ZotPrivateKey(int bitLen, int nx, ZotKeyPair zotKeyPair, Encrypto encrypto) {
        SecureRandom secureRandom = new SecureRandom();
        p = new BigInteger(bitLen, nx, secureRandom);
        q=new BigInteger(bitLen, nx, secureRandom);
        n= p.multiply(q);
        pm1 = p.subtract(BigInteger.ONE);
        qm1 = q.subtract(BigInteger.ONE);
        on = pm1.multiply(qm1);
        e = new BigInteger(bitLen, nx, new SecureRandom());
        d = e.modInverse(pm1.multiply(qm1));

        try{
            assertEquals(e.multiply(d).mod(on));
            zotKeyPair.publicKey = new ZotPublicKey(e,n);
            encrypto.keyPair = zotKeyPair;
        }catch (AssertionError er){
            er.printStackTrace();
        }
    }

    private void assertEquals(BigInteger mod) throws AssertionError{
        if (!BigInteger.ONE.equals(mod)) throw new AssertionError("defect in generating keys.");
    }

    @Override
    public String toString() {
        return "Algo: RSA\n" + "modulus: "+on + "\nprivate exponent: "+d;
    }

    public String decrypt(byte[] decode) {
        return new String((new BigInteger(decode).multiply(d)).mod(on).toByteArray(), StandardCharsets.UTF_8);
    }
}
