function [result_SG, t] = SG_mode(mode, n, m, B, D, ratio, opts)

    if mode == 0
        %% epsilon = 1e-2(low) single stage
        opts.outer_epsilon = (1e-2); 
        opts.approx_epsilon = (1e-2)/ratio; 
        opts.stepsize = 8e-3;
        result_SG = SG(n,m,B,D,opts);
        t = result_SG.time;
    elseif mode == 1
        %% epsilon = 1e-2(low); two-stage
        opts.outer_epsilon = (1e-1); 
        opts.approx_epsilon = 1e-1/ratio; 
        opts.stepsize = 6e-2;
        result_SG = SG(n,m,B,D,opts); 
        opts.mu0 = result_SG.mu; 
        t = t + result_SG.time;
        opts.outer_epsilon = (1e-2); 
        opts.approx_epsilon = (1e-2)/ratio; 
        opts.stepsize = 8e-3;
        result_SG = SG(n,m,B,D,opts);
        t = t + result_SG.time;
    else
        %% epsilon = 1e-4(high); multi-stage
        opts.outer_epsilon = (1e-1); 
        opts.approx_epsilon = 1e-1; 
        opts.stepsize = 6e-2;
        result_SG = SG(n,m,B,D,opts); 
        opts.mu0 = result_SG.mu; 
        t = result_SG.time;

        opts.outer_epsilon = (1e-2); 
        opts.approx_epsilon = (1e-2); 
        opts.stepsize = 6e-3;
        result_SG = SG(n,m,B,D,opts); 
        opts.mu0 = result_SG.mu; t = t + result_SG.time;
        
        opts.outer_epsilon = (1e-3); 
        opts.approx_epsilon = (1e-3); 
        opts.stepsize = 8e-4;
        result_SG = SG(n,m,B,D,opts); opts.mu0 = result_SG.mu; t = t + result_SG.time;

        opts.outer_epsilon = (3e-4); 
        opts.approx_epsilon = (3e-4); 
        opts.stepsize = 1e-4;
        result_SG = SG(n,m,B,D,opts); opts.mu0 = result_SG.mu; t = t + result_SG.time;

        opts.outer_epsilon = (1e-4); 
        opts.approx_epsilon = (1e-4)/ratio; 
        opts.stepsize = 6e-5;
        result_SG = SG(n,m,B,D,opts); 
        opts.mu0 = result_SG.mu; 
        t = t + result_SG.time;
    end
end