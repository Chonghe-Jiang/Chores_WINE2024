function measure = DCA_measure()
% Calculate q
  max_mu = max(mu_new); % enhance computation stability
  temp = exp(mu_new-max_mu);
  q = b*temp/sum(temp); 
  
% Calculate sub differential
% \lambda g(before) - \lambda g(now)
% stepsize count here
measure_new = q + mu_new;
measure = measure_new - measure_old;


