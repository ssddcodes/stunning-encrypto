import org.junit.Test;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

public class TimeTest {
    static List<SecureRandom> randoms = new ArrayList<>();
    @Test
    public void secureRandTime() {
        for (int i = 0; i < 100; i++) {
            randoms.add(new SecureRandom()); // 45ms for 100
        }
    }

    @Test
    public void bigIntWithRandomCertainty() {
        for (int i = 0; i < 100; i++) {
            new BigInteger(1024, randoms.get(i).nextInt(), randoms.get(i)); // 42000ms for 100 big ints with 1024 bitlen
            new BigInteger(256, randoms.get(i).nextInt(), randoms.get(i)); // 720ms for 100 big ints with 256 bitlen
            //NOTE: there are 2 BigInts generated in the Encrypto RSA encryption. So if you are planning to generate huge amount of keys frequently, use low bitlength to make it faster.
        }
    }
}