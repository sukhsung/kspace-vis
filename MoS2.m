classdef MoS2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = MoS2(varargin)
            obj = obj@TMD(3.161); %N.S. from arizona cryst. db
            obj.setName('MoS2');
            obj.setTm(42);
            obj.setCh(16);
            obj.setLambda(6.1475); %N.S. from arizona cryst. db %6.144);  6.1475             %Need to be confirmed
            obj.setLambda_tmch( 3.07/2); %N.S. from arizona cryst. db       % 3.241/2);        %Need to be confirmed
            if isempty(varargin)
                obj.setStacking('1H')
            else
                obj.setStacking(varargin{1})
            end
        end
    end
end