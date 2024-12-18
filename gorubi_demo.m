clear all;
clc;
A = [1, 2; 3, 4];
b = [1; 2];
c = [1, -1];
d = -10;
e = -5;
f = 0;
g = 10;
h = 5;
i = 1;
j = 2;
k = [1, -2];
l = -5;
mip_setup('gurobi');
model = mip_begin(numel(A), A, b, c, d, e, f, g, h, i, j, k, l);
sense = 'L';
mip_add_var(model);
mip_add_constr