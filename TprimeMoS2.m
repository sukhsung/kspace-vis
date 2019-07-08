classdef TprimeMoS2 < recip_2Dlattice
    %TMDS
    
    
    
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
        function obj = TprimeMoS2(varargin)
            obj = obj@recip_2Dlattice;
            obj.setA([5.5,3.161]);
            obj.setB1([2*pi/obj.a(1);0]);
            obj.setB2(2 * pi/(obj.a(2)) * [0; 1]);
            obj.setB(sqrt(dot(obj.b1,obj.b1)));              %in rad/Ang
            obj.setStacking('1Tprime');
            obj.setTm(42);
            obj.setCh(16);
            obj.setLambda(6.1475);
            obj.setLambda_tmch( 3.07/2);
            obj.setName('MoS2');
        end

        function [pos,mag] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            
            s_tm = self.applyScat(pos,mag,self.tm);
            s_ch = self.applyScat(pos,mag,self.ch);
            
            x_m       = 15/37;
            lambda_mo = -0.1;

            x_tu      = 5/37;
            x_tl      = 24/37;
            x_bu      = 31/37;
            x_bl      = 11/37;
            lambda_long  = -1.7;
            lambda_short  = -1.3;
            lambda_interlayer = -5;
            
            %Mo Sites
            mag_mo = s_tm.*exp(1i.*kz*lambda_mo) + s_tm.*exp(-2i.*pi.*(x_m.*h+0.5.*k)).*exp(-1i.*kz*lambda_mo);
            %top upper chalcogen
            mag_tu = s_ch.*exp(1i.*kz.*lambda_long).*exp(-2i.*pi.*(x_tu.*h+0.5.*k));
            %top lower chalcogen
            mag_tl = s_ch.*exp(1i.*kz.*lambda_short).*exp(-2i.*pi.*(x_tl.*h+0.*k));
            %bottom upper chalcogen
            mag_bu = s_ch.*exp(-1i.*kz.*lambda_short).*exp(-2i.*pi.*(x_bu.*h+0.5.*k));
            %bottom lower chalcogen
            mag_bl = s_ch.*exp(-1i.*kz.*lambda_long).*exp(-2i.*pi.*(x_bl.*h+0.*k));
            
            mag = mag_mo + mag_tu + mag_tl + mag_bu + mag_bl;
            
            mag = mag + mag.*exp(-1i.*kz.*lambda_interlayer);
              
            self.setTitle([self.name,' ', self.stacking]) 
        end
        
        
        function setStacking(self,val)
            %if strcmp(val,'1H') || strcmp(val,'1T') || strcmp(val,'2H')|| strcmp(val,'nH')
            self.stacking=val;
            %else
            %    disp('Invalid Stacking, Setting to 1H')
            %    self.stacking = '1H';
            %end
        end 
        %% setters
        function setTm(self,val)
            self.tm = val;
        end
        
        function setCh(self,val)
            self.ch = val;
        end
        
        function setA(self,val)
            self.a = val;
            self.area = val(1)*val(2);%sqrt(3)*val^2/2;        
        end
        
        function setLambda_tmch(self, val)
            self.lambda_tmch = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

