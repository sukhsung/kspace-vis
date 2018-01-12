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
   [a, b, c, d] =  getParameters(Element);
   
   F1 = zeros(size(q)); F2 = zeros(size(q));
   for i = 1:3 %three parameters
    F1 = F1 + a(i)./(q.^2+b(i));
    F2 = F2 + c(i)*exp(-d(i)*q.^2);
   end
   
   F = F1 + F2;
   
end

function [a, b, c, d]  = getParameters(Element)
  switch Element
        case 5 %B 
          a(1) = 1.25716066*10^-1; b(1) = 1.48258830*10^-1; a(2) = 1.73314452*10^-1; b(2) = 1.48257216*10^-1;
          a(3) = 1.84774811*10^-1; b(3) = 3.34227311*10^-0; c(1) = 1.95250221*10^-1; d(1) = 1.97339463*10^-0;
          c(2) = 5.29642075*10^-1; d(2) = 5.70035553*10^-0; c(3) = 1.08230500*10^-3; d(3) = 5.64857237*10^-2;          
        case 6 %C
          a(1) = 2.12080767*10^-1; b(1) = 2.08605417*10^-1; a(2) = 1.99811865*10^-1; b(2) = 2.08610186*10^-1;
          a(3) = 1.68254385*10^-1; b(3) = 5.57870773*10^-0; c(1) = 1.42048360*10^-1; d(1) = 1.33311887*10^-0;
          c(2) = 3.63830672*10^-1; d(2) = 3.80800263*10^-0; c(3) = 8.35012044*10^-4; d(3) = 4.03982620*10^-2;
        case 7 %N
          a(1) = 5.33015554*10^-1; b(1) = 2.90952515*10^-1; a(2) = 5.29008883*10^-2; b(2) = 1.03547896*10^+1;
          a(3) = 9.24159648*10^-2; b(3) = 1.03540028*10^+1; c(1) = 2.61799101*10^-1; d(1) = 2.76252723*10^-0;
          c(2) = 8.80262108*10^-4; d(2) = 3.47681236*10^-2; c(3) = 1.10166555*10^-1; d(3) = 9.93421736*10^-1;
        case 8 %O
          a(1) = 3.39969204*10^-1; b(1) = 3.81570280*10^-1; a(2) = 3.07570172*10^-1; b(2) = 3.81571436*10^-1;
          a(3) = 1.30369072*10^-1; b(3) = 1.91919745*10^-1; c(1) = 8.83326058*10^-2; d(1) = 7.60635525*10^-1;
          c(2) = 1.96586700*10^-1; d(2) = 2.07401094*10^-0; c(3) = 9.96220028*10^-4; d(3) = 3.03266869*10^-2;
        case 16 %S
          a(1) = 1.01646916*10^-0; b(1) = 1.69181965*10^-0; a(2) = 4.41766748*10^-1; b(2) = 1.74180288*10^-1;
          a(3) = 1.21503863*10^-1; b(3) = 1.67011091*10^+2; c(1) = 8.27966670*10^-1; d(1) = 2.30342810*10^-0;
          c(2) = 2.33022533*10^-2; d(2) = 1.56954150*10^-1; c(3) = 1.18302846*10^-0; d(3) = 5.85782891*10^-0;
        case 42 %Mo
          a(1) = 6.10160120*10^-1; b(1) = 9.11628054*10^-2; a(2) = 1.26544000*10^-0; b(2) = 5.06776025*10^-1;
          a(3) = 1.97428762*10^-0; b(3) = 5.89590381*10^-0; c(1) = 6.48028962*10^-1; d(1) = 1.46634108*10^-0;
          c(2) = 2.60380817*10^-3; d(2) = 7.84336311*10^-3; c(3) = 1.13887493*10^-1; d(3) = 1.55114340*10^-1;
        case 73 %Ta
          a(1) = 3.20236821*10^-0; b(1) = 1.38446369*10^+1; a(2) = 8.30098413*10^-1; b(2) = 1.18381581*10^-1;
          a(3) = 2.86552297*10^-0; b(3) = 7.66369118*10^-1; c(1) = 2.24813887*10^-2; d(1) = 3.52934622*10^-2;
          c(2) = 1.40165263*10^-0; d(2) = 1.46148877*10^+1; c(3) = 3.33740596*10^-1; d(3) = 2.05704486*10^-1;
        otherwise
          disp('Unknown Element.');
          a=0; b=0; c=0; d=0;
  end
end