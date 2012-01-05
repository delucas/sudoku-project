% banner - Write an eye-catching message to stdout.
%
% Inputs:      msg - string
% Outputs:     none
% Description:
% Notes:
% See also:
%

% $Id: banner.m,v 1.2 2006/02/17 09:29:09 pevans Exp $
% ----------------------------------------------------------------------
function banner(msg)
   len = length(msg);
   fprintf('\n\t%s\n', msg);
   fprintf('\t%s\n\n', char('='*ones(1, len)));
 
 return;
