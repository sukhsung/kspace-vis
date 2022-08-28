classdef MoSe2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = MoSe2(varargin)
            % Lattice parameters from https://materialsproject.org/materials/mp-1634/
            obj = obj@TMD(3.32695); %N.S. from arizona cryst. db
            obj.setName('MoSe2');
            obj.setTm(42);
            obj.setCh(16);
            obj.setLambda( 15.45142/2 ); %
            obj.setLambda_tmch( 3.34523/2); 
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