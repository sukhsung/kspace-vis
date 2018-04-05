classdef TMD < recip_2Dlattice
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
            if self.stacking(length(self.stacking)) == 'H'
                layers = str2num(self.stacking(1:length(self.stacking)-1));
                if(layers == 1)
                    [pos,mag] = self.calculate1H;
                else
                    [pos, mag] = self.calculateNH(layers);
                end
            elseif self.stacking(length(self.stacking)) == 'T'
                layers = str2num(self.stacking(1:length(self.stacking)-1));
                if(layers == 1)
                    [pos,mag] = self.calculate1T;
                else
                    [pos, mag] = self.calculateNT(layers);
                end
            elseif self.stacking(length(self.stacking)) == 'A'
                layers = str2num(self.stacking(1:length(self.stacking)-3));
                if(layers == 1)
                    [pos,mag] = self.calculate1H;
                else
                    [pos, mag] = self.calculateNHAA(layers);
                end
            end
            self.setTitle([self.name,' ', self.stacking]) 
        end
        %% arbitrary 2H (AB, MoS2 style) stackings
        function [pos,mag] = stacking_1H(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_tm = self.applyScat(pos,mag,self.tm) .* exp(-2i.*pi./6 .*(h+k));
            s_ch = self.applyScat(pos,mag,self.ch);
            s_ch = s_ch*2.*cos(kz*self.lambda_tmch).*exp(2i*pi/6*(h+k));
            mag = s_tm +s_ch;
            mag = mag*(2*pi)^2;
        end
       
        
        function [pos, mag] = calculateNH(self, N)
            [pos0, mag0] = self.stacking_1H(); %1H layer centered on 0
                        
            pos = pos0;
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            
            %first layer (translated down to make room for added)
            mag = mag0 .* exp( -1i .* self.lambda .* -(1./2.*N -1./2) .* kz );
            
            %for each additional layer
            for i = 2:N
                %assumes starting at lambda/2 above origin (general pos for
                %inverted, manipulated pos for non-inverted)
                position_term = exp(-1i .* self.lambda .*  (-(1./2.*N -1./2) + (i-1.5)  )   .* kz);
                %if even layer -> inversion
                if( mod(i,2) == 0)
                    %translate initial layer below origin, invert above
                    %origin (conjugate), finally translate layer to
                    %appropriate position, and add to structure
                    mag = mag + position_term.*conj( mag0 .* exp(-1i.*self.lambda .* -1./2 .* kz));
                    
                %odd layers -> no inversion
                else
                    %translate initial layer to match inverted position, 
                    %then translate to appropriate position, and finally
                    %add to structure
                    mag = mag + position_term.*mag0.* exp(-1i .*self.lambda .* 1 .* kz);
                end
            end

        end
        
        %% Arbitrary 2H (AA, TaSe2 style) stackings
        
        function [pos,mag] = stacking_1HAA(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_tm = self.applyScat(pos,mag,self.tm);
            s_ch = self.applyScat(pos,mag,self.ch);
            s_ch = s_ch*2.*cos(kz*self.lambda_tmch).*exp(2i*pi/3*(h+k));
            mag = s_tm +s_ch;
            mag = mag*(2*pi)^2;
        end
        
        function [pos, mag] = calculateNHAA(self, N)
            [pos0, mag0] = self.stacking_1HAA(); %1H layer, metal on 0,0, ch on 1/3, 1/3
                        
            pos = pos0;
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            
            %first layer (translated down to make room for added)
            mag = mag0 .* exp( -1i .* self.lambda .* -(1./2.*N -1./2) .* kz );
            
            %for each additional layer
            for i = 2:N
                %assumes starting at lambda/2 above origin (general pos for
                %inverted, manipulated pos for non-inverted)
                position_term = exp(-1i .* self.lambda .*  (-(1./2.*N -1./2) + (i-1.5)  )   .* kz);
                %if even layer -> inversion
                if( mod(i,2) == 0)
                    %translate initial layer below origin, invert above
                    %origin (conjugate), finally translate layer to
                    %appropriate position, and add to structure
                    mag = mag + position_term.*conj( mag0 .* exp(-1i.*self.lambda .* -1./2 .* kz));
                    
                %odd layers -> no inversion
                else
                    %translate initial layer to match inverted position, 
                    %then translate to appropriate position, and finally
                    %add to structure
                    mag = mag + position_term.*mag0.* exp(-1i .*self.lambda .* 1 .* kz);
                end
            end

        end
        %% calculate arbitrary thickness 1T
        function [pos, mag] = calculateNT(self,N)
            [pos0, mag0] = self.calculate1T(); %1H layer, metal on 0,0, ch on 1/3, 1/3
                        
            pos = pos0;
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            
            %first layer (translated down to make room for added)
            mag = mag0 .* exp( -1i .* self.lambda .* -(1./2.*N -1./2) .* kz );
            
            %for each additional layer
            for i = 2:N
               position_term = exp(-1i .* self.lambda .*  (-(1./2.*N -1./2) + (i-1.5)  )   .* kz);

               mag = mag + position_term.*mag0.* exp(-1i .*self.lambda .* 1 .* kz);
            end
        end

        %% specific stackings
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

