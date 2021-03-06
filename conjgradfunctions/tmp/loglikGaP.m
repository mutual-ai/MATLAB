function f=loglikGaP(x, varargin)
% f=loglikGaP(x, varargin)
% complete log likellihood of the GaP model 
% Vxt = varargin{1};      %data
% sigpsf = varargin{2};  %std deviation of the PSF gaussian approx
% alpha = varargin{3}; %parameters of the Gamma prior on the blinking
% beta = varargin{4}; %parameters of the Gamma prior on the blinking
% peval = varargin{5}; %parameters
% x(1:end-2*peval.ncomp) is Hkt


Vxt = varargin{1};      %data
sigpsf = varargin{2};  %std deviation of the PSF gaussian approx
alpha = varargin{3}; %parameters of the Gamma prior on the blinking
beta = varargin{4}; %parameters of the Gamma prior on the blinking
peval = varargin{5}; %parameters

% % % Hkt_linear=x(1:end-peval.ncomp*2); % intensities
% % % cx=x(end-peval.ncomp*2+1:end-peval.ncomp); %x-coordinates of the centers
% % % cy=x(end-peval.ncomp+1:end); % y-coordinates of the centers

% % %
Hkt_linear=x; % intensities
cx=varargin{6};
cy=varargin{7};
% % %
sigpsf_vec=repmat(sigpsf,peval.ncomp,1); %all psfs same sigma
cxy_vec=[cx'+.5, cy'+.5];
a_vec=1./(sigpsf_vec*2*pi); % all normalised to 1

Hkt=reshape(Hkt_linear, peval.ncomp, peval.nt);
% generate PSFs from given parameters:
Wxkpix=gauss2dmultislice([peval.nx, peval.ny, peval.ncomp], cxy_vec, sigpsf_vec, a_vec);
Wxkpix=normalizePSF(Wxkpix); %normalize PSFs to 1
Wxk=reshape(Wxkpix,peval.nx*peval.ny, peval.ncomp);
% add the background component (just for muttiplication - in the gradient it should not matter): 
[Wxkbg,Hktbg]=addbg(Wxk, Hkt, peval.bg);
P=Wxkbg*Hktbg; %current approximation

t1=Vxt.*log(P) - P;
%%%t2=(alpha-1)*log(Hkt)-beta*Hkt;

f=sum(t1(:));%%%+sum(t2(:));
end
function Wnorm=normalizePSF(W)
sw=size(W);
Wr=reshape(W, sw(1)*sw(2),sw(3));
q=squeeze(sum(Wr,1));
Wrnorm=Wr./repmat(q,sw(1)*sw(2),1);
Wnorm=reshape(Wrnorm,sw(1), sw(2), sw(3));
end
