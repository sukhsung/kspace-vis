classdef TaS2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = TaS2(varargin)
            obj = obj@TMD(3.18);
            obj.setName('TaS2');
            obj.setTm(73);
            obj.setCh(16);
            obj.setLambda(6.144);               %Need to be confirmed
            obj.setLambda_tmch(3.241/2);        %Need to be confirmed
            if isempty(varargin)
                obj.setStacking('1H')
            else
                obj.setStacking(val)
            end
        end
    end
end