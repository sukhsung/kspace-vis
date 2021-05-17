function [ F ] = eDiff_ScatteringFactor(Element, q)
%Get the scattering factor for a given element (integer value) and a scattering vector.
%
%Scattering vector q is a magnitude without the 2 pi factor
%
%Based on parameterization and values from "Advanced Computing in Electron
%Microscopy" by Dr. Earl J. Kirkland
%
%By Robert Hovden
%Oct 6, 2011

%Added Ta
%Jan 11, 2017 Suk Hyun Sung

    
   
   F1 = zeros(size(q)); F2 = zeros(size(q));
   for i = 1:3 %three parameters
    F1 = F1 + Element.fparams.a(i)./(q.^2+Element.fparams.b(i));
    F2 = F2 + Element.fparams.c(i)*exp(-Element.fparams.d(i)*q.^2);
   end
   
   F = F1 + F2;
   
end
