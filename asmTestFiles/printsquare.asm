package CR16;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class main 
{

	public static HashMap <String, Integer> label = new HashMap<>();
	public static HashMap <String, Integer> labelFake = new HashMap<>();
	public static ArrayList <String> lines = new ArrayList<>();
	public static StringBuilder out = new StringBuilder();
	public static StringBuilder result = new StringBuilder();
	public static int PC;
	public static boolean scan;
	public static int counter;
	public static int line;
	
	public static void main(String[] args)
	{
		File file = new File(".//new1.asm"); 
	    Scanner sc = null;
		try {
			sc = new Scanner(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} 
		
	    while(sc.hasNext())
	    		lines.add(sc.nextLine());
	    
	    handleLabels();
	    counter = 0;
	    scan = true;
	    handleCode();
	    //handlePC();
	    scan = false;
	    out = new StringBuilder();
	    result = new StringBuilder();
	    handleCode();
	    
	    sc.close();
	    
	    fill();
	    System.out.print(out.toString());
	    write(result.toString());
	}
	
	public static void handleCode()
	{
		PC = 0;
	    line = 0;
	    counter = 0;
	    
		for (int j = 0; j < lines.size(); j++)
	    { 
			line ++;
		    	String line = lines.get(j);
		    	String comment = "#";
		    	if (!line.isEmpty() && !line.startsWith(comment))
		    	{
			    	String[] token = line.split("\\s*(=>|,|\\s)\\s*");
			    	ArrayList <String> instr = new ArrayList<>();
			    	for (int i = 0; i < token.length; i++)
			    	{
			    		if(token[i].isEmpty())
			    		{
			    			continue;
			    		}
			    		else if (token[i].startsWith(comment))
			    		{
		    				handleInstr(instr);
		    				instr.clear();
		    				PC ++;
		    				break;
			    		}
			    		else
			    		{
			    			instr.add(token[i]);
				    		if (i == token.length - 1)
				    		{
			    				handleInstr(instr);
			    				instr.clear();
			    				PC ++;
				    		}
			    		}
			    	}
		    	}
	    }
	}
	
	public static void handleLabels ()
	{
		PC = 0;
		
		for (String l : lines)
	    {
	    	String line = l;
	    	String comment = "#";
	    	if (!line.isEmpty() && !line.startsWith(comment))
	    	{
		    	String[] token = line.split("\\s*(=>|,|\\s)\\s*");
		    	ArrayList <String> instr = new ArrayList<>();
		    	for (int i = 0; i < token.length; i++)
		    	{
		    	
		    		if(token[i].isEmpty())
		    		{
		    			continue;
		    		}
		    		else if (token[i].startsWith(comment))
		    		{
		    			if (instr.get(0).endsWith(":"))
		    	    	{
		    	    		int length = instr.get(0).length();
		    	    		labelFake.put(instr.remove(0).substring(0, length - 1), PC);
		    	    	}
	    				instr.clear();
	    				PC ++;
	    				break;
		    		}
		    		else
		    		{
		    			instr.add(token[i]);
			    		if (i == token.length - 1)
			    		{
			    			if (instr.get(0).endsWith(":"))
			    	    	{
			    	    		int length = instr.get(0).length();
			    	    		labelFake.put(instr.remove(0).substring(0, length - 1), PC);
			    	    	}
		    				instr.clear();
		    				PC ++;
			    		}
		    		}
		    	}
	    	}
	    }
	}
	
//	public static void handlePC ()
//	{
//		PC = 0;
//		
//		for (String l : lines)
//	    {
//	    	String line = l;
//
//	    	String comment = "#";
//	    	if (!line.isEmpty() && !line.startsWith(comment))
//	    	{
//		    	String[] token = line.split("\\s*(=>|,|\\s)\\s*");
//		    	ArrayList <String> instr = new ArrayList<>();
//		    	for (int i = 0; i < token.length; i++)
//		    	{
//		    		if(token[i].isEmpty())
//		    		{
//		    			continue;
//		    		}
//		    		else if (token[i].startsWith(comment))
//		    		{
//		    			if (instr.get(0).startsWith("j") && (label.containsKey(instr.get(1)) || label.containsKey(instr.get(2))))
//		    	    	{
//		    				for (String s : label.keySet())
//		    				{
//		    					int c = label.get(s);
//		    					if (PC <= c)
//		    					{
//		    						label.replace(s, c + 2);
//		    						PC += 2;
//		    					}
//		    				}
//		    	    	}
//	    				instr.clear();
//	    				PC ++;
//	    				break;
//		    		}
//		    		else
//		    		{
//		    			if (!token[i].endsWith(":"))
//		    				instr.add(token[i]);
//			    		if (i == token.length - 1)
//			    		{
//			    			if (instr.get(0).startsWith("j") && label.containsKey(instr.get(1)))
//			    	    	{
//			    				boolean inc = false;
//			    				for (String s : label.keySet())
//			    				{
//			    					int c = label.get(s);
//			    					if (PC <= c)
//			    					{
//			    						inc = true;
//			    						label.replace(s, c + 2);
//			    					}
//			    				}
//			    				if (inc)
//			    					PC += 2;
//			    	    	}
//		    				instr.clear();
//		    				PC ++;
//			    		}
//		    		}
//		    	}
//	    	}
//	    }
//		
//	}
	
	public static void handleInstr (ArrayList<String> instr)
	{	
	    	if (instr.get(0).endsWith(":"))
	    	{
	    		if (scan)
	    		{
		    		int length = instr.get(0).length();
		    		label.put(instr.remove(0).substring(0, length - 1), counter);
	    		}
	    		else
	    			instr.remove(0);
	    	}
	    	
	    	if (instr.get(0).startsWith("j"))
	    		handleJcond(instr);
	    	
	    	else if (instr.get(0).startsWith("b"))
	    		handleBcond(instr);
	    	
	    	else 
	    	{
		    	switch(instr.get(0))
		    	{
			    	case "addi":
			    		iType ("0101", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "subi":
			    		iType ("1001", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "cmpi":
			    		iType ("1011", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "andi":
			    		iType ("0001", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "ori":
			    		iType ("0010", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "xori":
			    		iType ("0011", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "movi":
			    		iType("1101", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "lshi":
			    		iType("1000", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "lui":
			    		iType("1111", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "add":
			    		rType ("0000", "0101", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "sub":
			    		rType ("0000", "1001", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "cmp":
			    		rType ("0000", "1011", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "and":
			    		rType ("0000", "0001", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "or":
			    		rType ("0000", "0010", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "xor":
			    		rType ("0000", "0011", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "mov":
			    		rType ("0000", "1101", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "lsh":
			    		rType ("1000", "0100", instr.get(2), instr.get(1));
			    		break;
			    		
			    	case "load":
			    		rType ("0100", "0000", instr.get(1), instr.get(2));
			    		break;
			    		
			    	case "stor":
			    		rType ("0100", "0100", instr.get(1), instr.get(2));
			    		break;
			    		
			    	default:
			    		System.out.println("*ERROR* Invalid instruction: " + instr.toString() + ", at line: " + line);
			    		break;
		    	}
	    	}
	    	
	    	for(int i = 0; i < instr.size() - 1; i++)
	    		out.append(instr.get(i) + " ");
	    	
	    	out.append(instr.get(instr.size() - 1) + "	" + (counter - 1) + "\n");
	    	out.append("----------------------------------\n");
	}
	
	public static void handleJcond (ArrayList<String> instr)
	{
		if (scan)
		{
			if (labelFake.containsKey(instr.get(1)))
			{
				labelJ(instr.get(0), instr.get(1));
				return;
			}
			if (instr.get(0).equals("jal"))
			{
				if (labelFake.containsKey(instr.get(2)))
				{
					labelJal(instr.get(0), instr.get(1), instr.get(2));
					return;
				}
				else
				{
					rType ("0100", "1000", instr.get(1), instr.get(2));
		    			return;
				}
			}
		}
		else
		{
			if (label.containsKey(instr.get(1)))
			{
				labelJ(instr.get(0), instr.get(1));
				return;
			}
			if (instr.get(0).equals("jal"))
			{
				if (label.containsKey(instr.get(2)))
				{
					labelJal(instr.get(0), instr.get(1), instr.get(2));
					return;
				}
				else
				{
					rType ("0100", "1000", instr.get(1), instr.get(2));
		    			return;
				}
			}
		}
		
		
	    	switch(instr.get(0))
	    	{
		    	case "jeq": 
		    		jCondType ("0000", instr.get(1));
		    		break;
		    		
		    	case "jne": 
		    		jCondType ("0001", instr.get(1));
		    		break;
		    		
		    	case "jcs": 
		    		jCondType ("0010", instr.get(1));
		    		break;
		    		
		    	case "jcc": 
		    		jCondType ("0011", instr.get(1));
		    		break;
		    		
		    	case "jhi": 
		    		jCondType ("0100", instr.get(1));
		    		break;
		    		
		    	case "jls": 
		    		jCondType ("0101", instr.get(1));
		    		break;
		    		
		    	case "jgt": 
		    		jCondType ("0110", instr.get(1));
		    		break;
		    		
		    	case "jle": 
		    		jCondType ("0111", instr.get(1));
		    		break;
		    		
		    	case "jfs": 
		    		jCondType ("1000", instr.get(1));
		    		break;
		    		
		    	case "jfc": 
		    		jCondType ("1001", instr.get(1));
		    		break;
		    		
		    	case "jlo": 
		    		jCondType ("1010", instr.get(1));
		    		break;
		    		
		    	case "jhs": 
		    		jCondType ("1011", instr.get(1));
		    		break;
		    		
		    	case "jlt": 
		    		jCondType ("1100", instr.get(1));
		    		break;
		    		
		    	case "jge": 
		    		jCondType ("1101", instr.get(1));
		    		break;
		    		
		    	case "juc": 
		    		jCondType ("1110", instr.get(1));
		    		break;
		    		
				default:
					System.out.println("*ERROR* Invalid cond jump instruction: " + instr.toString() + ", at line:" + line);
		    		break;
    		}
	}
	
	public static void handleBcond (ArrayList<String> instr)
	{
		switch(instr.get(0))
		{
	    	case "beq": 
	    		bCondType ("0000", instr.get(1));
	    		break;
	    		
	    	case "bne": 
	    		bCondType ("0001", instr.get(1));
	    		break;
	    		
	    	case "bcs": 
	    		bCondType ("0010", instr.get(1));
	    		break;
	    		
	    	case "bcc": 
	    		bCondType ("0011", instr.get(1));
	    		break;
	    		
	    	case "bhi": 
	    		bCondType ("0100", instr.get(1));
	    		break;
	    		
	    	case "bls": 
	    		bCondType ("0101", instr.get(1));
	    		break;
	    		
	    	case "bgt": 
	    		bCondType ("0110", instr.get(1));
	    		break;
	    		
	    	case "ble": 
	    		bCondType ("0111", instr.get(1));
	    		break;
	    		
	    	case "bfs": 
	    		bCondType ("1000", instr.get(1));
	    		break;
	    		
	    	case "bfc": 
	    		bCondType ("1001", instr.get(1));
	    		break;
	    		
	    	case "blo": 
	    		bCondType ("1010", instr.get(1));
	    		break;
	    		
	    	case "bhs": 
	    		bCondType ("1011", instr.get(1));
	    		break;
	    		
	    	case "blt": 
	    		bCondType ("1100", instr.get(1));
	    		break;
	    		
	    	case "bge": 
	    		bCondType ("1101", instr.get(1));
	    		break;
	    		
	    	case "buc": 
	    		bCondType ("1110", instr.get(1));
	    		break;
	    		
			default:
				System.out.println("*ERROR* Invalid cond branch instruction: " + instr.toString() + ", at line:" + line);
	    		break;
		}
	}
	
	public static void jCondType (String cond, String reg)
	{
		if (!scan)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append("0100");
			
			binary.append(cond);
			
			binary.append("1100");
			
			
			// Register Dest
			int r = Integer.parseInt(reg.substring(1));
	//		if (reg.equals("R0"))
	//			System.out.println("*ERROR* Invalid register (R0 used), at line:" + line);
			if (!reg.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			else if (r < 0 || r > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			else 
			{
				int dest = Integer.parseInt(reg.substring(1));
				binary.append(String.format("%4s", Integer.toBinaryString(dest)).replace(' ', '0'));
			}
			
			counter ++;
			out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else
			counter++;
	}
	
	public static void bCondType (String cond, String disp)
	{
		if (!scan)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append("1100");
			
			binary.append(cond);
			
			// Register Dest
			int dispV = Integer.parseInt(disp);
			if (dispV < -128 || dispV > 127)
				System.out.println("*ERROR* Invalid (out of range) dest in branch instruction, at line:" + line);
			else if (dispV < 0)
				binary.append(String.format("%8s", Integer.toBinaryString(dispV).substring(24)));
			else 
				binary.append(String.format("%8s", Integer.toBinaryString(dispV)).replace(' ', '0'));
			
			counter ++;
			out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else 
			counter++;
	}
	
	public static void iType (String opCode, String immS, String reg)
	{
		if (!scan)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append(opCode); // OP code
			
			// Register Dest
			int r = Integer.parseInt(reg.substring(1));
	//		if (reg.equals("R0"))
	//			System.out.println("*ERROR* Invalid register (R0 used), at line:" + line);
			if (!reg.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			if (r < 0 || r > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			
			int dest = Integer.parseInt(reg.substring(1));
			binary.append(String.format("%4s", Integer.toBinaryString(dest)).replace(' ', '0'));
		
			
			if (!opCode.equals("1000"))
			{
				// Immediate
				int immV = Integer.parseInt(immS);
				if (immV < -128 || immV > 127)
					System.out.println("*ERROR* Invalid (out of range) immediate vallue instruction, at line:" + line);
				if (immV < 0)
					binary.append(String.format("%8s", Integer.toBinaryString(immV).substring(24)));
				else 
					binary.append(String.format("%8s", Integer.toBinaryString(immV)).replace(' ', '0'));
			}
			else
			{
				// Handling LSHI instruction
				int immV = Integer.parseInt(immS);
				if (immV >= 0)
					binary.append("0000");
				else 
					binary.append("0001");
					
				if (immV < -15 || immV > 15)
					System.out.println("*ERROR* Invalid (out of range) immediate vallue instruction, at line:" + line);
				else if (immV < 0)
					binary.append(String.format("%4s", Integer.toBinaryString(immV).substring(28)));
				else 
					binary.append(String.format("%4s", Integer.toBinaryString(immV)).replace(' ', '0'));
			}
			counter ++;
			out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else 
			counter ++;
	}
	
	public static void rType (String opCode, String opCodeEx, String regSrc, String regDest)
	{
		if (!scan)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append(opCode); // OP code
			
			// Register Src
			int r1 = Integer.parseInt(regSrc.substring(1));
	//		if (regSrc.equals("R0"))
	//			System.out.println("*ERROR* Invalid register (R0 used), at line:" + line);
			if (!regSrc.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			if (r1 < 0 || r1 > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			
			int src = Integer.parseInt(regSrc.substring(1));
			binary.append(String.format("%4s", Integer.toBinaryString(src)).replace(' ', '0'));
	
			
			binary.append(opCodeEx); // OP Code Ext
			
			// Register Dest
			int r2 = Integer.parseInt(regDest.substring(1));
	//		if (regDest.equals("R0"))
	//			System.out.println("*ERROR* Invalid register (R0 used), at line:" + line);
			if (!regDest.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			if (r2 < 0 || r2 > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			
			int dest = Integer.parseInt(regDest.substring(1));
			binary.append(String.format("%4s", Integer.toBinaryString(dest)).replace(' ', '0'));
			
			counter ++;
			out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
		result.append(b2hex(binary.toString()) + "\n");
		}
		else
			counter ++;
	}
	
	public static void labelJ (String cond, String l)
	{
		if(!scan)
		{
			String cmp = result.substring(counter*5 - 5, counter*5);
			result.delete(counter*5 - 5, counter*5);
			String labelPC = String.format("%16s", Integer.toBinaryString(label.get(l))).replace(' ', '0');
			
			int hiBits = Integer.parseInt(labelPC.substring(0, 8), 2);
			int loBits = Integer.parseInt(labelPC.substring(8, 16), 2);
		
			iType("1101", Integer.toString(loBits), "R1"); // MOVI lower bits
			iType("1111", Integer.toString(hiBits), "R1"); // LUI Upper bits
			
			result.append(cmp);
			
			ArrayList<String> instr = new ArrayList<>();
			instr.add(cond);
			instr.add("R1");
		
			handleJcond(instr);
		}
		else
		{
			iType("1101", "0", "R1"); // MOVI lower bits
			iType("1111", "0", "R1"); // LUI Upper bits
			ArrayList<String> instr = new ArrayList<>();
			instr.add(cond);
			instr.add("R1");
		
			handleJcond(instr);
		}
	}
	
	public static void labelJal (String jal, String ra, String l)
	{
		if (!scan)
		{
			String labelPC = String.format("%16s", Integer.toBinaryString(label.get(l))).replace(' ', '0');
			
			int hiBits = Integer.parseInt(labelPC.substring(0, 8), 2);
			int loBits = Integer.parseInt(labelPC.substring(8, 16), 2);
			
			iType("1101", Integer.toString(loBits), "R1"); // MOVI lower bits
			iType("1111", Integer.toString(hiBits), "R1"); // LUI Upper bits
			
			ArrayList<String> instr = new ArrayList<>();
			instr.add(jal);
			instr.add(ra);
			instr.add("R1");
		
			handleJcond(instr);
		}
		else
		{
			iType("1101", "0", "R1"); // MOVI lower bits
			iType("1111", "0", "R1"); // LUI Upper bits
			ArrayList<String> instr = new ArrayList<>();
			instr.add(jal);
			instr.add(ra);
			instr.add("R1");
			handleJcond(instr);
		}
	}
	
	public static String b2hex (String b) 
	{
		int i = Integer.parseInt(b, 2);
		return String.format("%4s", Integer.toString(i, 16)).replace(' ', '0');
	}
	
	public static void fill ()
	{
		int l = 65536;
		//int l = 1024;
		
		for (int i = counter; i < l; i++)
			if (i == l - 1)
				result.append("0000");
			else 
				result.append("0000" + "\n");
	}
	
	public static void write (String s)
	{
		File PATH_TO_FILE = new File(".//new1.dat"); 
		
	    try {
	    	FileWriter fw =new FileWriter(PATH_TO_FILE, false);
	    	fw.write(s);
	    	fw.close();
	    } catch (IOException e) 
	    {
	    	e.printStackTrace();
	    } 
	}
}