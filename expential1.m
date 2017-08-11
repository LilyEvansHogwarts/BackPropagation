function out = expential(x);
x_bar = ~x;
xx_bar = zeros(1,12);
k = 1;
for i = 5:7
    for j = i + 1:7
	xx_bar(1,k) = x_bar(i) & x_bar(j);
    xx_bar(1,k + 1) = x_bar(i) & x(j);
    xx_bar(1,k + 2) = x(i) & x_bar(j);
    xx_bar(1,k + 3) = x(i) & x(j);
    k = k + 4;
    end
end
xxx_bar = zeros(1,8);
for i = 1:4
    xxx_bar(1,2 * i - 1) = xx_bar(1,i) & x_bar(7);
    xxx_bar(1,2 * i) = xx_bar(1,i) & x(7);
end
out = zeros(1,7);
if (x_bar(1) & x_bar(2) & x_bar(3) & x_bar(4))
    out(1) = xxx_bar(1);
    out(2) = ~xxx_bar(1);
    out(3) = out(2);
    out(4) = out(2);
    out(5) = xx_bar(6) | xx_bar(2) | xxx_bar(5);
    out(6) = xx_bar(10) | xx_bar(11);
    out(7) = x(7);
end
if (x_bar(1) & x_bar(2) & x_bar(3) & x(4))
    out(1) = 0;
    out(2) = 1;
    out(3) = 1;
    out(4) = xxx_bar(1);
    out(5) = xx_bar(2) | xx_bar(3) | xx_bar(10);
    out(6) = xxx_bar(2) | xx_bar(11) | xx_bar(4);
    out(7) = xx_bar(6) | xx_bar(7);
end
if(x_bar(1) & x_bar(2) & x(3) & x_bar(4))
    out(1) = 0;
    out(2) = 1;
    out(3) = xx_bar(1) | xx_bar(5);
    out(4) = ~out(3);
    out(5) = out(4);
    out(6) = xxx_bar(4) | xx_bar(3);
    out(7) = xx_bar(1) | xx_bar(6) | xxx_bar(7);
end
if(x_bar(1) & x_bar(2) & x(3) & x(4))
    out(1) = 0;
    out(2) = 1;
    out(3) = 0;
    out(4) = ~xxx_bar(8);
    out(5) = xxx_bar(8);
    out(6) = xx_bar(1) | xxx_bar(8) | xxx_bar(3);
    out(7) = xx_bar(12) | xx_bar(9) | xx_bar(1);
end
if(x_bar(1) & x(2) & x_bar(3) & x_bar(4))
    out(1) = 0;
    out(2) = 1;
    out(3) = 0;
    out(4) = 0;
    out(5) = x_bar(5) | xx_bar(9);
    out(6) = xx_bar(1) | xx_bar(4) | xx_bar(10);
    out(7) = xx_bar(2) | xx_bar(11) | xxx_bar(6);
end
if(x_bar(1) & x(2) & x_bar(3) & x(4))
    out(1) = 0;
    out(2) = x_bar(5) | xx_bar(9);
    out(3) = ~out(2);
    out(4) = out(3);
    out(5) = out(3);
    out(6) = xxx_bar(1) | out(3);
    out(7) = xx_bar(10) | xx_bar(11);
end
if(x_bar(1) & x(2) & x(3) & x_bar(4))
    out(1) = 0;
    out(2) = 0;
    out(3) = 1;
    out(4) = 1;
    out(5) = x_bar(5) | xx_bar(9);
    out(6) = xx_bar(4) | xx_bar(8) | xxx_bar(1);
    out(7) = xx_bar(4) | xx_bar(10) | xx_bar(11);
end
if(x_bar(1) & x(2) & x(3) & x(4))
    out(1) = 0;
    out(2) = 0;
    out(3) = 1;
    out(4) = ~xxx_bar(8);
    out(5) = xxx_bar(8);
    out(6) = xx_bar(1) | xxx_bar(8);
    out(7) = xxx_bar(5) | xx_bar(12) | xx_bar(2);
end