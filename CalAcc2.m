function Aj = CalAcc2(Ai,R,B)
% Calculate the acceleration at location {j} using
% Inputs:
%  Ai=[Ax Ay Az]', acceleration at location {i}, 
%  R= [Rx Ry Rz]', vector R from {i} to {j}, and
%  B = [alpha_x alpha_y alpha_z omega_x omega_y omega_z]' 
%   angular motion of the rigid body.
% Output:
%  Aj=acceleration at {j}


%------------------------------------------------------------------------------
Alpha=B(1:3,:);
Omega=B(4:6,:);

Rn=repmat(R,1,size(Alpha,2));

%tangential component
Tj=cross(Alpha,Rn);

%centripetal component
Cj=cross(Omega,cross(Omega,Rn));

%total
Aj= Ai+Cj+Tj;