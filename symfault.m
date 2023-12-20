% The program symfault is designed for the balanced three-phase
% fault analysis of a power system network. The program requires
% the bus impedance matrix Zbus. Zbus may be defined by the
% user, obtained by the inversion of Ybus or it may be
% determined either from the function Zbus = zbuild(zdata)
% or the function Zbus = zbuildpi(linedata, gendata, yload).
% The program prompts the user to enter the faulted bus number
% and the fault impedance Zf. The prefault bus voltages are
% defined by the reserved Vector V. The array V may be defined or
% it is returned from the power flow programs lfgauss, lfnewton,
% decouple or perturb. If V does not exist the prefault bus voltages
% are automatically set to 1.0 per unit. The program obtains the
% total fault current, the postfault bus voltages and line currents.
%
% Copyright (C) 1998 H. Saadat

function symfault( )

fm_var
global filedata

solvepowerflow
fm_disp(['Initial PF solution will be used as ', ...
     'base case solution.'])

if isempty(Fault.con)
  fm_disp('No fault found', 2) 
  return
end
  

% Short Circuit report
% --------------------------------------------------------------------

fm_disp
fm_disp('Writing the report file...')

% initialization of report outputs
% --------------------------------------------------------------------

Header = cell(0);
Matrix = cell(0);
Cols = cell(0);
Rows = cell(0);




 
%Header{1,1}{1,1} = ' Short Circuit REPORT';
%Header{1,1}{2,1} = 'h1 lin2 Short Circuit REPORT';
%Matrix{2,1}(1,1) = 38;
%Matrix{2,1}(1,2) = 39;
%Matrix{2,1}(2,1)= 1;
%Matrix{2,1}(2,2)=  39;
%Matrix{2,1}(3,1)= 4;
%Matrix{2,1}(3,2)= 5;
%Matrix{2,1}(4,1)= 44;
%Matrix{2,1}(4,2)= 54;

%Rows{2,1} {1,1}= ' bus1 ';  
%Rows{2,1} {2,1}= ' bus2 ';  
%Rows{2,1} {3,1}= ' bus3 ';  
%Rows{2,1} {4,1}= ' bus3 ';  

%Cols{2,1}{1,1} = ' bus';  %row Lable 
%Cols{2,1}{1,2} = 'Col1';
%Cols{2,1}{1,3} = 'Col2';

%Rows{1,1} {2,1}= 'row1';
 
%Header{2,1}{1,1} = ' ';
%Header{2,1}{2,1} = 'h1 Short Circuit REPORT';
%Header{2,1}{3,1} = 'h1 lin2 Short Circuit REPORT';



%Cols{2,1} {1,1}= ' col2';
%Rows{2,1}{1,1} = ' row2';
%Header{2,1}{1,1} = 'h2';
%Matrix{2,1} = 2;



% general header
% --------------------------------------------------------------------
Header{1,1}{1,1} = '';
Header{1,1}{2,1} = ' ';
Header{1,1}{3,1} = ['P S A T  ',Settings.version];
Header{1,1}{4,1} = ' ';
Header{1,1}{5,1} = 'Three-phase balanced fault analysis ';
Header{1,1}{6,1} = ' ';


nh = 1;
   
zdata = Line.con;
  
[Zbus, zdata]= zbuildpi(zdata, Syn.con);
  
nl = zdata(:,1); 
nr = zdata(:,2); 
R = zdata(:,3);
X = zdata(:,4);
nc = length(zdata(1,:));
if nc > 4
  BC = zdata(:,11);
elseif nc == 4
  BC = zeros(length(zdata(:,1)), 1);
end
ZB = R + j*X;

nbr = length(zdata(:,1)); 
nbus = max(max(nl), max(nr));
if exist('V') == 1
  if length(V) == nbus
    V0 = V;
  end
else
  V0 = ones(nbus, 1) + j*zeros(nbus, 1);
end


% report ----------------------------------------------------

for ff = 1:Fault.n

  nh = nh + 1;
  nf = Fault.bus(ff);    
  %fprintf('Faulted bus = %s \n', Bus.names{nf})    
  
  %Matrix{1,1}  =  5 ;
  
  %Matrix{1,1} = sprintf('Faulted bus = %s \n', Bus.names{nf})    

  fprintf('\n Fault Impedance Zf = R + j*X = ')
  Zf = Fault.con(ff,7) + j*Fault.con(ff,8);
  fprintf('%8.5f + j(%8.5f)  \n', real(Zf), imag(Zf))
  fprintf('Balanced three-phase fault at bus No. %g\n', nf)

  Header{nh,1}{1,1} = sprintf('Balanced three-phase fault at bus No. %g\n', nf);
  Header{nh,1}{2,1} = sprintf('Fault Impedance Zf = R + j*X =%8.5f + j(%8.5f)  \n ', real(Zf), imag(Zf) )
  
  If = V0(nf)/(Zf + Zbus(nf, nf));
  Ifm = abs(If); 
  Ifmang = angle(If)*180/pi;

  Header{nh,1}{3,1} = sprintf('Total fault current = %8.4f per unit \n\n', Ifm);
  Header{nh,1}{4,1} = sprintf('Bus Voltages during fault in per unit ');
  Cols{nh,1}{1,1}   = sprintf('   Bus');
  Cols{nh,1}{1,2}   = sprintf('Voltage');
  Cols{nh,1}{1,3}   = sprintf('Angle');

  Cols{nh,1}{2,1}   = sprintf('   No.');
  Cols{nh,1}{2,2}   = sprintf('[pu]');
  Cols{nh,1}{2,3}   = sprintf('[degrees]');

  for n = 1:nbus
    if n == nf
      Vf(nf) = V0(nf)*Zf/(Zf + Zbus(nf,nf));
      Vfm = abs(Vf(nf)); 
      angv = angle(Vf(nf))*180/pi;
    else
      Vf(n) = V0(n) - V0(n)*Zbus(n,nf)/(Zf + Zbus(nf,nf));
      Vfm = abs(Vf(n)); 
      angv=angle(Vf(n))*180/pi;
    end

    Rows{nh,1} {n,1}= sprintf('   %s',  Bus.names{n})
    fprintf('   %s',  Bus.names{n}), fprintf('%13.4f', Vfm),fprintf('%13.4f\n', angv)
    Matrix{nh,1}(n,1)=  Vfm;
    Matrix{nh,1}(n,2)=  angv;
  end



  
  fprintf(' \n \n')
  Header{nh+1,1}{1,1} = sprintf('\n\n\nLine currents for fault at bus No.  %g', nf);
   
  fprintf('     From      To     Current     Angle\n');
  fprintf('     Bus       Bus    Magnitude   degrees\n');

  Cols{nh+1,1}{1,1}   = sprintf(' From ');
  Cols{nh+1,1}{1,2}   = sprintf(' To');
  Cols{nh+1,1}{1,3}   = sprintf('Current');
  Cols{nh+1,1}{1,4}   = sprintf('Angle');

  Cols{nh+1,1}{2,1}   = sprintf(' Bus');
  Cols{nh+1,1}{2,2}   = sprintf(' Bus');
  Cols{nh+1,1}{2,3}   = sprintf('Magnitude');
  Cols{nh+1,1}{2,4}   = sprintf('degrees');


  for n = 1:nbus

    %Ign=0;
    for I = 1:nbr
      if nl(I) == n || nr(I) == n
        if nl(I) == n 
          k = nr(I);
        elseif nr(I) == n
          k = nl(I);
        end
        if k==0
          Ink = (V0(n) - Vf(n))/ZB(I);
          Inkm = abs(Ink);
          th = angle(Ink);
          %if th <= 0
          if real(Ink) > 0
            fprintf('      G   '), fprintf('%s',Bus.names{n}), fprintf('%12.4f', Inkm)
            fprintf('%12.4f\n', th*180/pi)
            Rows{nh+1,1} {n,1}= sprintf('   G ' );
            Rows{nh+1,1} {n,2}= sprintf(' %s',  Bus.names{n});
            Matrix{nh+1,1}(n,1)=  Inkm;
            Matrix{nh+1,1}(n,2)=  th*180/pi;

          elseif real(Ink) ==0 && imag(Ink) < 0
            fprintf('      G   '), fprintf('%s',Bus.names{n}), fprintf('%12.4f', Inkm)
            fprintf('%12.4f\n', th*180/pi)
            Rows{nh+1,1} {n,1}= sprintf('   G ' );
            Rows{nh+1,1} {n,2}= sprintf(' %s',  Bus.names{n});
            Matrix{nh+1,1}(n,1)=  Inkm;
            Matrix{nh+1,1}(n,2)=  th*180/pi;            
          end
          Ign = Ink;
        elseif k ~= 0
          Ink = (Vf(n) - Vf(k))/ZB(I)+BC(I)*Vf(n);
          %Ink = (Vf(n) - Vf(k))/ZB(I);
          Inkm = abs(Ink); th=angle(Ink);
          %Ign=Ign+Ink;
          %if th <= 0
          if real(Ink) > 0
            fprintf('%s', Bus.names{n})
            fprintf('%10g', k),
            fprintf('%12.4f', Inkm)
            fprintf('%12.4f\n', th*180/pi)

            Rows{nh+1,1} {n,1}= sprintf(' %s',  Bus.names{n});
            Rows{nh+1,1} {n,2}= sprintf(' %s',  Bus.names{k});
            Matrix{nh+1,1}(n,1)=  Inkm;
            Matrix{nh+1,1}(n,2)=  th*180/pi;

          elseif real(Ink) ==0 && imag(Ink) < 0
            fprintf('%s', Bus.names{n})
            fprintf('%10g', k),
            fprintf('%12.4f', Inkm)
            fprintf('%12.4f\n', th*180/pi)

            Rows{nh+1,1} {n,1}= sprintf(' %s',  Bus.names{n});
            Rows{nh+1,1} {n,2}= sprintf(' %s',  Bus.names{k});
            Matrix{nh+1,1}(n,1)=  Inkm;
            Matrix{nh+1,1}(n,2)=  th*180/pi;

          end
        end
      end
    end
    
    if n == nf  % show Fault Current
      fprintf('%s',Bus.names{n})
      fprintf('         F')
      fprintf('%12.4f', Ifm)
      fprintf('%12.4f\n', Ifmang)

      Rows{nh+1,1} {n,1}= sprintf(' %s',  Bus.names{n});
      Rows{nh+1,1} {n,2}= sprintf('   F ' );
      Matrix{nh+1,1}(n,1)=  Ifm;
      Matrix{nh+1,1}(n,2)=  Ifmang;

    end
  end
  resp=0;
  %while strcmp(resp, 'n')~=1 && strcmp(resp, 'N')~=1 && strcmp(resp, 'y')~=1 && strcmp(resp, 'Y')~=1
  %resp = input('Another fault location? Enter ''y'' or ''n'' within single quote -> ');
  %if strcmp(resp, 'n')~=1 && strcmp(resp, 'N')~=1 && strcmp(resp, 'y')~=1 && strcmp(resp, 'Y')~=1
  %fprintf('\n Incorrect reply, try again \n\n'), end
  %end
  %if resp == 'y' || resp == 'Y'
  nf = 999;
  %else
  ff = 0;
  %end
  
end   % end for while


% determining the output file name
filename = [fm_filenum(Settings.export),['.',Settings.export]];
fm_disp(['Finished "',filename,'"']),


% writing data...
% --------------------------------------------------------------------
%Cols=['1'];
%Rows =['1'];
fm_write(Matrix,Header,Cols,Rows)


% ---------------------------------------------------
function solvepowerflow

global Settings Varname

fm_disp('Solve base case power flow...')
varname_old = Varname.idx;
Settings.show = 0;
fm_set('lf')
Settings.show = 1;
if ~isempty(varname_old)
  Varname.idx = varname_old;
end
