% testSolve - testing code for solve
%
% Inputs:      
% Outputs:     
% Description: 
% Notes:       
% See also:    
%

% $Id: testSolve.m,v 1.1 2006/03/02 10:46:19 pevans Exp $
% ----------------------------------------------------------------------
function testSolve ()
  test_MoPo_2006_02_28;
  test_Tip_2006_01_09;
return;


% ----------------------------------------------------------------------
% Function:    test_Tip_2006_01_09
% Inputs:      none
% Outputs:     pass - logical 1=true/0=false
%              message - string, what went wrong
% Description: Check that ...
% Notes:       From Tip der Woche, 9. Januar 2006
% See also:    
%
% ----------------------------------------------------------------------
function [pass, message] = test_Tip_2006_01_09()
  pass = true;
  message = '';
  
  banner('Tip_2006_01_09');
  m = [  4, 0, 8,  5, 2, 0,  0, 3, 0 ; ...
         5, 2, 6,  0, 3, 0,  0, 9, 8 ; ...
         1, 3, 0,  4, 0, 0,  0, 2, 0 ; ...
         ...
         9, 8, 5,  2, 0, 1,  3, 0, 0 ; ...
         2, 6, 0,  3, 7, 4,  0, 0, 0 ; ...
         3, 7, 4,  0, 8, 0,  0, 6, 1 ; ...
         ...
         8, 5, 2,  0, 0, 3,  7, 0, 0 ; ...
         6, 1, 0,  7, 4, 9,  8, 5, 2 ; ...
         0, 4, 9,  0, 5, 0,  6, 1, 3  ];
         
  solve(m);
  
  % At 2006-03-02 Thursday:
  % gets as far as I do by hand.

return;

% ----------------------------------------------------------------------
% Function:    test_MoPo_2006_02_28
% Inputs:      none
% Outputs:     pass - logical 1=true/0=false
%              message - string, what went wrong
% Description: Check that ...
% Notes:       From Berliner Morgenpost, 28. Februar 2006, p. 7
% See also:    
%
% ----------------------------------------------------------------------
function [pass, message] = test_MoPo_2006_02_28()
  pass = true;
  message = '';
  
  banner('MoPo_2006_02_28');
  m = [  9, 0, 2,  0, 0, 0,  5, 0, 4 ; ...
         0, 0, 0,  7, 9, 1,  0, 0, 0 ; ...
         3, 0, 0,  5, 0, 2,  0, 0, 8 ; ...
         ...
         0, 3, 6,  0, 0, 0,  4, 7, 0 ; ...
         0, 5, 0,  0, 0, 0,  0, 2, 0 ; ...
         0, 9, 7,  0, 0, 0,  3, 8, 0 ; ...
         ...
         6, 0, 0,  4, 0, 3,  0, 0, 7 ; ...
         0, 0, 0,  6, 2, 7,  0, 0, 0 ; ...
         7, 0, 4,  0, 0, 0,  1, 0, 3  ];
         
  solve(m);
  
  % At 2006-03-02 Thursday:
  % gets as far as I do by hand.

return;

% ----------------------------------------------------------------------
