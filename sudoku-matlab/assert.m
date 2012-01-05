% assert        - throw if a condition is not true. 
% 
% Arguments:	expression  - an expression evaluating to true or false
%               msg - OPTIONAL string to describe what went wrong.
% Returns:	none
% Description:	exit if expression is false
% Warnings:	
% See Also:	

% File:		$RCSfile: assert.m,v $
% Revision:	$Revision: 1.4 $
% Last Edited:	$Date: 2005/06/17 13:42:24 $, $Author: pevans $
% Original Author:	R. J. Valkenburg
% Original Copyright:	(c) 2003 Industrial Research Limited
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function assert(expression, varargin)

  if (expression==0)
    %fprintf('Length varargin: %i\n', length(varargin));

    msg = '[no message provided]';
    stderr = 2;
    
    if (length(varargin) > 0)
      if (isa(varargin{1}, 'char'))
        msg = varargin{1};
      end; % if
      fprintf(stderr, 'assertion failed: %s\n', msg );
    end; % if

    error('failed ASSERT');
  end;  
return
  
