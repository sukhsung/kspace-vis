function [ k ] = eDiff_Wavenumber( kev )
%EDIFF_INCIDENTVECTOR get wavevector based on keV.  Returns value in Ang^-1

    wav = electronwavelength(kev)
    
    k = 2*pi / wav;


end

function wav = electronwavelength(kev)
           wav = 12.3986./sqrt((2*511.0+kev).*kev);
end