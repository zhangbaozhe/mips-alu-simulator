main:
	iverilog -o main mips_alu.v mips_alu_tb.v
	echo "The simulation now starts ..."
	vvp main

.PHONY: clean
clean:
	rm -rf main
