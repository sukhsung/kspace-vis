function [ q ] = eDiff_ScatteringVector( k, qx, qy, phi, theta )
%EDIFF_SCATTERINGVECTOR returns the scattering vector in terms of
%the reference frame of the specimen.  The tilt and tilt axis must also be
%specified.
%   By taking in the incident wavevector, k, and the scattering vector
%   components qx, qy, one can determine the scattered vector that lies on the Ewald
%   Sphere.  This vector and its magnitude is returned by this function.
%
%   by Robert Hovden
%   Oct 20, 2011
        
    %The Ewald Sphere has an origin that changes with tilt and rotation
    qzo = k*cos(phi);
    qxo = k*sin(phi)*cos(theta);
    qyo = k*sin(phi)*sin(theta);
    
    %With Ewald Sphere origin and qx, qy components, we can determine qz
    qz  = qzo - sqrt(k^2 - (qx-qxo)^2 - (qy-qyo)^2);
    
    %Return q vector
    q(1) = qx;
    q(2) = qy;
    q(3) = qz;

end

