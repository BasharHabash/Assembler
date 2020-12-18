package CR16;

public class test {
	public static void main(String[] args)
	{
		for (int i = 0; i < 27; i ++)
		{
			System.out.print("addi " + (i)*16 + ", R3 \n");
			System.out.print("addi 1, R3 \n");
			System.out.print("stor R3, R4\n");
		}
	}
}
