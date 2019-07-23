classdef WSe2 < TMD        
    properties (SetAccess = private, GetAccess = public)
    end
    methods
        function obj = WSe2(varargin)
            %1T ()
%             obj = obj@TMD();
%             obj.setLambda();
%             obj.setLambda_tmch();

            %LAMBDA INCORRECT!!!!
            obj = obj@TMD(3.282);
            obj.setLambda(6.47);
            obj.setLambda_tmch(3.34109/2);
            disp('lambdas are not correct')
            
            %copying MoS2
%             obj = obj@TMD(3.161);
%             obj.setLambda(6.1475); %N.S. from arizona cryst. db %6.144);               %Need to be confirmed
%             obj.setLambda_tmch( 3.0123/2); %N.S. from arizona cryst. db       % 3.241/2);        %Need to be confirmed

            
            obj.setName('WSe2');
            obj.setTm(74);
            obj.setCh(34);

            if isempty(varargin)
                obj.setStacking('1T')
            else
                obj.setStacking(varargin{1})
            end
        end
    end
end