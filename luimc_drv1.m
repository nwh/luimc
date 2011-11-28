function luimc_drv1
  
  % inital print statements
  fprintf('\n... luimc tests ...\n');
  
  % settings
  n = 10;  % number of rows
  m1 = 5;  % number of columns less than number of rows
  m2 = 15; % number of columns great than number of rows
  d = .2; % sparse matrix density
  
  % set the rng stream
  RandStream.setDefaultStream(RandStream('mt19937ar','seed',1));
  
  % test empty matrix
  [test_flag rel_err] = luimc_test([]);
  fprintf('empty matrix test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % column vector
  A = rand(n,1);
  [test_flag rel_err] = luimc_test(A);
  fprintf('column vector test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % row vector
  A = rand(1,m2);
  [test_flag rel_err] = luimc_test(A);
  fprintf('row vector test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % square matrix tests
  A = rand(n,n);
  opt = luimc('options');
  
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('square partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('square complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('square rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'none';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('square none test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % test pivot output
  opt.pivot = 'complete';
  opt.perm = 'sparse';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('sparse perm test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.perm = 'dense';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('dense perm test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % skinny matrix tests
  A = rand(n,m1);
  opt = luimc('options');
  
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('skinny partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('skinny complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('skinny rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'none';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('skinny none test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % fat matrix tests
  A = rand(n,m2);
  opt = luimc('options');
  
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('fat partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('fat complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('fat rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'none';
  [test_flag rel_err] = luimc_test(A,opt);
  fprintf('fat none test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  % all zero matrix
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(zeros(n,n),opt);
  fprintf('zeros partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(zeros(n,n),opt);
  fprintf('zeros complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);

  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(zeros(n,n),opt);
  fprintf('zeros rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);

  % all ones matrix
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(ones(n,n),opt);
  fprintf('ones partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(ones(n,n),opt);
  fprintf('ones complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);

  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(ones(n,n),opt);
  fprintf('ones rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);

  % sparse matrix
  opt.pivot = 'partial';
  [test_flag rel_err] = luimc_test(sprand(n,n,d),opt);
  fprintf('sprand partial test: %s, rel_err: %g\n',pf(test_flag),rel_err);
  
  opt.pivot = 'complete';
  [test_flag rel_err] = luimc_test(sprand(n,n,d),opt);
  fprintf('sprand complete test: %s, rel_err: %g\n',pf(test_flag),rel_err);

  opt.pivot = 'rook';
  [test_flag rel_err] = luimc_test(sprand(n,n,d),opt);
  fprintf('sprand rook test: %s, rel_err: %g\n',pf(test_flag),rel_err);

end

function pfstr = pf(x)
  
  if x
    pfstr = 'passed';
  else
    pfstr = 'FAILED';
  end
  
end
