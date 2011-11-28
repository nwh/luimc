%luimc  LU factorization in Matlab code
%
%

function [L U p q] = luimc(A,varargin)
  
  % initial input error check
  if nargin == 0
    error('luimc:no_input','Not enough input arguments.');
  end
  
  % check number of output arguments
  if nargout > 4
    error('luimc:output_args','Too many output arguments.');
  end
  
  % empty matrix
  if isempty(A)
    L = [];
    U = [];
    p = [];
    q = [];
    return;
  end
  
  % process options
  in_parse = inputParser;
  in_parse.addParamValue('pivot','partial',@(x) ismember(x,{'partial','none','complete','rook'}));
  in_parse.addParamValue('perm','vector',@(x) ismember(x,{'vector','sparse','dense'}));
  in_parse.addParamValue('rtol',1e-12,@(x) x>0);
  in_parse.parse(varargin{:});
  opt = in_parse.Results;
  
  % return options structure if desired
  if ischar(A)
    L = opt;
    return;
  end
  
  % get properties of A
  Amax = max(abs(A(:)));
  [n m] = size(A);
  
  % pivot vectors
  p = (1:n)';
  q = (1:m)';
  
  % temp storage
  rt = zeros(m,1); % row temp
  ct = zeros(1,n); % col temp
  t = 0; % scalar temp
  
  for k = 1:min(n-1,m)
    % determine pivot
    [rp cp] = pivot(A,k,n,m,opt.pivot);
    
    % swap row
    if rp ~= k
      t = p(k);
      p(k) = p(rp);
      p(rp) = t;
      rt = A(k,:);
      A(k,:) = A(rp,:);
      A(rp,:) = rt;
    end
    
    % swap col
    if cp ~= k
      t = q(k);
      q(k) = q(cp);
      q(cp) = t;
      ct = A(:,k);
      A(:,k) = A(:,cp);
      A(:,cp) = ct;
    end
    
    % elimintate
    if abs(A(k,k)) > opt.rtol*(Amax)
      rows = (k+1):n;
      cols = (k+1):m;
      A(rows,k) = A(rows,k)/A(k,k);
      A(rows,cols) = A(rows,cols)-A(rows,k)*A(k,cols);
    else
      % handle small small pivot
      
      % if it's the last diagonal we can do nothing
      if k == min(n,m)
        continue
      end
      
      % now we deal with the different pivoting methods
      switch opt.pivot
        case 'complete'
          % in complete pivoting if the pivot is small, there is nothing left
          % to factor.
          break
        case {'partial','rook'}
          % in partial or rook pivoting, we can skip the elimination step if
          % the pivot is small
          continue
        case 'none'
          % with no pivoting, there is nothing to do, but warn the user.  the
          % result may be bad
          warning('luimc:small_pivot','Small diagonal element encountered in no-pivot mode.  Do not trust the result.')
        otherwise
          error('luimc:pivot','Unrecognized pivot method.')
      end
    end
  end
  
  % final column swap if m > n
  if m > n && ismember(opt.pivot,{'complete','rook'})
    % determine col pivot
    [cv ci] = max(abs(A(n,n:m)));
    cp = ci+n-1;
    
    % swap col
    t = q(n);
    q(n) = q(cp);
    q(cp) = t;
    ct = A(:,n);
    A(:,n) = A(:,cp);
    A(:,cp) = ct;
  end
  
  % produce L and U matrices
  % these are sparse if L and U are sparse
  l = min(n,m);
  L = tril(A(1:n,1:l),-1) + speye(n,l);
  U = triu(A(1:l,1:m));
  
  % produce sparse permutation matrices if desired
  if ismember(opt.perm,{'sparse','dense'})
    p = sparse(1:n,p,1);
    q = sparse(q,1:m,1);
  end
  
  % produce dense permutation matrices if desired
  if strcmp(opt.perm,'dense')
    p = full(p);
    q = full(q);
  end
  
end

function [rp cp] = pivot(A,k,n,m,method)
  
  switch method
    case 'none'
      % no pivot
      rp = k;
      cp = k;
    case 'partial'
      % partial pivoting: select largest element in remaining row
      [rv ri] = max(abs(A(k:n,k)));
      rp = ri+k-1;
      cp = k;
    case 'complete'
      % complete pivot: select largest element in remaining matrix
      [cv ri] = max(abs(A(k:n,k:m)));
      [rv ci] = max(cv);
      rp = ri(ci)+k-1;
      cp = ci+k-1;
    case 'rook'
      % rook pivot: select largest element in remaining row and column
      [rv ri] = max(abs(A(k:n,k)));
      [cv ci] = max(abs(A(k,k:m)));
      if rv >= cv
        rp = ri+k-1;
        cp = k;
      else
        rp = k;
        cp = ci+k-1;
      end
    otherwise
      error('luimc:pivot','Unrecognized pivot method.')
  end
  
end
