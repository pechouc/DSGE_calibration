// This code replicates the Smets and Wouters (2007) model
// copy van usmodel_hist_dsge_f19_7_71

var  labobs robs pinfobs dy dc dinve dw  ewma epinfma  zcapf rkf kf pkf    cf invef yf labf wf rrf mc zcap rk k pk    c inve y lab pinf w r a  b g qs  ms  spinf sw kpf kp ;    
 
varexo ea eb eg  eqs  em  epinf ew  ;  
 
parameters curvw cgy curvp constelab constepinf constebeta cmaw cmap calfa 
czcap csadjcost ctou csigma chabb ccs cinvs cfc 
cindw cprobw cindp cprobp csigl clandaw 
crdpi crpi crdy cry crr 
crhoa crhoas crhob crhog crhols crhoqs crhoms crhopinf crhow  
ctrend cg 
;

// fixed parameters

ctou=ctou_calib;
clandaw=clandaw_calib;
cg=cg_calib;
curvp=curvp_calib;
curvw=curvw_calib;

// estimated parameters initialisation
calfa=.24;
csigma=1.5;
cfc=1.5;
cgy=0.51;

csadjcost= 6.0144;
chabb=    0.6361;    
cprobw=   0.8087;
csigl=    1.9423;
cprobp=   0.6;
cindw=    0.3243;
cindp=    0.47;
czcap=    0.2696;
crpi=     1.488;
crr=      0.8762;
cry=      0.0593;
crdy=     0.2347;

crhoa=    0.9977;
crhob=    0.5799;
crhog=    0.9957;
crhols=   0.9928;
crhoqs=   0.7165;
crhoas=1; 
crhoms=0;
crhopinf=0;
crhow=0;
cmap = 0;
cmaw  = 0;

model(linear); 
@#include "usmodel_stst.mod"

// flexible economy

  0*(1-calfa)*a + 1*a =  calfa*rkf+(1-calfa)*(wf)  ;
  zcapf =  (1/(czcap/(1-czcap)))* rkf  ;
  rkf =  (wf)+labf-kf ;
  kf =  kpf(-1)+zcapf ;
  invef = (1/(1+cbetabar*cgamma))* (  invef(-1) + cbetabar*cgamma*invef(1)+(1/(cgamma^2*csadjcost))*pkf ) +qs ;
  pkf = -rrf-0*b+(1/((1-chabb/cgamma)/(csigma*(1+chabb/cgamma))))*b +(crk/(crk+(1-ctou)))*rkf(1) +  ((1-ctou)/(crk+(1-ctou)))*pkf(1) ;
  cf = (chabb/cgamma)/(1+chabb/cgamma)*cf(-1) + (1/(1+chabb/cgamma))*cf(+1) +((csigma-1)*cwhlc/(csigma*(1+chabb/cgamma)))*(labf-labf(+1)) - (1-chabb/cgamma)/(csigma*(1+chabb/cgamma))*(rrf+0*b) + b ;
  yf = ccy*cf+ciy*invef+g  +  crkky*zcapf ;
  yf = cfc*( calfa*kf+(1-calfa)*labf +a );
  wf = csigl*labf 	+(1/(1-chabb/cgamma))*cf - (chabb/cgamma)/(1-chabb/cgamma)*cf(-1) ;
  kpf =  (1-cikbar)*kpf(-1)+(cikbar)*invef + (cikbar)*(cgamma^2*csadjcost)*qs ;

// sticky price - wage economy

  mc =  calfa*rk+(1-calfa)*(w) - 1*a - 0*(1-calfa)*a ;
  zcap =  (1/(czcap/(1-czcap)))* rk ;
  rk =  w+lab-k ;
  k =  kp(-1)+zcap ;
  inve = (1/(1+cbetabar*cgamma))* (  inve(-1) + cbetabar*cgamma*inve(1)+(1/(cgamma^2*csadjcost))*pk ) +qs ;
  pk = -r+pinf(1)-0*b +(1/((1-chabb/cgamma)/(csigma*(1+chabb/cgamma))))*b + (crk/(crk+(1-ctou)))*rk(1) +  ((1-ctou)/(crk+(1-ctou)))*pk(1) ;
  c = (chabb/cgamma)/(1+chabb/cgamma)*c(-1) + (1/(1+chabb/cgamma))*c(+1) +((csigma-1)*cwhlc/(csigma*(1+chabb/cgamma)))*(lab-lab(+1)) - (1-chabb/cgamma)/(csigma*(1+chabb/cgamma))*(r-pinf(+1) + 0*b) +b ;
  y = ccy*c+ciy*inve+g  +  1*crkky*zcap ;
  y = cfc*( calfa*k+(1-calfa)*lab +a );
  pinf =  (1/(1+cbetabar*cgamma*cindp)) * ( cbetabar*cgamma*pinf(1) +cindp*pinf(-1) 
   +((1-cprobp)*(1-cbetabar*cgamma*cprobp)/cprobp)/((cfc-1)*curvp+1)*(mc)  )  + spinf ; 
  w =  (1/(1+cbetabar*cgamma))*w(-1)
   +(cbetabar*cgamma/(1+cbetabar*cgamma))*w(1)
   +(cindw/(1+cbetabar*cgamma))*pinf(-1)
   -(1+cbetabar*cgamma*cindw)/(1+cbetabar*cgamma)*pinf
   +(cbetabar*cgamma)/(1+cbetabar*cgamma)*pinf(1)
   +(1-cprobw)*(1-cbetabar*cgamma*cprobw)/((1+cbetabar*cgamma)*cprobw)*(1/((clandaw-1)*curvw+1))*
   (csigl*lab + (1/(1-chabb/cgamma))*c - ((chabb/cgamma)/(1-chabb/cgamma))*c(-1) -w) 
   + 1*sw ;
  r =  crpi*(1-crr)*pinf
   +cry*(1-crr)*(y-yf)     
   +crdy*(y-yf-y(-1)+yf(-1))
   +crr*r(-1)
   +ms  ;
  a = crhoa*a(-1)  + ea;
  b = crhob*b(-1) + eb;
  g = crhog*(g(-1)) + eg + cgy*ea;
  qs = crhoqs*qs(-1) + eqs;
  ms = crhoms*ms(-1) + em;
  spinf = crhopinf*spinf(-1) + epinfma - cmap*epinfma(-1);
      epinfma=epinf;
  sw = crhow*sw(-1) + ewma - cmaw*ewma(-1) ;
      ewma=ew; 
  kp =  (1-cikbar)*kp(-1)+cikbar*inve + cikbar*cgamma^2*csadjcost*qs ;

// measurement equations

  dy=y-y(-1)+ctrend;
  dc=c-c(-1)+ctrend;
  dinve=inve-inve(-1)+ctrend;
  dw=w-w(-1)+ctrend;
  pinfobs = 1*(pinf) + constepinf;
  robs =    1*(r) + conster;
  labobs = lab + constelab;

end; 

shocks;
var ea;
stderr 0.4618;
var eb;
stderr 1.8513;
var eg;
stderr 0.6090;
var eqs;
stderr 0.6017;
var em;
stderr 0.2397;
var epinf;
stderr 0.1455;
var ew;
stderr 0.2089;
end;



estimated_params;
stderr ea,0.4618,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr eb,0.1818513,0.025,5,INV_GAMMA_PDF,0.1,2;
stderr eg,0.6090,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr eqs,0.46017,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr em,0.2397,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr epinf,0.1455,0.01,3,INV_GAMMA_PDF,0.1,2;
stderr ew,0.2089,0.01,3,INV_GAMMA_PDF,0.1,2;
crhoa,.9676 ,.01,.9999,BETA_PDF,0.5,0.20;
crhob,.2703,.01,.9999,BETA_PDF,0.5,0.20;
crhog,.9930,.01,.9999,BETA_PDF,0.5,0.20;
crhoqs,.5724,.01,.9999,BETA_PDF,0.5,0.20;
crhoms,.3,.01,.9999,BETA_PDF,0.5,0.20;
crhopinf,.8692,.01,.9999,BETA_PDF,0.5,0.20;
crhow,.9546,.001,.9999,BETA_PDF,0.5,0.20;
cmap,.7652,0.01,.9999,BETA_PDF,0.5,0.2;
cmaw,.8936,0.01,.9999,BETA_PDF,0.5,0.2;
csadjcost,6.3325,2,15,NORMAL_PDF,4,1.5;
csigma,1.2312,0.25,3,NORMAL_PDF,1.50,0.375;
chabb,0.7205,0.001,0.99,BETA_PDF,0.7,0.1;
cprobw,0.7937,0.3,0.95,BETA_PDF,0.5,0.1;
csigl,2.8401,0.25,10,NORMAL_PDF,2,0.75;
cprobp,0.7813,0.5,0.95,BETA_PDF,0.5,0.10;
cindw,0.4425,0.01,0.99,BETA_PDF,0.5,0.15;
cindp,0.3291,0.01,0.99,BETA_PDF,0.5,0.15;
czcap,0.2648,0.01,1,BETA_PDF,0.5,0.15;
cfc,1.4672,1.0,3,NORMAL_PDF,1.25,0.125;
crpi,1.7985,1.0,3,NORMAL_PDF,1.5,0.25;
crr,0.8258,0.5,0.975,BETA_PDF,0.75,0.10;
cry,0.0893,0.001,0.5,NORMAL_PDF,0.125,0.05;
crdy,0.2239,0.001,0.5,NORMAL_PDF,0.125,0.05;
constepinf,0.7,0.1,2.0,GAMMA_PDF,0.625,0.1;//20;
constebeta,0.7420,0.01,2.0,GAMMA_PDF,0.25,0.1;//0.20;
constelab,1.2918,-10.0,10.0,NORMAL_PDF,0.0,2.0;
ctrend,0.3982,0.1,0.8,NORMAL_PDF,0.4,0.10;
cgy,0.05,0.01,2.0,NORMAL_PDF,0.5,0.25;
calfa,0.24,0.01,1.0,NORMAL_PDF,0.3,0.05;
end;



estimated_params_init;
stderr ea,0.4618;
stderr eb,0.1818513;
stderr eg,0.6090;
stderr eqs,0.46017;
stderr em,0.2397;
stderr epinf,0.1455;
stderr ew,0.2089;
crhoa,.9676;
crhob,.2703;
crhog,.9930;
crhoqs,.5724;
crhoms,.3;
crhopinf,.8692;
crhow,.9546;
cmap,.7652;
cmaw,.8936;
csadjcost,6.3325;
csigma,1.2312;
chabb,0.7205;
cprobw,0.7937;
csigl,2.8401;
cprobp,0.7813;
cindw,0.4425;
cindp,0.3291;
czcap,0.2648;
cfc,1.4672;
crpi,1.7985;
crr,0.8258;
cry,0.0893;
crdy,0.2239;
constepinf,0.7;
constebeta,0.7420;
constelab,1.2918;
ctrend,0.3982;
cgy,0.05;
calfa,0.24;
end;

varobs dy dc dinve labobs pinfobs dw robs;

if exist('I') == 0
    I = 5
end

for i = 1:I;

    file_name = ['z_simul_', num2str(i), '.mat']
    eval(['load z_simul_', num2str(i), '.mat']);
    eval(['save temp.mat dy dc dinve labobs pinfobs dw robs']);
    
    if exist('estimation_method_short') == 0
        estimation_method_short = 'MLE';
    end
    
    if strcmp(estimation_method_short, 'MLE') == 1
        estimation(
            datafile=temp, 
            first_obs=71, 
            presample=4,
            lik_init=2, 
            mh_replic=0, 
            nograph,
            silent_optimizer
        );
    
        if i == 1
            output = oo_.posterior_mode.parameters; % Getting the structure with posterior modes and names
            output = rows2vars(struct2table(output)); % Transforming into a table object and transposing
            column_name = ['mode_', num2str(i)]; % Name of the new column to add
            output.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            output_bis = oo_.posterior_mode.shocks_std; % Getting the structure with posterior modes and names
            output_bis = rows2vars(struct2table(output_bis)); % Transforming into a table object and transposing
            output_bis.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            output = [output; output_bis];
        
        else
            temp = oo_.posterior_mode.parameters; % Getting the structure with posterior modes and names
            temp = rows2vars(struct2table(temp)); % Transforming into a table object and transposing
            column_name = ['mode_', num2str(i)]; % Name of the new column to add
            temp.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            temp_bis = oo_.posterior_mode.shocks_std; % Getting the structure with posterior modes and names
            temp_bis = rows2vars(struct2table(temp_bis)); % Transforming into a table object and transposing
            temp_bis.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            temp = [temp; temp_bis];
        
            output = join(output, temp); % Merging the temp table onto the output table
        
        end
    
    elseif strcmp(estimation_method_short, 'MH') == 1
        estimation(
            datafile=temp, 
            mode_compute=4,
            first_obs=71, 
            presample=4, 
            lik_init=2, 
            prefilter=0, 
            mh_replic=10000,
            mh_nblocks=2, 
            mh_jscale=0.20, 
            mh_drop=0.2,
            optim=('MaxIter',200),
            nograph,
            posterior_nograph,
            silent_optimizer,
            nodisplay
        );
    
        if i == 1
            output = oo_.posterior_mean.parameters; % Getting the structure with posterior means and names
            output = rows2vars(struct2table(output)); % Transforming into a table object and transposing
            column_name = ['mean_', num2str(i)]; % Name of the new column to add
            output.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            output_bis = oo_.posterior_mean.shocks_std; % Getting the structure with posterior means and names
            output_bis = rows2vars(struct2table(output_bis)); % Transforming into a table object and transposing
            output_bis.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            output = [output; output_bis];
    
        else
            temp = oo_.posterior_mean.parameters; % Getting the structure with posterior means and names
            temp = rows2vars(struct2table(temp)); % Transforming into a table object and transposing
            column_name = ['mean_', num2str(i)]; % Name of the new column to add
            temp.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            temp_bis = oo_.posterior_mean.shocks_std; % Getting the structure with posterior means and names
            temp_bis = rows2vars(struct2table(temp_bis)); % Transforming into a table object and transposing
            temp_bis.Properties.VariableNames = {'param_name' column_name}; % Renaming columns
        
            temp = [temp; temp_bis];
    
            output = join(output, temp); % Merging the temp table onto the output table
    
        end
    
    else
        error('Estimation method can only be "MLE" for maximum likelihood or "MH" for Metropolis-Hastings.')
    end

end;

eval('delete temp.mat')