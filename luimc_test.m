function [test_flag rel_err] = luimc_test(A,opt,tol)
  
  if nargin < 2 || isempty(opt)
    opt = luimc('options');
  end
  
  if nargin < 3 || isempty(tol)
    tol = opt.rtol;
  end
    
  Amax = max(abs(A(:)));
  
  if isempty(Amax) 
    Amax = 0;
  end

  [L U p q] = luimc(A,opt);
  
  if strcmp(opt.perm,'vector')
    rel_err = norm(A(p,q)-L*U,1) / (Amax + 1);
  else
    rel_err = norm(p*A*q-L*U,1) / (Amax + 1);
  end  
  
  if rel_err <= tol
    test_flag = 1;
  else
    test_flag = 0;
  end
  
end
