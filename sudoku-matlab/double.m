% double - convert a string of characters to  double precision values
%
% Inputs:      x - 
% Outputs:     y - double precision array
% Description: 
% Notes:       
% See also:    Matlab's built-in 'double'.
%

% $Id$
% ----------------------------------------------------------------------
function y = double (x)
  if (isnumeric(x))
    % do nothing
    y = x;
    
  elseif (isascii(x))
    y = toascii(x);
    
  else
    % Don't know what to do.
    warning('double: Unexpected input data type.');

  end;
return;
