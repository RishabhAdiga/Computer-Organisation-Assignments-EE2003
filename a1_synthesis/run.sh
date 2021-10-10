#!/bin/sh
#
# Compile and run the test bench

export DUT=seq_mult

[ -x "$(command -v iverilog)" ] || { echo "Install iverilog"; exit 1; }
[ -f $DUT.v ] || { echo "Make sure your code is named $DUT.v"; exit 1; }

echo "Compiling sources"
iverilog -DTESTFILE=\"test_in.dat\" -o "$DUT" "${DUT}_tb.v" "$DUT.v" 

./$DUT

# Run Yosys to synthesize 
echo "Running yosys to synthesize cpu."
echo "Ensure that 'synth.ys' lists all the modules needed for the synthesis,"
echo "and that the top module is called 'seq_mult'"
yosys synth.ys

if [ $? != 0 ]; then
    echo "Synthesis failed.  Please check for error messages."
    exit 1;
fi

echo "Compiling sources for post-synthesis simulation"
echo "Ensure all required files listed in program_files_synth.txt"

iverilog -DTESTFILE=\"test_in.dat\" -o seq_mult -c program_file_synth.txt
if [ $? != 0 ]; then
    echo "*** Compilation error! Please fix."
    exit 1;
fi
./$DUT 

cat << EOF

You should see a PASS message and all tests pass.
If any test reports as a FAIL, fix it before submitting.
Once all tests pass, commit the changes into your code,
and push the commit back to the server for evaluation.
EOF
