package junit;

import org.junit.Test;

import splitFile.Div;

public class DivTest {
	@Test
	public void testMain() {
		String[] arg = {"test.txt"};
		Div.main(arg);
	}

}
