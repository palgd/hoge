package junit;


import org.junit.Test;

import splitFile.Div;
import splitFile.DivCat;
import splitFile.DivOut;
import splitFile.UnDiv;

public class FlowTest {
	@Test
	public void testDivFlowMain() {
		String[] divArg = {"bin/test/test.txt"};
		String[] unDivArg = {"bin/test/test.txt.div"};
		Div.main(divArg);
		UnDiv.main(unDivArg);
	}
	
	@Test
	public void testDivCatFlowMain() {
		String[] divCatArg = {"bin/test/test2.txt"};
		String[] divOutArg = {"bin/test/test2.txt.div"};
		DivCat.main(divCatArg);
		DivOut.main(divOutArg);
	}
}
