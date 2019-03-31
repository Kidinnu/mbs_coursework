function dq = dqdt(t,q,p)

% Slice functions:
% get phi array by hinge index
phi  = @(i) q(p.iq(i,1):p.iq(i,1)+p.iq(i,2)-1);
% get dphi array by hinge index
dphi = @(i) q(p.iq(i,1)+p.N:p.iq(i,1)+p.iq(i,2)+p.N-1);

% K matrix
K = zeros(3,3,p.n,p.n);
% TODO
%
%
% 

% p*T matrix
pT = zeros(3,p.N,p.n);
i = 1;
for ib=1:p.n
    pblock = p.p{ib}(phi(ib));
    for ia = 1:p.na(ib)
        for k = 1:p.n
            pT(:,i,k) = pblock(:,ia)*p.T(ib,k);                    
        end
        i = i + 1; 
    end    
end

% p*T*K matrix
% TODO - Check
pTK = zeros(3,p.N,p.n);
for i=1:p.N
    for j=1:p.n
        for k=1:p.n
            pTK(:,i,j) = pTK(:,i,j) + pT(:,i,k)'*K(:,:,k,j);
        end
    end
end

% A matrix
% TODO - Check
A = zeros(p.N,p.N);
for i=1:p.N
    for j=1:p.N
        for k=1:p.n
            A(i,j) = A(i,j) + pTK(:,i,k)*pT(:,j,k);
        end
    end
end
            



end

