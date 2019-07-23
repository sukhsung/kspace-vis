classdef TaSe2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = TaSe2(varargin)
            %1T ()
%             obj = obj@TMD();
%             obj.setLambda();
%             obj.setLambda_tmch();

            %2H' (2310532)
            obj = obj@TMD(3.43);
            obj.setLambda(6.355);
            obj.setLambda_tmch(3.35544/2);
            
            
            %copying MoS2
%             obj = obj@TMD(3.161);
%             obj.setLambda(6.1475); %N.S. from arizona cryst. db %6.144);               %Need to be confirmed
%             obj.setLambda_tmch( 3.0123/2); %N.S. from arizona cryst. db       % 3.241/2);        %Need to be confirmed

            
            obj.setName('TaSe2');
            obj.setTm(73);
            obj.setCh(34);
    %Need to be confirmed
            if isempty(varargin)
                obj.setStacking('1H')
                obj.setKzExtent(pi/obj.lambda_tmch)
            else
                obj.setStacking(varargin{1})
                if strcmp(varargin{1},'1T') || strcmp(varargin{1},'1H')
                    obj.setKzExtent(pi/obj.lambda_tmch)
                else
                    obj.setKzExtent(4*pi/obj.lambda);
                end
            end
        end
    end
end