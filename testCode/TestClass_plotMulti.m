classdef TestClass_plotMulti < matlab.unittest.TestCase
    %
    % Description : Test the plotSegments function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{14-May-2018}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        testData
        x
    end
    
    methods (TestClassSetup)
        function setUpData(testCase)
            
            x = (1:1000)';
            n = numel(x);
            data(:,1) = randi(9,size(x));
            data(:,2) = randn(size(x));
            data(:,3) = randi(10000, size(x));
            data(:,4) = randi(999, size(x));
            testCase.testData =data;
            testCase.x = x;
            
        end
    end
    
    methods (Test)
        
        function testFunctionality(testCase)
            nrPts = 200;
            u = linspace(0,1,nrPts)';
            %
            degree = 8;
            %
            try
                B = bernsteinBasis( u, degree );
            catch
                B = vander(u);
                B = B(:,end-degree+1:end);
            end
            %
            xLabel = '$$t \, [s]$$';
            for k=1:degree+1
                yLabels{k} = ['$$b_',int2str(k),'$$'];
            end;
            F = figureGen;
            plotMulti( u, B, xLabel, yLabels );
            
            F = figureGen;
            
            %
            
            for i=1:degree
                D{i} =  B(:,randi([1,degree], randi([1,degree]),1));
            end
            plotMulti( u, D, xLabel, yLabels );
            
            
        end
        
        function testYlabelDirectionVertical(testCase)
            F = figureGen;
            ax_out = plotMulti(testCase.x,testCase.testData, 'time', {'testLabel1', 'testgTL', 'A','asdf'});
            
            posArr = nan(length(ax_out),4);
            posArryLabel= nan(length(ax_out),4);
            for i=1:length(ax_out)
                posArr(i,:) = get(ax_out(i), 'Position');
                tempYL = get(ax_out(i),'ylabel');
                testCase.verifyEqual(get(tempYL, 'Rotation'),90); %check rotation
                set(tempYL, 'Units', 'Normalized');
                posArryLabel(i,:) = get(tempYL, 'Extent');
            end
            for i=1:length(ax_out) -1 %check if axes have same x-size and width
                testCase.verifyEqual(posArr(i,1), posArr(i+1,1));
                testCase.verifyEqual(posArr(i,3), posArr(i+1,3));   
            end
            
            for i=1:length(ax_out) %check if labels are not outside the plot
                %pos labels not outside
                testCase.verifyGreaterThanOrEqual(posArr(i,1) + posArryLabel(i,1)*posArr(i,3),0-10e3);
                testCase.verifyLessThanOrEqual(posArr(i,1) + posArr(i,3) + (posArryLabel(i,1)+posArryLabel(i,3))*posArr(i,3),1+10e3);
            end
            
        
        end
        
        function testYlabelDirectionHorizontal(testCase)
            F = figureGen;
            ax_out = plotMulti(testCase.x,testCase.testData, 'time', {'testLabel1', 'testgTL', 'A','asdf'}, 'bYLabelHorizontal', true);
            
            posArr = nan(length(ax_out),4);
            posArryLabel= nan(length(ax_out),4);
            for i=1:length(ax_out)
                posArr(i,:) = get(ax_out(i), 'Position');
                tempYL = get(ax_out(i),'ylabel');
                testCase.verifyEqual(get(tempYL, 'Rotation'),0); %check rotation
                set(tempYL, 'Units', 'Normalized');
                posArryLabel(i,:) = get(tempYL, 'Extent');
            end
            for i=1:length(ax_out) -1 %check if axes have same x-size and width
                testCase.verifyEqual(posArr(i,1), posArr(i+1,1));
                testCase.verifyEqual(posArr(i,3), posArr(i+1,3));   
            end
            
            for i=1:length(ax_out) %check if labels are not outside the plot
                %pos labels not outside
                testCase.verifyGreaterThanOrEqual(posArr(i,1) + posArryLabel(i,1)*posArr(i,3),0-10e3);
                testCase.verifyLessThanOrEqual(posArr(i,1) + posArr(i,3) + ((posArryLabel(i,1)+posArryLabel(i,3))-1)*posArr(i,3),1+10e3);
            end
            
        
        end
    end
end