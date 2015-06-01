function X = sum(varargin)
% SUM (overloaded)

Y = varargin{1};
X = Y;
%X.basis = [];
if nargin == 2 && isequal(varargin{2},length(X.dim))
    % smash slices
    X.basis = kron(ones(1,X.dim(end)),speye(prod(X.dim(1:end-1))))*Y.basis;
    X.dim = X.dim(1:end-1);
else
    if nargin == 1
        index = 2;
    else
        index = varargin{2};
    end
    if index > length(X.dim)
        return
    end
    % Permute to the case which we can do fast
    i = 1:length(X.dim);
    p = circshift(i',length(X.dim)-(index))';
    X = permute(X,p);
    % Permute might have squeezed to 2 array
    if length(size(X))==2
        % Expand back last dimension
        X = ndsdpvar(X);
        X.dim = [X.dim 1];
    end
    X = sum(X,length(X.dim));
    if isa(X,'sdpvar')
        X = ndsdpvar(X);
        X.dim = [X.dim 1];
    end
    p = circshift((1:length(X.dim))',-(length(Y.dim)-(index)))';
    X = permute(X,p);
    X.dim = Y.dim;
    X.dim(index) = 1;
end
X.conicinfo = [0 0];
X = clean(X);