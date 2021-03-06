% ODE function 
function dq = ode_dqdt(t,q,p)
% t - time
% q - state
% p - parameters

% Net force column vectros on each body in 0 frame
Fnet  = getForces(t,q,p);
% Net torques column vectros on each body in body frame
Mnet  = getTorques(t,q,p);

% Slice functions:
% get phi array by hinge index
phi  = @(i) q(p.iq(i,1) : p.iq(i,1)+p.iq(i,2)-1);
% get dphi array by hinge index
dphi = @(i) q(p.iq(i,1)+p.N : p.iq(i,1)+p.iq(i,2)+p.N-1);

% get A0i transform matrices (i body to 0)
A0i = zeros(3,3,p.n);
for i=1:p.n
    A0i(:,:,i) = eye(3);
    for a=i:-1:1        
        if p.T(a,i) ~= 0
            A0i(:,:,i) = p.A{a}(phi(a))*A0i(:,:,i);
        end
    end
end

% K matrix
K = zeros(3,3,p.n,p.n);
Mass = sum(p.mass);

% Angular velocity 
w      = zeros(3,p.n);

%w_in_0 = zeros(3,p.n);
for i=1:p.n
    for j=1:p.n
        w(:,i) = w(:,i) - A0i(:,:,j)*(p.T(j,i)*p.Wr{j}(phi(j),dphi(j))); % + w0 ;
        if i==j
            % Kii in 0 frame
            K(:,:,i,j) = A0i(:,:,i)*p.Kii(:,:,i)*A0i(:,:,i)';
        else            
            if p.T(i,j)~=0
               % s_i < s_j 
               K(:,:,i,j) = Mass*((A0i(:,:,j)*p.b(:,j))'*(A0i(:,:,i)*p.d(:,i,j))*eye(3)-A0i(:,:,j)*p.b(:,j)*(A0i(:,:,i)*p.d(:,i,j))');
            end
            if p.T(j,i)~=0 
               % s_j < s_i                
               K(:,:,i,j) = Mass*((A0i(:,:,j)*p.d(:,j,i))'*(A0i(:,:,i)*p.b(:,i))*eye(3)-A0i(:,:,j)*p.d(:,j,i)*(A0i(:,:,i)*p.b(:,i))');
            end            
        end
    end
    % Angular velocity in 0 frame
    % w_in_0(:,i) = A0i(:,:,i)*w(:,i);
end

% p*T matrix
pT = zeros(3,p.N,p.n);
i = 1;
for ib=1:p.n
    % to 0 frame
    pblock = A0i(:,:,ib)*p.p{ib}(phi(ib));
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
    Mp(:,i) = - tilde(w(:,i))*K(:,:,i,i)*w(:,i);
    for j=1:p.n
        if p.T(i,j)~=0 && i~=j 
            % s_i < s_j           
            Mp(:,i) = Mp(:,i) - Mass*cross(A0i(:,:,i)*p.d(:,i,j),cross(w(:,j),cross(w(:,j),A0i(:,:,j)*p.b(:,j))));
        end
        if p.T(i,j)~=0
            % s_i < =  s_j           
            Mp(:,i) = Mp(:,i) - cross(A0i(:,:,i)*p.d(:,i,j),Fnet(:,j));
        end
        if p.T(j,i)~=0 && i~=j 
            % s_j < s_i
            Mp(:,i) = Mp(:,i) - Mass*cross(A0i(:,:,i)*p.b(:,i),cross(w(:,j),cross(w(:,j),A0i(:,:,j)*p.d(:,j,i))));
        end        
    end
end

%
% B matrix
% 
pTMpM = zeros(p.N,1);
for i=1:p.N
    for j=1:p.n 
        pTMpM(i) = pTMpM(i) - dot(pT(:,i,j),Mp(:,j)+A0i(:,:,j)*Mnet(:,j));
    end
end
% f
f   = zeros(3,p.n);
for i=1:p.n
   f(:,i) = cross(w(:,i),A0i(:,:,i)*p.Wr{i}(phi(i),dphi(i))) + A0i(:,:,i)*p.pw{i}(phi(i),dphi(i));
end
% TTf
TTf = zeros(3,p.n);
for i=1:p.n
    for j=1:p.n
        TTf(:,i) = TTf(:,i) + p.T(j,i)*f(:,j); % -w0*1n
    end
end
% pTKTTf
pTKTTf = zeros(p.N,1);
for i=1:p.N
    for j=1:p.n
        pTKTTf(i) = pTKTTf(i) - dot(pTK(:,i,j),TTf(:,j)); 
    end
end
% B
B = pTKTTf + pTMpM;
%
% Solve Ax=B for x
%
d2phi = A\B;

dq = [q(p.N+1:2*p.N);d2phi];

end

