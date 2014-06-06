package junit;

import org.junit.Test;
import splitFile.DivOut;

public class DivOutTest {

	@Test
	public void testMain() {
		String[] arg = {"test.txt"};
		DivOut.main(arg);
	}

}
