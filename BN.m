classdef BN < recip_2Dlattice
    %hexagonal Boron Nitride Summary of this class goes here
    %   Detailed explanation goes here
    properties (SetAccess = private, GetAccess = public)
        a = 2.49824;%http://www.crystallography.net/cod/2016170.html
        area = sqrt(3)*2.49824^2/2;              %Area of a unit cell
        stacking = 'AAA';
        theta
        name = 'BN'

    end
    
    methods        
        function obj = BN(varargin)
            obj = obj@recip_2Dlattice;
            obj.setB1(2 * pi/(sqrt(3)*obj.a) * [sqrt(3); -1]);
            obj.setB2(4 * pi/(sqrt(3)*obj.a) * [0; 1]);
            obj.setB(sqrt(dot(obj.b1,obj.b1)));              %in rad/Ang
            obj.setLambda(3.31785);
            obj.setStacking(varargin{1})
        end
        
        
        function setStacking(self,val)
            self.stacking=val;                
        end 
        function [pos,mag] = calculate(self)
            if 1
                [pos,mag] = self.calculateStacking;
            elseif strcmp(self.stacking,'A')

                [pos,mag] = self.calculateA;
            elseif strcmp(self.stacking,'AA-prime')
                [pos,mag] = self.calculateAA_prime;
            elseif strcmp(self.stacking,'AA-prime-offset')
                [pos,mag] = self.calculateAA_prime_offset;
            elseif strcmp(self.stacking,'AA')
                [pos,mag] = self.calculateAA;
            elseif strcmp(self.stacking,'AB')
                [pos, mag] = self.calculateAB;
            end
   
            self.setTitle([self.name,' ', self.stacking]) 
        end
        
        
        function [mag] = N_layer(self,h,k,pos,kz)
            mag = ones(size(h));
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            mag = s_B .* exp(-2i.*pi./3 .* (h+k))  + s_N ;
        end
        
        function [mag] = B_layer(self,h,k,pos,kz)
            mag = ones(size(h));
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            mag = s_B + s_N .* exp(-2i.*pi./3 .*(h+k));
        end

        function [mag] = b_layer(self,h,k,pos,kz)
            mag = ones(size(h));
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            mag = s_B + s_N .* exp(-4i.*pi./3 .*(h+k)).*exp(1i.*kz.*1);
        end
        
        function [mag] = n_layer(self,h,k,pos,kz)
            mag = ones(size(h));
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            mag = s_B .* exp(-4i.*pi./3 .* (h+k)).*exp(-1i.*kz.*1)  + s_N ;
        end
        
        function [pos,mag] = calculateStacking(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;

            mag = zeros(size(h));
            for i = 1:length(self.stacking)
               layer = self.stacking(i);
               zfactor = exp(-1i.*self.lambda.*kz.*i);
               if layer == 'B'
                   mag = mag + self.B_layer(h,k,pos,kz).*zfactor;
               elseif layer=='N'
                   mag = mag+ self.N_layer(h,k,pos,kz).*zfactor;
               elseif layer == 'b'
                   mag = mag + self.b_layer(h,k,pos,kz).*zfactor;
               elseif layer == 'n'
                   mag = mag + self.n_layer(h,k,pos,kz).*zfactor;               
               else
                   display(['error at index' num2str(i)]);
               end
            end
            
            mag = mag.*exp(1i.*self.lambda.*kz.*(1+length(self.stacking))./2);

            
            
            
        end
        
        
        
        function [pos, mag] = calculateA(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            
            n_layer = s_B .* exp(-2i.*pi./3 .* (h+k))  + s_N ;
            b_layer = s_B + s_N .* exp(-2i.*pi./3 .*(h+k));
            mag = n_layer;
            %mag = exp(1i.*kz.*self.lambda/2).*n_layer + exp(-1i.*kz.*self.lambda/2).*b_layer;
            mag = mag*(2*pi)^2;

        end
        function [pos, mag] = calculateAA_prime(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            
            n_layer = s_B .* exp(-2i.*pi./3 .* (h+k))  + s_N ;
            b_layer = s_B + s_N .* exp(-2i.*pi./3 .*(h+k));
            %mag = b_layer;
            mag = exp(1i.*kz.*self.lambda/2).*n_layer + exp(-1i.*kz.*self.lambda/2).*b_layer;
            mag = mag*(2*pi)^2;

        end
        
        function [pos, mag] = calculateAA_prime_offset(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            
            n_layer = s_B .* exp(-2i.*pi./3 .* (h+k)) .*exp(-1i.*kz.*.3)  + s_N ;
            b_layer = s_B + s_N .* exp(-2i.*pi./3 .*(h+k)) .*exp(1i.*kz.*.3);
            %mag = b_layer;
            mag = exp(1i.*kz.*self.lambda/2).*n_layer + exp(-1i.*kz.*self.lambda/2).*b_layer;
            mag = mag*(2*pi)^2;

        end
        function [pos, mag] = calculateAA(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            
            n_layer = s_B .* exp(-2i.*pi./3 .* (h+k))  + s_N ;
            b_layer = s_B + s_N .* exp(-2i.*pi./3 .*(h+k));
            %mag = b_layer;
            mag = exp(1i.*kz.*self.lambda/2).*n_layer + exp(-1i.*kz.*self.lambda/2).*n_layer; %swapped b->n
            mag = mag*(2*pi)^2;

        end
        function [pos, mag] = calculateAB(self)
            [pos,h,k] = recip2DMeshGrid(self);
            [kz] = self.kzProvider(pos(:,1),pos(:,2));
            pos(:,3) = kz;
            mag = ones(length(pos),1);
            s_B = self.applyScat(pos,mag,5);
            s_N = self.applyScat(pos,mag,7);
            
            n_layer = s_B .* exp(-2i.*pi./3 .* (h+k))  + s_N ;
            b_layer = s_B + s_N .* exp(-4i.*pi./3 .*(h+k)); %bond length shift 1/3 -> 2/3
            %mag = b_layer;
            mag = exp(1i.*kz.*self.lambda/2).*n_layer + exp(-1i.*kz.*self.lambda/2).*b_layer;
            mag = mag*(2*pi)^2;

        end        
    end
end
