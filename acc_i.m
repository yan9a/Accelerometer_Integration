% Integration of accelerometers
% Combine several accelerometers attached to a rigid body into 
% an equivalent accelerometer without the need of angular movement information


% Author: Yan Naing Aye
% Date: 2016-October-27
%-------------------------------------------------------------------------
clc;
clear all;
close all;
%-------------------------------------------------------------------------
% Option to test noise 
  TESTNOISE=1;
%-------------------------------------------------------------------------
% Sampling
  Fs=1000; %Sampling rate
  Ts=1/Fs; %Sampling period
  t=(0:Ts:1-Ts); % Time vector for 1 s duration
  n=length(t);
%-------------------------------------------------------------------------
% generate arbitrary angular motions of the rigid body
  %peak values of alpha_x,alpha_y,alpha_z, omega_x,omega_y,omega_z
  Pk=[2 3 4 0.04 0.05 0.06]';

  %frequencies of alpha_x,alpha_y,alpha_z, omega_x,omega_y,omega_z
  F=[7 8 9 10 11 12]';

  %rotational compnents of the rigid body
  B_rotation=GenerateSin(Pk,F,t);
%-------------------------------------------------------------------------
% generate arbitrary liner acceleration at origin
  Aa=[20 30 40]';
  Fa=[4 5 6]';
  A0=GenerateSin(Aa,Fa,t);
%-------------------------------------------------------------------------
% define accelerometer positions
  N_acc=5; %number of accelerometers
  P=zeros(3,N_acc); % positions of accelerometers
  
  P(:,1)=[0 10 -20]';%position of accelerometer 1
  P(:,2)=[-30 30 60]';%position of accelerometer 2
  P(:,3)=[60 -70 80]';%position of accelerometer 3
  P(:,4)=[90 -50 30]';%position of accelerometer 4
  P(:,5)=[40 70 -30]';%position of accelerometer 5
  
  Pi=mean(P')';
%-------------------------------------------------------------------------
%calculate accelerations directly, as references
  A=zeros(3,n,N_acc);%accelerations at respective positions
  for i=1:N_acc
    A(:,:,i)=CalAcc2(A0,P(:,i),B_rotation);
  end
  
  Ai=CalAcc2(A0,Pi,B_rotation);% acceleration at integrated location
%-------------------------------------------------------------------------
if(TESTNOISE)
  %add normally distributed noise signals
  sigma_a=3;%standard deviation of accelerometer
  for i=1:N_acc
    A(:,:,i)=AddWhiteNoise(A(:,:,i),sigma_a);
  end
end
%-------------------------------------------------------------------------
%Calculate using our kinematic equation
  A_cal=zeros(3,n);
  for i=1:N_acc
    A_cal=A_cal+A(:,:,i);
  end
  A_cal=A_cal/N_acc;%average
%-------------------------------------------------------------------------
% Compare the reference acceleration with the calculated one.
  E=A_cal-Ai;%Error
  if(TESTNOISE)
  %standard deviation for x,y,z components
  std_xyz=std(E')';
  %standard deviation for the resultant acceleration
  std_r=norm(std_xyz)
  end
%-------------------------------------------------------------------------
  %Plot x
  D=[Ai(1,:);A_cal(1,:);E(1,:)];
  hFig1 = figure(1);
  set(hFig1, 'Position', [200 100 600 400])
  plot(t,D(1,:),'-rs','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',2)
            
  hold on;
  plot(t,D(2,:),'-go','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',2)

  plot(t,D(3,:),'-bo','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
  hold off;
  grid on;
  legend('Actual','Calculated','Error','Location','northeast')
  title('Signal x');
  xlabel('Time (s)');
  ylabel('Amplitude (mm/s2)');
%-------------------------------------------------------------------------
  %Plot y
  D=[Ai(2,:);A_cal(2,:);E(2,:)];
  hFig2 = figure(2);
  set(hFig2, 'Position', [800 100 600 400])
  plot(t,D(1,:),'-rs','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',2)
            
  hold on;
  plot(t,D(2,:),'-go','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',2)

  plot(t,D(3,:),'-bo','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
  hold off;
  grid on;
  legend('Actual','Calculated','Error','Location','northeast')
  title('Signal y');
  xlabel('Time (s)');
  ylabel('Amplitude (mm/s2)');
%-------------------------------------------------------------------------
  %Plot z
  D=[Ai(3,:);A_cal(3,:);E(3,:)];
  hFig3 = figure(3);
  set(hFig3, 'Position', [200 600 600 400])
  plot(t,D(1,:),'-rs','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',2)
            
  hold on;
  plot(t,D(2,:),'-go','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',2)

  plot(t,D(3,:),'-bo','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
  hold off;
  grid on;
  legend('Actual','Calculated','Error','Location','northeast')
  title('Signal z');
  xlabel('Time (s)');
  ylabel('Amplitude (mm/s2)');
%-------------------------------------------------------------------------
  %Plot 3D
  hFig4 = figure(4);
  set(hFig4, 'Position', [800 600 600 400])
  plot3(Ai(1,:), Ai(2,:), Ai(3,:),'-ro','LineWidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',2);     
  hold on;
  plot3(A_cal(1,:), A_cal(2,:), A_cal(3,:),'-go','LineWidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',2)

  plot3(E(1,:), E(2,:), E(3,:),'-bo','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',2)
  hold off;
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
%-------------------------------------------------------------------------
