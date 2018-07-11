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
        lambda
        title_str
        intensityFactor = 1;
        tilt_start
        tilt_end
        tilt_val
        rotation
        BW
        BWColor
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
        function setB(self,val)
            self.b=val;
        end 
        function setB1(self,val)
            self.b1=val;
        end 
        function setB2(self,val)
            self.b2=val;
        end 
        function setLambda(self,val)
            self.lambda=val;
        end 
        function setIntensityFactor(self,val)
            self.intensityFactor = val;
        end
        function setTiltVal(self,val)
            self.tilt_val = val;
        end
        
        function setTiltStart(self,val)
            self.tilt_start = val;
        end
        function setTiltEnd(self,val)
            self.tilt_end = val;
        end
        function setRotation(self,val)
            self.rotation = val;
        end
        function setBW(self,val)
            self.BW = val;
        end
        function setBWColor(self,val)
            self.BWColor =val;
        end
        
        function [pos,h,k] = recip2DMeshGrid(self)
            [pos,h,k] = indexedMeshGrid(self.spotcut,self.b1,self.b2);
            pos = round(pos,self.rnd);
            [~,ia,~] = unique(pos,'rows');
            pos = pos(ia,:);
            h   = h(ia);
            k   = k(ia);
        end
        
        function [ kz ,cospsi ] = kzProvider(self,kx,ky)
            switch self.kzMode
                case 'constant'
                    kz = self.kzval*ones(length(kx),1);
                case 'ewald'
                    k_rho_sq = (kx.^2+ky.^2);    
                    K = eDiff_Wavenumber(self.keV);
                    kz = K-sqrt(K^2 -k_rho_sq);
                case 'tilted_ewald'
                    k = eDiff_Wavenumber(self.keV);
                    phi = self.tilt_val;
                    theta = self.rotation;
                    qzo = k*cos(phi);
                    qxo = k*sin(phi)*cos(theta);
                    qyo = k*sin(phi)*sin(theta);
                    qo = [qxo, qyo, qzo];
                    kz = qzo - sqrt(k^2 - (kx-qxo).^2 - (ky-qyo).^2);
                    
                    K = [kx,ky,kz];
                   
                    
                    
                    dr = K-qo;
                    dr = dr./norm(dr);

                    cospsi = dr(:,3);
                  %  cospsi = ones(size(cospsi));
                    
                case 'tilted_constant'
                    k = eDiff_Wavenumber(self.keV);
                    phi = self.tilt_val;
                    theta = self.rotation;
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

            % construct rotation matrix
            rotmatrix = [cos(theta),-sin(theta);sin(theta),cos(theta)];

            % extract xy coordinates only
            xy = pos(:,1:2);
            % rotate xy coordinates
            xy_rot = xy*rotmatrix;
            % assign output
            pos(:,1:2) = xy_rot;
        end
        
        function posmagDraw(self,pos,mag)
            % load global variables
            % handle empty variables
            % suppress zero beam
            if self.killZero == 1 
                mag(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0) = 0;
            end
            % calculate intensity and normalize
            int = mag.*conj(mag);
            int = int/max(int).*1000;

            % remove intensities below cutoff
            pos(int<=self.intcut,:) =[];
            mag(int<=self.intcut,:) = [];
            int(int<=self.intcut) = [];

            % scatter point area is proportional to int
            int = self.intensityFactor .* sqrt(int);
            
            
            %my colors
            phase = angle(mag);
            rgb = phase2color(phase);
            
            rgb = pos2color(pos);


            % Draw
            figure
            hold on
            %rgb = zeros(3,length(rgb));
            %rgb(:,85) = [141,141,141];
            scatter(pos(:,1),pos(:,2),2500*int,rgb,'.')
            axis equal
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end

function p = posmagDrawPhase(self,pos,mag,cur_fig)
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
            
            if self.BW
                rgb = self.BWColor*ones(size(rgb));
            end
            
            if self.killZero == 2
                   rgb(round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0,:) = .8275; %setting center beam to gray
            end            
            if self.killZero == 30
                   rgb(round(pos(:,1),2) == 3,:) = .8275; %setting center beam to gray 
            end
            
            % scatter point area is proportional to int
            int = self.intensityFactor .* sqrt(int);

            % Draw
            if ~cur_fig
            figure
            end
            hold on
            p = scatter3(pos(:,1),pos(:,2),pos(:,3),2500*int,rgb,'.'); %4500 for graphenes
           % axis equal
            
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end
        function draw(self)
            [pos,mag] = self.calculate();
            self.posmagDraw(pos,mag);
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end
        function p = drawEwald(self)
            self.setKzMode('tilted_ewald');
            [pos,mag] = self.calculate();
            p= self.posmagDrawPhase(pos,mag,true);
            if isempty(self.title_str)
                self.setTitle('')
            end
            title(self.title_str)
        end
        

        function [pos, mag] = draw3D(self)
            self.setKzMode('constant');
            kzStep = 2^6;
            pos =[];    mag = [];
            for i = -kzStep:kzStep
                self.setKzVal(pi/(kzStep/2)*i/self.lambda);
                [pos_cur,mag_cur] = self.calculate;
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
            end
            self.posmagDrawPhase(pos,mag,true);
            title(self.title_str)
        end
        
        function [pos, mag] = drawCrossSection(self, angle)
            self.setKzMode('constant')
            kzStep = 2^6;%64.*64;
            pos =[];    mag = [];
            for i = -kzStep:kzStep
                %meaning:
                %= pi * (i/kzstep) * 4 * 1/lambda 
                self.setKzVal(pi/(kzStep)*i/(self.lambda./2)); %-/+ kz step should be pi, total range should be ???
                [pos_cur,mag_cur] = self.calculate;
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
            end
            
            
            
            %cutting out all peaks not in correct 2D plane
            tolerance = 0.5;
            %subset = pos(:,1) < tolerance & pos(:,1) > -tolerance & pos(:,2) < maxXY & pos(:,2) > -maxXY;
            
            subsetAngle = (tan(pos(:,2)./pos(:,1)) > angle .* pi./ 180-tolerance & tan(pos(:,2)./pos(:,1)) <  angle .*pi./180+tolerance);
            subsetCenter = (round(pos(:,1),2) == 0 & round(pos(:,2),2) ==0);
            pos = pos(subsetAngle | subsetCenter,:);
            mag = mag(subsetAngle | subsetCenter);
            %plane =  
            %correct_positions = 
            
            self.posmagDrawPhase(pos,mag,false);
            title(self.title_str)
        end
        
        function [tiltrange, I, kz] = getTiltSeries(self, kzmode, displaymode)            
            self.setKzMode(['tilted_' kzmode]);
            tiltrange = self.tilt_start:.1*pi/180:self.tilt_end;
            I = [];
            kz_holder  = [];
            pos0 = [];
            mag0 = [];
            %rgb = [];
            for tilt = tiltrange
                self.tilt_val = tilt;
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
                kz_holder = [kz_holder, pos(:,3)];
                mag = mag;
                I = [I, mag.*conj(mag)];
            end
            I = I./cos(tiltrange);
            I = I./max(I(:));
            %rgb = phase2color(phase);

            phase = angle(mag0);%[phase,angle(mag)];
            rgb = phase2color(phase);
            if(displaymode == 'angle')
                f1 = figure;            
                rgb = pos2color(pos0);
                for i = 1:length(rgb)
                   plot(tiltrange(:).*180/pi, I(i,:),'LineWidth',3,'Color',rgb(i,:));
                   hold on;
                end
            
            elseif(displaymode=='kz')
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
            self.intensityFactor = .1;
            self.posmagDraw(pos0,mag0);
        end
        
        function drawRod(self,hkDraw)
            self.setKzMode('constant');
            kzStep = 2^6;
            
            hDraw = hkDraw(:,1);
            kDraw = hkDraw(:,2);
            
            pos =[];    mag = [];   h=[]; k= [];
            numDraw = length(hDraw);
            for i = -kzStep:kzStep
                self.setKzVal(pi/(kzStep/4)*i/self.lambda);
                [pos_cur,mag_cur,h_cur,k_cur] = self.calculate;
                
                
                hk_mat = [h_cur, k_cur];
                hk_draw = [hDraw, kDraw];
                outs = logical(zeros(length(hk_mat),1));
                for it = 1:length(hk_mat)
                    for jt = 1:length(hk_draw)
                        if hk_mat(it,:) == hk_draw(jt,:)
                            outs(it) = true;
                        end
                    end
                       
                end
                
                pos_cur = pos_cur(outs,:);
                mag_cur = mag_cur(outs);
                
                pos = [pos;pos_cur];
                mag = [mag;mag_cur];
                h   = [h  ;h_cur(outs)];
                k   = [k  ;k_cur(outs)];
            end
            
            
            
            for it = 1:numDraw
                pos(h == hDraw(it) & k == kDraw(it) , 1) = it*ones(size(pos(h == hDraw(it) & k == kDraw(it)),1),1);
            end
            pos(:,2) = pos(:,3);
            pos(:,3) = zeros(size(pos(:,1)));
            
%             pos(:,1) = zeros(length(mag),1);
%             pos(:,2) = pos(:,3);
%             pos(:,3) = pos(:,1);
            self.posmagDrawPhase(pos,mag,true);
            title(self.title_str)
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
        [pos,mag,h,k] = calculate(self);
    end
end

