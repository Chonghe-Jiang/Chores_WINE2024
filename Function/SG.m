function result = SG(n,m,B,D,opts)
%% Notes: The variable is $\mu$.
%% Parameter Setting
outer_epsilon = opts.outer_epsilon; % Tolerance for stopping criterion - outer loop
max_iter = opts.max_iter; % Maximum number of outer iterations
stepsize = opts.stepsize;
epsilon = opts.approx_epsilon;
logD = log(D);
max_logD = max(max(abs(logD)));

%% Initialization
mu = opts.mu0;
b = sum(B);
%% Outer Loop
%% q function has been inplemented inside
% Smoothing based Algorithm
tic
value_list = [];
for iter = 1:max_iter
    max_mu = max(mu); % enhance computation stability
    temp3 = exp(mu-max_mu);
    % q_j(mu)
    q = b*temp3/sum(temp3); % Calculate q

    temp1 = repmat(mu,n,1)-logD;
    max_temp1 = repmat(max(temp1,[],2),1,m);
    temp1 = (temp1 - max_temp1)/epsilon;  % enhance computation stability
    temp1 = exp(temp1);
    temp2 = sum(temp1,2)./(B');
    temp2 = repmat(temp2,1,m);
    temp2 = temp1./temp2; 
    
    gradient = sum(temp2)-q; % Calculate the gradient
    % adptive stepsize
    %ada_stepsize = stepsize+0.01/iter;
    %mu = mu - ada_stepsize*gradient;
    mu = mu - stepsize*gradient;
    measure = norm(gradient./q,inf);
    value_list = [value_list, measure];
    % Stopping criterion - use function value directly
    if measure < outer_epsilon || iter ==max_iter
        % Compute r
        p = sum(B)*exp(mu)/sum(exp(mu));
        pd_matrix = (p./D).^((1/epsilon));
        down = sum(pd_matrix,2);
        temp = (p./D).^((1/epsilon)-1);
        up_1 = sum(temp,2);
        up_2 = max(p./D,[],2);
        up = up_1.*up_2;
        r = max(up./down);
        epsilon_middle = 1- (1/r);
        ratio = epsilon_middle/outer_epsilon;
        break;
    end
end
t = toc;
% Display the final result
% disp(['SGM Loop: ',num2str(iter)])
% disp(['SGM Time ', num2str(t)]);
% disp(['SGM Ratio ',num2str(ratio)]);
%disp(['Dual_SG Stepsize: ',num2str(stepsize)])
result = struct();
result.iter = iter;
result.time = t;
result.mu = mu;
result.gap = value_list;
result.ratio = ratio;

% Plotting the graph
% figure(5)
% plot(value_list, 'o-');
% xlabel('Iteration');
% ylabel('Iterate Measure');
% title('Iterate Gap');
% grid on;