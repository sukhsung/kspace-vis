classdef TaS2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = TaS2(varargin)
            %1T (1537360)
            obj = obj@TMD(3.35);
            obj.setLambda(5.86);
            obj.setLambda_tmch(1.465);

            %2H' (9007815)
%             obj = obj@TMD(3.314);
%             obj.setLambda(6.04850);
%             obj.setLambda_tmch(3.11619/2);
            
            
            obj.setName('TaS2');
            obj.setTm(73);
            obj.setCh(16);

            if isempty(varargin)
                obj.setStacking('1H')
            else
                obj.setStacking(varargin{1})
            end
        end
    end
end