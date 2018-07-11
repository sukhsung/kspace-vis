classdef BLG < graphene        
    properties (SetAccess = private, GetAccess = public)
        stacking
        theta
    end
    methods
        function obj = BLG(varargin)
            if isempty(varargin)
                obj.setStacking('AB')
            else
                obj.setStacking(varargin{1});
                if isequal(obj.stacking,'uTBG')
                    if length(varargin)>1
                        obj.setTheta(deg2rad(varargin{2}));
                    else
                        obj.setTheta(deg2rad(5));
                        disp('default twist angle = 5 deg')
                    end
                end
            end
        end
        
        
        function setStacking(self,val)
            self.stacking=val;

            if isequal(val,'uTBG') && isempty(self.theta)
                self.setTheta(deg2rad(5));
                disp('default twist angle = 5 deg')
            end
            self.setTitle(self.stacking)
                
        end 
        function setTheta(self,val)
            self.theta=val;
        end 
        
        function [pos, mag] = calculateABC(self,ILS,peak_no)
            if nargin < 2
               ILS = self.lambda;
            end
            
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_g = self.applyScat(pos,mag,6);
            mag = 0*mag;

            
            %a0 = (1 + 1.*exp(-2i.*pi./3 .*(h+k)));
            %b0 = (1 + 1.*exp(-2i.*pi./3 .*2.*(h+k)));
            %c0 = 1.*exp(-2i.*pi./3 .*(h+k)) + 1.*exp(-2i.*pi./3 .*2.*(h+k));
            a0 = self.fg_hk(h,k);
            b0 = self.fg_hk(h,k).*exp(-2i*pi/3*(h+k));
            c0 = self.fg_hk(h,k).*exp(-4i*pi/3*(h+k));
            
            
            for i = 1:length(self.stacking)
               layer = self.stacking(i);
               zfactor = exp(-1i.*ILS.*kz.*i);
               if layer == 'A'
                   mag = mag + a0.*zfactor;
               elseif layer=='B'
                   mag = mag+ b0.*zfactor;
               elseif layer == 'C'
                   mag = mag + c0.*zfactor;
               else
                   display(['error at index' num2str(i)]);
               end
            end
            
            mag = s_g.*mag.*exp(1i.*ILS.*kz.*(1+length(self.stacking))./2);
            if nargin > 2
               mag = mag(peak_no); 
            end

        end
        
        
        function [pos, mag] = calculateNAA(self,N)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_g = self.applyScat(pos,mag,6);
            mag = 0*mag;
            %a_layer = (1 + 1.*exp(-2i.*pi./3 .*(h+k))).*exp(-1i.*kz.*self.lambda/2);
            %b_layer = (1 + 1.*exp(-2i.*pi./3 .*2.*(h+k))).*exp(1i.*kz.*self.lambda/2);
            %mag = s_g.*(a_layer+b_layer);
            a0 = (1 + 1.*exp(-2i.*pi./3 .*(h+k)));
            b0 = (1 + 1.*exp(-2i.*pi./3 .*(h+k)));
%             
            for i = 1:N
               
            	position_term = exp(-1i .* self.lambda .* (i-1).* kz);
                
                %position_term = exp(-1i .* self.lambda .* kz .* ( -N/2 + i-1/2   ) );
                if( mod(i,2) == 0)
                    %translate initial layer below origin, invert above
                    %origin (conjugate), finally translate layer to
                    %appropriate position, and add to structure
                    mag = mag + position_term.* a0; %position_term.*( b0 .* exp(-1i.*self.lambda .* -1./2 .* kz));
                    
                %odd layers -> no inversion
                else
                    %translate initial layer to match inverted position, 
                    %then translate to appropriate position, and finally
                    %add to structure
                    mag = mag + position_term.*b0;%.* exp(-1i .*self.lambda .* 1 .* kz);
                end


                
            end
%             
%             
            mag = s_g.*mag.*exp(1i.*self.lambda.*kz.*N./2);
        end
        
        function [pos, mag] = calculateNAB(self,N)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_g = self.applyScat(pos,mag,6);
            mag = 0*mag;
            %a_layer = (1 + 1.*exp(-2i.*pi./3 .*(h+k))).*exp(-1i.*kz.*self.lambda/2);
            %b_layer = (1 + 1.*exp(-2i.*pi./3 .*2.*(h+k))).*exp(1i.*kz.*self.lambda/2);
            %mag = s_g.*(a_layer+b_layer);
            a0 = (1 + 1.*exp(-2i.*pi./3 .*(h+k)));
            b0 = (1 + 1.*exp(-2i.*pi./3 .*2.*(h+k)));
%             
            for i = 1:N
               
            	position_term = exp(-1i .* self.lambda .* (i-1).* kz);
                
                %position_term = exp(-1i .* self.lambda .* kz .* ( -N/2 + i-1/2   ) );
                if( mod(i,2) == 0)
                    %translate initial layer below origin, invert above
                    %origin (conjugate), finally translate layer to
                    %appropriate position, and add to structure
                    mag = mag + position_term.* a0; %position_term.*( b0 .* exp(-1i.*self.lambda .* -1./2 .* kz));
                    
                %odd layers -> no inversion
                else
                    %translate initial layer to match inverted position, 
                    %then translate to appropriate position, and finally
                    %add to structure
                    mag = mag + position_term.*b0;%.* exp(-1i .*self.lambda .* 1 .* kz);
                end


                
            end
%             
%             
            mag = s_g.*mag.*exp(1i.*self.lambda.*kz.*N./2);
        end
        
        function [pos,mag] = calculate(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = self.fg_hk(h,k);
            val = self.stacking;
            if val
                [pos,mag] = calculateABC(self);
                
            elseif isequal(val(length(val)-1:length(val)),'AB') && length(val) > 2
                num_layers = str2num(val(1:length(val)-2));
                
                [pos,mag]=calculateNAB(self,num_layers);
                
            elseif isequal(val(length(val)-1:length(val)),'AA') && length(val) > 2
                num_layers = str2num(val(1:length(val)-2));
                
                [pos,mag]=calculateNAA(self,num_layers);
            else
                
            
                switch self.stacking
                    case 'AA'
                        mag = 2*cos(kz*self.lambda/2).*mag;
                    case 'AB'
                        mag = 2*exp(-1i*pi*(h+k)/3).*cos(kz*self.lambda/2+pi/3*(h+k)).*mag;
                    case 'BA'                    
                        mag = 2*exp(-1i*pi*(h+k)/3).*cos(kz*self.lambda/2-pi/3*(h+k)).*mag;
                    case 'uTBG'
                        pos_t = self.rotPos(pos,-self.theta/2);
                        pos_b = self.rotPos(pos,self.theta/2);
                        mag_t = mag.*exp(-1i*kz*self.lambda/2);
                        mag_b = mag.*exp(1i*kz*self.lambda/2);

                        pos = [pos_t;pos_b];
                        mag = [mag_t;mag_b];
                    case 'TLG'
                        mag = exp(-1i*pi*(h+k)/3) + exp(-1i*kz*self.lambda) + exp(1i*kz*self.lambda);
                    %case '4LG'
                        %mag = 
                end
                if self.includeScat
                    mag = self.applyScat(pos,mag,6);
                end
                
            end
        end
    end
end