package junit;

import org.junit.Test;

import splitFile.DivCat;
import splitFile.DivOut;

public class DivCatTest {

	@Test
	public void testShortMain() {
		String[] arg = {"short_text.txt"};
		DivCat.main(arg);
	}
	
	@Test
	public void testMain() {
		String[] arg = {"test.txt"};
		DivCat.main(arg);
		String[] args = {"test.txt.div"};
		DivOut.main(args);
	}

}
