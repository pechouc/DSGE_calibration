% derived parameters - shares - etc
#cpie=1+constepinf/100;
#cgamma=1+ctrend/100 ;
#cbeta=1/(1+constebeta/100);

#clandap=cfc;
#cbetabar=cbeta*cgamma^(-csigma);
#cr=cpie/(cbeta*cgamma^(-csigma));
#crk=(cbeta^(-1))*(cgamma^csigma) - (1-ctou);
#cw = (calfa^calfa*(1-calfa)^(1-calfa)/(clandap*crk^calfa))^(1/(1-calfa));
#cikbar=(1-(1-ctou)/cgamma);
#cik=(1-(1-ctou)/cgamma)*cgamma;
#clk=((1-calfa)/calfa)*(crk/cw);
#cky=cfc*(clk)^(calfa-1);
#ciy=cik*cky;
#ccy=1-cg-cik*cky;
#crkky=crk*cky;
#cwhlc=(1/clandaw)*(1-calfa)/calfa*crk*cky/ccy;
#cwly=1-crk*cky;

#conster=(cr-1)*100;
