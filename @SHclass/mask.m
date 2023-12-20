function [x,y,s] = mask(a,idx,orient,vals)

type = num2str(vals{2});

if length(type) == 2

  % admittance

  x = cell(7,1);
  y = cell(7,1);
  s = cell(7,1);
  
  [xp,yp] = fm_draw('Y','Shunt',orient);
  
  x{1} = [-1 1 1 -1 -1];
  y{1} = [0.2 0.2 -0.2 -0.2 0.2];
  s{1} = 'k';

  x{2} = [-1  -1.5];
  y{2} = [0 0];
  s{2} = 'k';

  x{3} = [1 1.2];
  y{3} = [0 0];
  s{3} = 'k';

  x{4} = [1.2 1.2];
  y{4} = [-0.2 0.2];
  s{4} = 'k';

  x{5} = [1.35 1.35];
  y{5} = [-0.125 0.125];
  s{5} = 'k';

  x{6} = [1.5 1.5];
  y{6} = [-0.05 0.05];
  s{6} = 'k';

  x{7} = xp;
  y{7} = 0.3*yp;
  s{7} = 'b';

elseif type > 0

  % condenser

  x = cell(5,1);
  y = cell(5,1);
  s = cell(5,1);
  
  x{1} = -[0 60 60 55 53 55 60 60 55 53]/150;
  y{1} = [0 0 8 16 25 16 8 -8 -16 -25]/50;
  s{1} = 'k';

  x{2} = -[80 80 80 150]/150;
  y{2} = [25 -25 0 0]/50;
  s{2} = 'k';

  x{3} = [0 0];
  y{3} = [-0.4 0.4];
  s{3} = 'k';

  x{4} = [0.075 0.075];
  y{4} = [-0.25 0.25];
  s{4} = 'k';

  x{5} = [0.15 0.15];
  y{5} = [-0.1 0.1];
  s{5} = 'k';
  
elseif type < 0

  % inductance
  
  x = cell(4,1);
  y = cell(4,1);
  s = cell(4,1);

  x{1} = -[0 23 23 24 28 34 40 47 52 55 56 54 51 51 47 46 , ...
           48 51 57 64 70 75 79 79 77 74 74 70 69 71 75 80 87 , ...
           93 99 102 103 101 97 97 94 93 94 98 104 110 117 , ...
           122 125 126 126 150]/150;
  y{1} = [0 0 1 11 19 24 25 23 17 8 -2 -12 -18 -18 -9 1 11 , ...
          19 24 25 23 17 8 -2 -12 -18 -18 -9 1 11 19 24 25 , ...
          23 17 8 -2 -12 -18 -18 -9 1 11 19 24 25 23 17 8 0 0 0]/45;
  s{1} = 'k';

  x{2} = [0 0];
  y{2} = [-0.4 0.4];
  s{2} = 'k';

  x{3} = [0.075 0.075];
  y{3} = [-0.25 0.25];
  s{3} = 'k';

  x{4} = [0.15 0.15];
  y{4} = [-0.1 0.1];
  s{4} = 'k';

end

[x,y] = fm_maskrotate(x,y,orient);
