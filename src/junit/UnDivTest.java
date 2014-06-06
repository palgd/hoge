package junit;

import org.junit.Test;

import splitFile.UnDiv;

public class UnDivTest {

	@Test
	public void testMain() {
		String[] arg = {"test.txt.div"};
		UnDiv.main(arg);
	}

}
