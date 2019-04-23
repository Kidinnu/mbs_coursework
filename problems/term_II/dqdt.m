function dq = dqdt(t,q,p)

tilde = @(w) [0 -w(3) w(2); w(3) 0 -w(1); -w(2) -w(1) 0];

% Slice functions:
% get phi array by hinge index
phi  = @(i) q(p.iq(i,1):p.iq(i,1)+p.iq(i,2)-1);
% get dphi array by hinge index
dphi = @(i) q(p.iq(i,1)+p.N:p.iq(i,1)+p.iq(i,2)+p.N-1);

% get Ai0 transform matrices
A0i = zeros(3,3,p.n);
for i=1:p.n
    A0i(:,:,i) = eye(3);
    for a=i:-1:1        
        if p.T(a,i) ~= 1
            A0i(:,:,i) = p.A{a}(phi(a))*A0i(:,:,i);
        end
    end
end

% TODO
% K matrix
K = zeros(3,3,p.n,p.n);
Mass = sum(p.mass);
% Angular velocity 
w      = zeros(3,p.n);
w_in_0 = zeros(3,p.n);
for i=1:p.n
    for j=1:p.n
        w(:,i) = w(:,i) - p.T(j,i)*p.Wr{j}(phi(j),dphi(j)); % + w0 ;
        if i==j
            % Kii in 0 frame
            K(:,:,i,j) = A0i(:,:,i)*p.Kii(:,:,i)*A0i(:,:,i)';
        else            
            if p.T(i,j)~=0 
               % s_i < s_j                
            end
            if p.T(j,i)~=0 
               % s_j < s_i                
            end            
        end
    end
    % Angular velocity in 0 frame
    w_in_0(:,i) = A0i(:,:,i)*w(:,i);
end

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
            pTK(:,i,j) = pTK(:,i,j) + (pT(:,i,k)'*K(:,:,k,j))';
        end
    end
end

%
% A matrix
%
A = zeros(p.N,p.N);
for i=1:p.N
    for j=1:p.N
        for k=1:p.n
            A(i,j) = A(i,j) + pTK(:,i,k)'*pT(:,j,k);
        end
    end
end

% 
% M'
%
Mp = zeros(3,p.n);
for i=1:p.n
    Mp(:,i) = - tilde(w(:,i))*p.Kii(:,:,i)*w(:,i);
    for j=1:p.n
        if p.T(i,j)~=0 
            % s_i < s_j                
        end
        if p.T(j,i)~=0 
            % s_j < s_i                
        end
    end
end

%
% B matrix
% 

for 


end

