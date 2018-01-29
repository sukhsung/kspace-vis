classdef TMD < recip_2Dlattice
    %GRAPHENE Summary of this class goes here

    
    properties (SetAccess = private, GetAccess = public)
        a
        area     %Area of a unit cell
        stacking
        tm
        ch
        lambda_tmch
        name
    end
    
    methods        
        function obj = TMD(a)
            obj = obj@recip_2Dlattice;
            obj.setA(a)
            obj.setB1(2 * pi/(sqrt(3)*obj.a) * [sqrt(3); -1]);
            obj.setB2(4 * pi/(sqrt(3)*obj.a) * [0; 1]);
            obj.setB(sqrt(dot(obj.b1,obj.b1)));              %in rad/Ang
        end
        
        function fg = fg_hk(self,h,k)
            fg = 8*pi^2/self.area*exp(-1i*pi/3*(h+k)).*cos(pi/3*(h+k));
        end
        
        function [pos,mag] = calculate(self)
            switch self.stacking
                case '1H'
                    [pos,mag] = self.calculate1H;
                case '1T'
                    [pos,mag] = self.calculate1T;
                case '2H'
                    [pos,mag] = self.calculate2H;
                case '3H'
                    [pos,mag] = self.calculate3H;
            end
            self.setTitle([self.name,' ', self.stacking]) 
        end
        
        function [pos, mag] = calculate2H(self)
            [pos0, mag0] = self.calculate1H(); %1H layer centered on 0
                        
            pos = pos0;
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            
            mag = mag0 .* exp(-1i.*self.lambda .* -1./2 .* kz); %translate down by 1/2 lambda
            
            mag = mag + conj(mag); %add second (inverted) layer
            
            
        end
        
%         function [pos, mag] = calculate2H(self)
%             [pos, h, k] = recip2DMeshGrid(self);
%             [kz] = self.kzProvider(pos(:,1),pos(:,2));
%             pos(:,3) = kz;
%             mag = ones(length(pos),1);
%             scat_tm = self.applyScat(pos,mag,self.tm);
%             scat_ch = self.applyScat(pos,mag,self.ch);
%             
%             ICS = self.lambda_tmch*2;
%             IMS = self.lambda;
%             
%             s_tm = scat_tm.*( exp(-1i*ICS*kz/2)  +  exp(-2*pi*1i/3*(h+k)).*exp(-1i*(ICS/2+IMS)*kz)  );
%             s_ch = scat_ch.*( exp(-2*pi*1i/3*(h+k))    +   exp(-2*pi*1i/3*(h+k)).*exp(-1i*ICS*kz)  +  exp(-1i*IMS*kz)  +  exp(-1i*(IMS+ICS)*kz)   );
%             
%             mag = s_tm +s_ch;
%             mag = mag*(2*pi)^2;
% 
%         end
        
        function [pos, mag] = calculate3H(self)
                        [pos, h, k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            scat_tm = self.applyScat(pos,mag,self.tm);
            scat_ch = self.applyScat(pos,mag,self.ch);
            
            ICS = self.lambda_tmch*2;
            IMS = self.lambda;
            
            s_tm = scat_tm.*( exp(-1i*ICS*kz/2)  +  exp(-2*pi*1i/3*(h+k)).*exp(-1i*(ICS/2+IMS)*kz)  + exp(-1i*(2*IMS+ICS/2)*kz)  );
            s_ch = scat_ch.*( exp(-2*pi*1i/3*(h+k))    +   exp(-2*pi*1i/3*(h+k)).*exp(-1i*ICS*kz)  +  exp(-1i*IMS*kz)  +  exp(-1i*(IMS+ICS)*kz) +  exp(-2*pi*1i/3*(h+k)).*exp(-1i*2*IMS*kz)    +   exp(-2*pi*1i/3*(h+k)).*exp(-1i*(ICS+2*IMS)*kz)  );
            
            mag = s_tm +s_ch;
            mag = mag*(2*pi)^2;
        end
        
        function [pos,mag] = calculate1H(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_tm = self.applyScat(pos,mag,self.tm);
            s_ch = self.applyScat(pos,mag,self.ch);
            s_ch = s_ch*2.*cos(kz*self.lambda_tmch).*exp(-2i*pi/3*(h+k));
            mag = s_tm +s_ch;
            mag = mag*(2*pi)^2;
        end
            
        function [pos,mag] = calculate1T(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_tm = self.applyScat(pos,mag,self.tm);
            s_ch = self.applyScat(pos,mag,self.ch);
            s_ch = s_ch*2.*cos(kz*self.lambda_tmch+2*pi/3*(h+k));
            mag = s_tm +s_ch;
            mag = mag*(2*pi)^2;
        end
        
        function setStacking(self,val)
            if strcmp(val,'1H') || strcmp(val,'1T') || strcmp(val,'2H')|| strcmp(val,'3H')
                self.stacking=val;
            else
                disp('Invalid Stacking, Setting to 1H')
                self.stacking = '1H';
            end
        end 
        
        function setTm(self,val)
            self.tm = val;
        end
        
        function setCh(self,val)
            self.ch = val;
        end
        
        function setA(self,val)
            self.a = val;
            self.area = sqrt(3)*val^2/2;        
        end
        
        function setLambda_tmch(self, val)
            self.lambda_tmch = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

