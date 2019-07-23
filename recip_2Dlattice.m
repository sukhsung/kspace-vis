classdef recip_2Dlattice < handle
    %reciprocal 2D lattice object
    %Dependencies eDiff_Wavenumber
    %             eDiff_ScatteringFactor
    %             phase2color
    properties (SetAccess = public, GetAccess = public)
        spotcut = 2;      % radial cut off
        kzval   = 0;      % default kz value
        keV     = 80;     % incident electron beam energy (keV)
        rnd     = 8;      % position tolerance (# decimal points) 
        kzMode = 'ewald'; % 
        intcut = 0;       % Intensity cutoff (Normalized)
        killZero = 1;     % 0-> show 0, 1-> hide 0, 2-> gray 0
        includeScat= true;
        
        % Lattice Parameters
        b
        b1
        b2
        a
        a1
        a2
        area              % Unit Cell Area
        lambda            % Inter-vdw spacing
        stacking
        
        title_str   ='';      % Title for figures
        intensityFactor = 1; % Scaling factor for ploting bragg peaks
        
        % For Tilt Series
        tilt_start
        tilt_end
        tilt_n = 2.^8;
        tilt_angle
        tilt_axis = 0;
        
        % 3D kz extent
        kzExtent;
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
        function setKzExtent(self,val)
            self.kzExtent = val;
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
        function setTiltN(self,val)
            self.tilt_n = val;
        end
        
        function [pos,h,k] = recip2DMeshGrid(self)
            [pos,h,k] = indexedMeshGrid(self.spotcut,self.b1,self.b2);
            % Get rid of overlapping peaks
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
                    K = eDiff_Wavenumber(self.keV);
                    k_rho_sq = (kx.^2+ky.^2);    
                    kz = K-sqrt(K^2 -k_rho_sq);
                case 'tilted_ewald'
                    k = eDiff_Wavenumber(self.keV);
                    phi = self.tilt_angle;
                    theta = self.tilt_axis;
                    qzo = k*cos(phi);
                    qxo = k*sin(phi)*cos(theta);
                    qyo = k*sin(phi)*sin(theta);
                    kz = qzo - sqrt(k^2 - (kx-qxo).^2 - (ky-qyo).^2);
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
        
        % Generic function for drawing scatter plot with color
        % corresponding to phase and size corresponding to magnitude        
        function posmagDrawPhase(self,pos,mag,fig)
            figure(fig);
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
            scatter3(pos(:,1),pos(:,2),pos(:,3),700*int,rgb,'.')
        end
        
        % Draw 2D recip structure according to current kzmode and kzval
        function [pos, mag] = draw2D(self,fig)
            figure(fig);
            [pos,mag] = self.calculate();
            self.posmagDrawPhase(pos,mag,fig);
            title(self.title_str)
        end
        
        % Draw full 3D recip structure
        function [pos, mag] = draw3D(self,drawHexagon,fig)
            figure(fig);
            
            self.setKzMode('constant');
            kzs = linspace(-self.kzExtent,self.kzExtent,2^8);
                        
            intensityScal = 5;            
            self.intensityFactor = intensityScal * self.intensityFactor;
            
            pos =[];    mag = [];
            for kz = kzs
                self.setKzVal(kz); 
                [pos_cur,mag_cur] = self.calculate;
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
            end
            self.posmagDrawPhase(pos,mag,fig);
            
            if drawHexagon
                % Draw a hexagon around first order Bragg peak
                hold on
                ang = linspace(30, 390,7);
                x   = self.b* cosd(ang); y = self.b*sind(ang);
                plot(x,y,'k')
            end
            
            title(self.title_str)
            axis equal off
            view([17,36])
            
            self.intensityFactor = self.intensityFactor/intensityScal;
        end
        
        % Draw side view of structure given hk indices
        function [pos, mag] = drawSideView(self,hs,ks,xpos,fig)
            self.setKzMode('constant')
            self.setIntcut(0)
            
            intensityScal = 30;            
            self.intensityFactor = intensityScal * self.intensityFactor;
            kzs = linspace(-self.kzExtent,self.kzExtent,2^8);
            
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
            
            self.intensityFactor = self.intensityFactor/intensityScal;
        end

        % Used by getTiltSeries to draw tilt axis on a 2D diffraction
        % pattern with colors corresponding to position NOT PHASE
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
        
        function [tiltrange, I] = getTiltSeries(self, kzmode, displaymode, displaypattern, fig)    
            figure(fig);
            hold on;
            
            curkeV = self.keV;            
            self.setKzMode('tilted_ewald');
            if strcmp(kzmode, 'constant')
                % Set arbitrary high beam energy to simulate flat ewald
                self.setkeV(10^8);
            end
            
            tiltrange = linspace(self.tilt_start,self.tilt_end,self.tilt_n);
            
            I           = [];
            kz_holder   = [];
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
                %%%%%%% applying cosine correction baked in
                mag = mag./(cos(tilt)); %before multiplying by conjugate -> cos^2
                kz_holder = [kz_holder, pos(:,3)];
                I = [I, mag.*conj(mag)];
            end
            I = I./max(I(:));
            
            pos0 = pos;
            mag0 = ones(size(pos0));            
            rgb = pos2color(pos0);
            if(strcmp('angle',displaymode))
                for i = length(rgb):-1:1
                   plot(tiltrange(:).*180/pi, I(i,:),'LineWidth',2,'Color',rgb(i,:));
                end            
            elseif(strcmp('kz',displaymode))
                for i = 1:length(rgb)
                   plot(kz_holder(i,:), I(i,:),'LineWidth',2,'Color',rgb(i,:));
                end
            else
                error('Incorrect Display Mode');
            end
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)

            if displaypattern
                self.drawTiltAxis(pos0,mag0,figure);
            end
            
            self.setkeV(curkeV);
        end

        function mag = applyScat(self,pos,mag,element)
            % Calculate scattering factor and apply to recip-space magnitude vector
            % Utilizes eDiff_ScatteringFactor by R Hovden.
            % Written by Suk Hyun Sung, sukhsung@umich.edu
            % Jan. 05 2018
            r = sqrt(pos(:,1).^2+pos(:,2).^2 +pos(:,3).^2);
            fe = eDiff_ScatteringFactor(element,r/(2*pi));
            mag = mag.*fe;
        end
        
        
    end
    
    methods (Abstract)
        [pos,mag] = calculate(self);
        mag = calculateHK(self,h,k);
    end
end

