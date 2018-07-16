classdef TMD < recip_2Dlattice
    %TMDS
    
    
    
    properties (SetAccess = private, GetAccess = public)
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
        
        
        function [pos, mag] = calculate(self)
            
            [~,hs,ks] = recip2DMeshGrid(self);            
            [pos, mag] = calculateHK(self,hs,ks);

        end  

        
        function [pos, mag] = calculateHK_1H(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(hs+ks));
            c0 = mag.*exp(-4i*pi/3*(hs+ks));            
            
            
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,b0,self.ch);
            
            mag = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
        end
        
        
        function [pos, mag] = calculateHK_2H(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(hs+ks));
            c0 = mag.*exp(-4i*pi/3*(hs+ks));
            
            
            magTm = self.applyScat(pos,b0,self.tm);
            magCb = self.applyScat(pos,c0,self.ch);
            magCt = self.applyScat(pos,c0,self.ch);
            
            magA = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     
            magTm = self.applyScat(pos,c0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,b0,self.ch);
            
            magB = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
%                     

            mag = magA.*exp(-1i*self.lambda*kz/2) + magB.*exp(1i*self.lambda*kz/2);
        end        
        
        
        function [pos, mag] = calculateHK_1T(self,hs,ks)
            pos = hs*self.b1' + ks*self.b2';
            kz = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            
            mag = ones(length(pos),1);

            a0 = mag;
            b0 = mag.*exp(-2i*pi/3*(hs+ks));
            c0 = mag.*exp(-4i*pi/3*(hs+ks));                  
            
            
            magTm = self.applyScat(pos,a0,self.tm);
            magCb = self.applyScat(pos,b0,self.ch);
            magCt = self.applyScat(pos,c0,self.ch);
            
            mag = magTm + exp(-1i*self.lambda_tmch*kz).*magCt...
                        + exp(+1i*self.lambda_tmch*kz).*magCb;
      
        end
        
        function [pos, mag] = calculateHK(self,hs,ks)
           if strcmp(self.stacking, '1H')
               [pos, mag] = calculateHK_1H(self,hs,ks);
           elseif strcmp(self.stacking, '1T')
               [pos, mag] = calculateHK_1T(self,hs,ks);
           elseif strcmp(self.stacking, '2H')
               [pos, mag] = calculateHK_2H(self,hs,ks);
           end
        end
        
                
        function setStacking(self,val)
            %if strcmp(val,'1H') || strcmp(val,'1T') || strcmp(val,'2H')|| strcmp(val,'nH')
            self.stacking=val;
            if strcmp(val,'1H') || strcmp(val,'1T')
                self.setLambda(self.lambda_tmch*2)
            else
                self.setLambda(6.1475); %N.S. from arizona cryst. db %6.144); 
            end
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
        
%         function setA(self,val)
%             self.a = val;
%             self.area = sqrt(3)*val^2/2;        
%         end
%         
        function setLambda_tmch(self, val)
            self.lambda_tmch = val;
        end
        
        function setName(self, val)
            self.name = val;
        end
        
    end
end

