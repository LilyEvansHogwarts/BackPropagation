cat A.txt | tail -n +10000 | head -n 20000 >A_10000.txt
cat B.txt | tail -n +10000 | head -n 20000 >B_10000.txt
cat C.txt | tail -n +10000 | head -n 20000 >C_10000.txt
cat D.txt | tail -n +10000 | head -n 20000 >D_10000.txt
cat E.txt | tail -n +10000 | head -n 20000 >E_10000.txt
cat F.txt | tail -n +10000 | head -n 20000 >F_10000.txt
cat G.txt | tail -n +10000 | head -n 20000 >G_10000.txt
cat H.txt | tail -n +10000 | head -n 20000 >H_10000.txt
cat I.txt | tail -n +10000 | head -n 20000 >I_10000.txt
cat J.txt | tail -n +10000 | head -n 20000 >J_10000.txt
cat A_10000.txt B_10000.txt C_10000.txt D_10000.txt E_10000.txt F_10000.txt G_10000.txt H_10000.txt I_10000.txt J_10000.txt > notmnist_large.txt
