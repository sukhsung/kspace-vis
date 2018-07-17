classdef recip_2Dlattice < handle
    %reciprocal 2D lattice object
    %Dependencies eDiff_Wavenumber
    %             eDiff_ScatteringFactor
    %             phase2color
    properties (SetAccess = private, GetAccess = public)
        
        spotcut = 2;
        kzval = 0;
        keV = 80;
        rnd = 8;
        kzMode = 'ewald';
        intcut = 0;
        killZero = 1; %0-> show 0, 1-> hide 0, 2-> gray 0
        includeScat= true;
        b
        b1
        b2
        a
        a1
        a2
        area
        lambda
        title_str
        intensityFactor = 1;
        tilt_start
        tilt_end
        tilt_angle
        tilt_axis = 0;
    end
        
    methods   
        function setTitle(self,val)
            self.title_str=val;
        end
        function setSpotcut(self,val)
            self.spotcut=val;
        end 
        function setKzVal(self,val)
            self.kzval=val;
        end 
        function setkeV(self,val)
            self.keV=val;
        end 
        function setrnd(self,val)
            self.rnd=val;
        end 
        function setKzMode(self,val)
            self.kzMode=val;
        end 
        function setIntcut(self,val)
            self.intcut=val;
        end 
        function setKillZero(self,val)
            self.killZero=val;
        end 
        function setIncludeScat(self,val)
            self.includeScat=val;
        end 
        function setArea(self,val)
            self.area = val;
        end
        function setB(self,val)
            self.b=val;
        end 
        function setB1(self,val)
            self.b1=val;
        end 
        function setB2(self,val)
            self.b2=val;
        end 
        function setA(self,val)
            self.a=val;
        end 
        function setA1(self,val)
            self.a1=val;
        end 
        function setA2(self,val)
            self.a2=val;
        end 
        
        function setLambda(self,val)
            self.lambda=val;
        end 
        function setIntensityFactor(self,val)
            self.intensityFactor = val;
        end
        
        function setTiltStart(self,val)
            self.tilt_start = val;
        end
        function setTiltEnd(self,val)
            self.tilt_end = val;
        end
        function setTiltAxis(self,val)
            self.tilt_axis = val;
        end
        function setTiltAngle(self,val)
            self.tilt_angle = val;
        end
        
        function [pos,h,k] = recip2DMeshGrid(self)
            [pos,h,k] = indexedMeshGrid(self.spotcut,self.b1,self.b2);
            pos = round(pos,self.rnd);
            [~,ia,~] = unique(pos,'rows');
            pos = pos(ia,:);
            h = h(ia);
            k = k(ia);
        end
        
        function [ kz ] = kzProvider(self,kx,ky)
            switch self.kzMode
                case 'constant'
                    kz = self.kzval*ones(length(kx),1);
                case 'ewald'
                    k_rho_sq = (kx.^2+ky.^2);    
                    K = eDiff_Wavenumber(self.keV);
                    kz = K-sqrt(K^2 -k_rho_sq);
                case 'tilted_ewald'
                    k = eDiff_Wavenumber(self.keV);
                    phi = self.tilt_angle;
                    theta = self.tilt_axis;
                    qzo = k*cos(phi);
                    qxo = k*sin(phi)*cos(theta);
                    qyo = k*sin(phi)*sin(theta);
                    kz = qzo - sqrt(k^2 - (kx-qxo).^2 - (ky-qyo).^2);
                case 'tilted_constant'
                    k = eDiff_Wavenumber(self.keV);
                    phi = self.tilt_angle;
                    theta = self.tilt_axis;
                    k_rho = sqrt(kx.^2+ky.^2);
                    kz = k_rho.*tan(phi);%k.*cos(phi)-sqrt(k.^2 - k_rho.^2)
                otherwise
                    error('invalid mode')
            end
        end
        
        function [pos] = rotPos(self,pos,theta)
        % rotate positioin matrix in xy plane
        % pos: n x 3 position matrix [x0,y0,z0;x1,y1,z1;..]
        % Written by Suk Hyun Sung, sukhsung@umich.edu
        % Jan. 05 2018

            % construct tilt_axis matrix
            rotmatrix = [cos(theta),-sin(theta);sin(theta),cos(theta)];

            % extract xy coordinates only
            xy = pos(:,1:2);
            % rotate xy coordinates
            xy_rot = xy*rotmatrix;
            % assign output
            pos(:,1:2) = xy_rot;
        end
        
        function drawTiltAxis(self,pos,mag,fig)
            % load global variables
            % handle empty variables
            % suppress zero beam
            if self.killZero == 1 
                mag(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0) = 0;
            end
            % calculate intensity and normalize
            int = mag.*conj(mag);
            int = int/max(int);

            % remove intensities below cutoff
            pos(int<=self.intcut,:) =[];
            int(int<=self.intcut,:) =[];
            
            rgb = pos2color(pos);
            
            % Draw
            ax = axes('Parent',fig);
            hold(ax,'on')
            axis(ax,'equal')
            scatter(pos(:,1),pos(:,2),1000*int,rgb,'.')
            phi = self.tilt_axis;
            plot( self.b*linspace(-cos(phi),cos(phi)),self.b*linspace(-sin(phi),sin(phi)));
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end

        function posmagDrawPhase(self,pos,mag,fig)
            % load global variables
            % handle empty variables
            % suppress zero beam
            if self.killZero ==1
                mag(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0) = 0;
            end

            % calculate intensity and normalize
            int = mag.*conj(mag);
            int = int/max(int);

            % remove intensities below cutoff
            pos(int<=self.intcut,:) =[];
            mag(int<=self.intcut,:) =[];
            int(int<=self.intcut) = [];
            
            phase = angle(mag);
            rgb = phase2color(phase);
            
            if self.killZero == 2
                   rgb(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0,:) = .8275; %setting center beam to gray 
            end
            
            % scatter point area is proportional to int
            int = self.intensityFactor .* sqrt(int);

            % Draw
            ax = axes('Parent',fig);
            hold(ax,'on')
            scatter3(pos(:,1),pos(:,2),pos(:,3),700*int,rgb,'.')
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(ax,self.title_str)
        end
        
        function [pos, mag] = draw2D(self,fig)
            [pos,mag] = self.calculate();
            self.posmagDrawPhase(pos,mag,fig);
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end

        function [pos, mag] = draw3D(self,fig)
            self.setKzMode('constant');
            self.intensityFactor = 10;
            kzs = linspace(-2*pi/self.lambda,2*pi/self.lambda,2^8);
            
            pos =[];    mag = [];
            for kz = kzs
                self.setKzVal(kz); 
                [pos_cur,mag_cur] = self.calculate;
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
            end
            self.posmagDrawPhase(pos,mag,fig);
            title(self.title_str)
            axis equal
        end
        
        function [pos, mag] = drawSideView(self,hs,ks,xpos,fig)
            self.setKzMode('constant')
            self.setIntcut(0)
            self.intensityFactor = 30;
            kzs = linspace(-2*pi/self.lambda,2*pi/self.lambda,2^8);
            %kzs = linspace(-2*pi/self.lambda_tmch,2*pi/self.lambda_tmch,2^8);
            
            pos = []; mag = [];
            for kz = kzs
                self.setKzVal(kz); 
                [pos_cur,mag_cur] = self.calculateHK(hs,ks);
                pos_cur(:,1) = xpos;
                pos_cur(:,2) = zeros(size(xpos));
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
            end
            
            self.posmagDrawPhase(pos,mag,fig);
            title(self.title_str)
            view([0 0])
        end
        
        function [tiltrange, I, kz, f1] = getTiltSeries(self, kzmode, displaymode, displaypattern, tiltrange, fig)            
            self.setKzMode(['tilted_' kzmode]);
            if isempty(tiltrange)
                tiltrange = self.tilt_start:.1*pi/180:self.tilt_end;
            end
            
            
            I = [];
            kz_holder  = [];
            pos0 = [];
            mag0 = [];
            %rgb = [];
            for tilt = tiltrange
                self.tilt_angle = tilt;
                [pos, mag] = self.calculate;
                if self.killZero ==1
                    mag(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0) = 0;
                end
                int = mag.*conj(mag);
                int = int./max(int);
                pos(int<=self.intcut,:) =[];
                mag(int<=self.intcut,:) = [];
                if tilt < 1*pi/180 && tilt > -1*pi/180
                   pos0 = pos;
                   mag0 = mag;
                end
                mag = mag./(cos(tilt));%%%%%%% applying cosine correction baked in
                %before multiplying by conjugate -> cos^2
                kz_holder = [kz_holder, pos(:,3)];
                I = [I, mag.*conj(mag)];
            end
            
            I = I./max(I(:));
            %rgb = phase2color(phase);

            phase = angle(mag0);%[phase,angle(mag)];
            rgb = phase2color(phase);
            if(strcmp('angle',displaymode))
                if nargin == 6
                    f1 = fig;  
                end
                rgb = pos2color(pos0);
                for i = length(rgb):-1:1
                   plot(tiltrange(:).*180/pi, I(i,:),'LineWidth',3,'Color',rgb(i,:));
                   hold on;
                end
            
            elseif(strcmp('kz',displaymode))
                f2 =figure;
                rgb = pos2color(pos0);
                for i = 1:length(rgb)
                   plot(kz_holder(i,:), I(i,:),'LineWidth',3,'Color',rgb(i,:));
                   hold on;
                end
            end
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)

            %set(gca, 'ColorOrder', rgb,'NextPlot', 'replacechildren');
            %plot(tiltrange(:).*180/pi,(I(2,:)),'LineWidth', 3)
            if displaypattern
                self.posmagDraw(pos0,mag0);
            end
        end

        function mag = applyScat(self,pos,mag,element)
            % Calculate scattering factor and apply to recip-space magnitude vector
            % Utilizes eDiff_ScatteringFactor by R Hovden.
            % Written by Suk Hyun Sung, sukhsung@umich.edu
            % Jan. 05 2018
            r = sqrt(pos(:,1).^2+pos(:,2).^2 +pos(:,3).^2); %
            fe = eDiff_ScatteringFactor(element,r/(2*pi));
            mag = mag.*fe;
        end
        
        
    end
    
    methods (Abstract)
        [pos,mag] = calculate(self);
      %  [pos,mag] = calculateReal(self);
        mag = calculateHK(self,h,k);
    end
end

