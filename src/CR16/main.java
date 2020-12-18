/*
 * Authors: Bashar Al-Habash, Kolby Silim and Paul Brown
 * 
 * This is an assembler that will take an asm file specified in the main function
 * placed in the top directory of the project. Then convert the code to hex values 
 * that can be read by a CR16-processor. The output is placed in a created Hex.dat
 * file that is also in the top directory of the project. The lines of the processor
 * memory to be filled by the assembler is specified in the global variable memoryLines.
 * 
 * From the CR16 ISA the following instructions can be handled by this assembler:
 * ADD Rsrc, Rdest
 * ADDI Imm, Rdest
 * SUB Rsrc, Rdest
 * SUBI Imm, Rdest
 * CMP Rsrc, Rdest
 * CMPI Imm, Rdest
 * AND Rsrc, Rdest
 * ANDI Imm, Rdest
 * OR Rsrc, Rdest
 * ORI Imm, Rdest
 * XOR Rsrc, Rdest
 * XORI Imm, Rdest
 * MOV Rsrc, Rdest
 * MOVI Imm, Rdest
 * LSH Ramount, Rdest
 * LSHI Imm, Rdest
 * LUI Imm, Rdest
 * LOAD Rdest, Raddr
 * STOR Raddr, Rsrc	// NOTE: this is flipped from the standard CR16 ISA
 * Bcond disp
 * Jcond Rtarget
 * Jcond “label”
 * JAL Rlink, Rtarget
 * JAL Rlink, “label”
 * 
 * For our conditions these are the implemented conditions: 
 * EQ, NE, CS, CC, JI, LS, GT, LE, FS, FC, LO, HS, LT, GE, UC
 * 
 * 
 * The specifications of the instruction use and condition can be found in the CR16 ISA
 */
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
	// Variables set by the user:
	public static int memoryLines = 65536;									// How many lines of memory does .dat file need to be filled
	public static boolean debug = false;									// Output debugging information to console or not
	
	// ---------------------------------------------------------------------------------------------------------------------------------- //
	public static HashMap <String, Integer> label = new HashMap<>();		// Hold the labels and the their position in the code (PC)
	public static HashMap <String, Integer> tempLabels = new HashMap<>();	// Hold labels temporarily in order to update the PC  
	public static ArrayList <String> lines = new ArrayList<>();				// Holds all the lines of the code
	public static StringBuilder out = new StringBuilder();					// Debugging and helpful information to display to Java console
	public static StringBuilder result = new StringBuilder();				// The assembled program in Hex to be put the .dat file
	public static boolean updateLabels;										// Indicate if we are in the third or second scan
	public static int PC;													// Current Program counter
	public static int line;													// The line the assembler is currently on in the .asm file
	
	public static void main(String[] args)
	{
		// Scan the .asm file in the current project directory 
		File file = new File(".//CR16.asm"); 
	    Scanner sc = null;
		try {
			sc = new Scanner(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} 
		
		// Add all lines of code into an ArrayList
	    while(sc.hasNext())
	    	lines.add(sc.nextLine());
	    
	    // Create the tempLabels for the program (first scan)
	    handleLabels();
	    // Run through the code only to update the labels (second scan)
	    updateLabels = true;
	    handleCode();
	    // run through the code to get the final assembled output (third scan)
	    updateLabels = false;
	    out = new StringBuilder();
	    result = new StringBuilder();
	    handleCode();
	    
	    sc.close();
	    
	    // Fill the .dat file, output information to console and the result to .dat file
	    fill();
	    System.out.print(out.toString());
	    write(result.toString());
	}
	
	/*
	 * This function will go through the lines of the code
	 * excluding any comments or blank lines seen.
	 * 
	 * What we are left with are just the instructions,
	 * which are split into tokens, without the commas and extra spaces
	 * 
	 * Finally, call the handleInstr function to deal with the tokens.
	 * 
	 * Note, this function is called in the second scan to update labels
	 * and in the third scan to assemble the hex output.
	 */
	public static void handleCode()
	{
	    line = 0;
	    PC = 0;
	    
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
		    				break;
			    		}
			    		else
			    		{
			    			instr.add(token[i]);
				    		if (i == token.length - 1)
				    		{
			    				handleInstr(instr);
			    				instr.clear();
				    		}
			    		}
			    	}
		    	}
	    }
	}
	
	/*
	 * This function goes through the lines of code
	 * and identifies labels which have a  ":" at the end of them.
	 * It will store those labels and the current instruction line 
	 * that the label is on in a HashMap which will be used later 
	 * during assembling.
	 */
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
		    	    		tempLabels.put(instr.remove(0).substring(0, length - 1), PC);
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
			    	    		tempLabels.put(instr.remove(0).substring(0, length - 1), PC);
			    	    	}
		    				instr.clear();
		    				PC ++;
			    		}
		    		}
		    	}
	    	}
	    }
	}
	
	/*
	 * This function is called on every instruction separately.
	 * 
	 * It identifies labels within instruction and updates them with 
	 * a new PC counter during the second scan, as any instruction that
	 * contains a label will need to execute more instruction which will 
	 * put the labels at a different PC
	 * 
	 * During both the second & third scan it, it identifies if the instruction
	 * is a jump instruction and calls handleJcond, or if it is a branch calls handleBcond.
	 * Otherwise, the instruction is a iType or an rType, in which case is passes in:
	 * opCode, opCodeExt, 1 or 2 registers used and an immediate depending on the instruction type.
	 * 
	 * This function will also print an error message to the console if the instruction is not supported.
	 * It will also print helpful debugging information such as the instruction, its PC and line position
	 */
	public static void handleInstr (ArrayList<String> instr)
	{	
		// Update PC for labels
    	if (instr.get(0).endsWith(":"))
    	{
    		if (updateLabels)
    		{
	    		int length = instr.get(0).length();
	    		label.put(instr.remove(0).substring(0, length - 1), PC);
    		}
    		else
    			instr.remove(0);
    	}
    	// Handle the jump instructions
    	if (instr.get(0).startsWith("j"))
    		handleJcond(instr);
    	// Handle branch instructions
    	else if (instr.get(0).startsWith("b"))
    		handleBcond(instr);
    	// handle rType and iType
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
		    		System.out.println("*ERROR* Invalid or unsupported instruction: " + instr.toString() + ", at line: " + line);
		    		break;
	    	}
    	}
    	
    	// Printing out the instruction with its line in the code and its PC
    	if (debug)
    	{
	    	for(int i = 0; i < instr.size() - 1; i++)
	    		out.append(instr.get(i) + " ");
	    	
	    	out.append(instr.get(instr.size() - 1) + "	PC: " + (PC - 1) + ", Line: " + line + "\n");
	    	out.append("----------------------------------\n");
    	}
	}
	
	/*
	 * This function is called when we encounter a jump instruction.
	 * 
	 * During the second scan (updateLabels) it will use the tempLabels
	 * from the first scan to run through the instructions to get the updated PC.
	 * 
	 * During the third scan it calls labalCond if we are jumping to a label.
	 * It will call labelJal if we are jumping to a label in a jal instruction or rType if not.
	 * It will call jCondType for all the jcond instructions passing in the register and condCode.
	 * It will also print an error message if we use a jcond function that is not valid with 
	 * the PC & line of the instruction 
	 */
	public static void handleJcond (ArrayList<String> instr)
	{
		// Second scan using tempLabels to go through instructions
		if (updateLabels)
		{
			if (tempLabels.containsKey(instr.get(1)))
			{
				labelCond(instr.get(0), instr.get(1));
				return;
			}
			if (instr.get(0).equals("jal"))
			{
				if (tempLabels.containsKey(instr.get(2)))
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
		// Third scan with the updated labels 
		else
		{
			if (label.containsKey(instr.get(1)))
			{
				labelCond(instr.get(0), instr.get(1));
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
	
	/*
	 * This function is called when we encounter a branch instruction.
	 * 
	 * It will call bCondType for all the bcond instructions passing in the immediate and condCode.
	 * It will also print an error message if we use a bcond function that is not valid with 
	 * the PC & line of the instruction.
	 */
	public static void handleBcond (ArrayList<String> instr)
	{
		// Third scan with the updated labels
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
	
	/*
	 * This function is responsible for finding and adding the hex result
	 * of any jcond instruction to result.
	 * 
	 * The function during the second scan will only update the PC.
	 * 
	 * In the third scan, it will add the binary opCode, condCode and opCodeExt 
	 * and finally it will convert the register seen to binary and add it to the
	 * Stringbuilder binary. Then convert the binary to Hex and add it to result.
	 * 
	 * It also adds the binary & Hex values to be outputed to the console.
	 * 
	 * It also prints error message to the console if the register used starts with
	 * R and that it is within the range 0 - 15 (as our processor has 16 registers)
	 */
	public static void jCondType (String cond, String reg)
	{
		if (!updateLabels)
		{
			StringBuilder binary = new StringBuilder();
			// opCode
			binary.append("0100");
			// condCode
			binary.append(cond);
			// opCodeExt
			binary.append("1100");
			
			// Register Dest
			int r = Integer.parseInt(reg.substring(1));
			if (!reg.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			else if (r < 0 || r > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			else 
			{
				int dest = Integer.parseInt(reg.substring(1));
				binary.append(String.format("%4s", Integer.toBinaryString(dest)).replace(' ', '0'));
			}
			
			PC ++;
			if (debug)
				out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else
			PC++;
	}
	
	/*
	 * This function is responsible for finding and adding the hex result
	 * of any bcond instruction to result.
	 * 
	 * The function during the second scan will only update the PC.
	 * 
	 * In the third scan, it will add the binary opCode, condCode and then 
	 * finally it will convert the immediate to 2's compliment binary and add it to the
	 * Stringbuilder binary. Then convert the binary to Hex and add it to result.
	 * 
	 * It also adds the binary & Hex values to be outputed to the console.
	 * 
	 * It also prints error message to the console if the the immediate used is 
	 * not within the valid range of (-128 & 127) this because we have only 8-bits
	 */
	public static void bCondType (String cond, String disp)
	{
		if (!updateLabels)
		{
			StringBuilder binary = new StringBuilder();
			// opCode
			binary.append("1100");
			// condCode
			binary.append(cond);
			
			// Register Dest
			int dispV = Integer.parseInt(disp);
			if (dispV < -128 || dispV > 127)
				System.out.println("*ERROR* Invalid (out of range) dest in branch instruction, at line:" + line);
			else if (dispV < 0)
				binary.append(String.format("%8s", Integer.toBinaryString(dispV).substring(24)));
			else 
				binary.append(String.format("%8s", Integer.toBinaryString(dispV)).replace(' ', '0'));
			
			PC ++;
			if (debug)
				out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else 
			PC++;
	}
	
	/*
	 * This function is responsible for finding and adding the hex result
	 * of any iType instruction to result.
	 * 
	 * The function during the second scan will only update the PC.
	 * 
	 * In the third scan, it will add the binary opCode and it will convert the 
	 * register seen to binary and add it to the Stringbuilder binary
	 * finally it will convert the immediate to 2's compliment binary and add it to the
	 * Stringbuilder binary. Then convert the binary to Hex and add it to result.
	 * For LSHI, is a special case where the 8-bit immediate is replaced with 
	 * 0000 is to move left or 0001 to move right, followed by the amount to shift
	 * which if it is not with the range 0 - 15 will print an error message to the console.
	 * 
	 * It also adds the binary & Hex values to be outputed to the console.
	 * 
	 * It also prints error message to the console if the register used starts with
	 * R and that it is within the range 0 - 15 (as our processor has 16 registers)
	 * It also prints error message to the console if the the immediate used is 
	 * not within the valid range of (-128 & 127) this because we have only 8-bits
	 */
	public static void iType (String opCode, String immS, String reg)
	{
		if (!updateLabels)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append(opCode); // OP code
			
			// Register Dest
			int r = Integer.parseInt(reg.substring(1));
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
				if ((immV < -128 || immV > 127) && !reg.equals("R1"))
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
			PC ++;
			if (debug)
				out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else 
			PC ++;
	}
	
	/*
	 * This function is responsible for finding and adding the hex result
	 * of any rType instruction to result.
	 * 
	 * The function during the second scan will only update the PC.
	 * 
	 * In the third scan, it will add the binary opCode and it will convert the 
	 * register src  seen to binary and add it to the Stringbuilder binary
	 * finally it will convert the register dst  seen to binary and add it to 
	 * the Stringbuilder binary. Then convert the binary to Hex and add it to result.
	 * 
	 * It also adds the binary & Hex values to be outputed to the console.
	 * 
	 * It also prints error message to the console if the registers used starts with
	 * R and that it is within the range 0 - 15 (as our processor has 16 registers)
	 */
	public static void rType (String opCode, String opCodeEx, String regSrc, String regDest)
	{
		if (!updateLabels)
		{
			StringBuilder binary = new StringBuilder();
			
			binary.append(opCode); // OP code
			
			// Register Src
			int r1 = Integer.parseInt(regSrc.substring(1));
			if (!regSrc.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			if (r1 < 0 || r1 > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			
			int src = Integer.parseInt(regSrc.substring(1));
			binary.append(String.format("%4s", Integer.toBinaryString(src)).replace(' ', '0'));
	
			
			binary.append(opCodeEx); // OP Code Ext
			
			// Register Dest
			int r2 = Integer.parseInt(regDest.substring(1));
			if (!regDest.startsWith("R"))
				System.out.println("*ERROR* Invalid register, at line:" + line);
			if (r2 < 0 || r2 > 15)
				System.out.println("*ERROR* Register out of rage, at line:" + line);
			
			int dest = Integer.parseInt(regDest.substring(1));
			binary.append(String.format("%4s", Integer.toBinaryString(dest)).replace(' ', '0'));
			
			PC ++;
			if (debug)
				out.append(b2hex(binary.toString()) + "  //  " + binary.toString() + "\n");
			result.append(b2hex(binary.toString()) + "\n");
		}
		else
			PC ++;
	}
	
	/*
	 * Handles any conditional Jump to a label.
	 * 
	 * In the third scan, the code will find the PC of the label and convert it to a 16-bit
	 * binary. Then it will split that and use the register R1 to first movi the lower 8-bits 
	 * of the PC by calling the iType movi and then call lui on the upper 8-bits of the PC into R1.
	 * Finally, it will call a jcond R1 to  execute the jump to the correct PC of the label.
	 * 
	 * During the second scan it executes two dummy instruction and a third jcond instruction
	 * This is only to update the PC depending as one jcond label will equal 3 total instructions.
	 */
	public static void labelCond (String cond, String l)
	{
		if(!updateLabels)
		{
			String labelPC = String.format("%16s", Integer.toBinaryString(label.get(l))).replace(' ', '0');
			
			int hiBits = Integer.parseInt(labelPC.substring(0, 8), 2);
			int loBits = Integer.parseInt(labelPC.substring(8, 16), 2);
		
			iType("1101", Integer.toString(loBits), "R1"); // movi lower bits
			iType("1111", Integer.toString(hiBits), "R1"); // lui Upper bits
			
			ArrayList<String> instr = new ArrayList<>();
			instr.add(cond);
			instr.add("R1");
			handleJcond(instr); 		// jcond R1
		}
		else
		{
			// Add dummy instructions in order to get the true PC count
			iType("0000", "0", "R1"); // This represent a fake movi 
			iType("0000", "0", "R1"); // This represent a fake lui
			ArrayList<String> instr = new ArrayList<>();
			instr.add(cond);
			instr.add("R1");
			handleJcond(instr);		// This represents a fake jcond R1
		}
	}
	
	/*
	 * Handles any jal to a label.
	 * 
	 * In the third scan, the code will find the PC of the label and convert it to a 16-bit
	 * binary. Then it will split that and use the register R1 to first movi the lower 8-bits 
	 * of the PC by calling the iType movi and then call lui on the upper 8-bits of the PC into R1.
	 * Finally, it will call a jal ra, R1 to  execute the jump to the correct PC of the label
	 * and the return address ra (which is R2 in our asm code) will be loaded by the processor.
	 * 
	 * During the second scan it executes two dummy instruction and a third jal instruction
	 * This is only to update the PC depending as one jcond label will equal 3 total instructions.
	 */
	public static void labelJal (String jal, String ra, String l)
	{
		if (!updateLabels)
		{
			String labelPC = String.format("%16s", Integer.toBinaryString(label.get(l))).replace(' ', '0');
			
			int hiBits = Integer.parseInt(labelPC.substring(0, 8), 2);
			int loBits = Integer.parseInt(labelPC.substring(8, 16), 2);
			
			iType("1101", Integer.toString(loBits), "R1"); // movi lower bits
			iType("1111", Integer.toString(hiBits), "R1"); // lui Upper bits
			
			ArrayList<String> instr = new ArrayList<>();
			instr.add(jal);
			instr.add(ra);
			instr.add("R1");
			handleJcond(instr);		// jal ra, R1
		}
		else
		{
			// Add dummy instructions in order to get the true PC count
			iType("0000", "0", "R1"); // This represent a fake MOVI 
			iType("0000", "0", "R1"); // This represent a fake LUI
			ArrayList<String> instr = new ArrayList<>();
			instr.add(jal);
			instr.add(ra);
			instr.add("R1");
			handleJcond(instr);  	// This represent a fake jal
		}
	}
	
	/*
	 * Take a binary string and return a 4 digit Hex string of the binary
	 */
	public static String b2hex (String b) 
	{
		int i = Integer.parseInt(b, 2);
		return String.format("%4s", Integer.toString(i, 16)).replace(' ', '0');
	}
	
	/*
	 * Add empty memory "0000" to the result in the .dat file
	 * To fill the memory for the processor to read
	 */
	public static void fill ()
	{
		for (int i = PC; i < memoryLines; i++)
			if (i == memoryLines - 1)
				result.append("0000");
			else 
				result.append("0000" + "\n");
	}
	
	/*
	 * Create & Write the final Hex result into a Hex.dat file in the top directory of the assembler
	 */
	public static void write (String s)
	{
		File PATH_TO_FILE = new File(".\\Hex.dat"); 
		
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