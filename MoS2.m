classdef MoS2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = MoS2(varargin)
            obj = obj@TMD(3.161); %N.S. from arizona cryst. db
            obj.setName('MoS2');
            obj.setTm(42);
            obj.setCh(16);
            obj.setLambda(6.1475); %N.S. from arizona cryst. db %6.144);               %Need to be confirmed
            obj.setLambda_tmch( 3.07/2); %N.S. from arizona cryst. db       % 3.241/2);        %Need to be confirmed
            if isempty(varargin)
                obj.setStacking('1H')
                obj.setKzExtent(2*pi/obj.lambda_tmch)
            else
                obj.setStacking(varargin{1})
                if strcmp(varargin{1},'1T') || strcmp(varargin{1},'1H')
                    obj.setKzExtent(2*pi/obj.lambda_tmch)
                else
                    obj.setKzExtent(4*pi/obj.lambda);
                end
            end
        end
    end
end