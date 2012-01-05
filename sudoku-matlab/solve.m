% solve - Solver of Sudoku puzzles
%
% Inputs:      m - 9x9 problem matrix
% Outputs:     fail - 0/1 on sucess/failure
%              m - modified matrix
% Description: Attempt to solve a Sudoku puzzle.
%              Input matrix m consists of integers from 0 to 9, with
%              0 used to denote a blank (unallocated) element.
%              On output, m should have more (ideally, all)
%              elements filled with integers from 1 to 9.
%              Each row, column and 3x3 "subsquare" should contain
%              each integer from 1 to 9 exactly once.
%
% Notes:       No fancy internal representation yet, so
%              matrixToInternal and internalToMatrix are unused.
% See also:    1. http://www.websudoku.com/
%              2. Your local newspaper.
% Author:      Peter L. Evans

% $Id: solve.m,v 1.2 2006/06/02 13:58:42 pevans Exp $
% ----------------------------------------------------------------------
function [fail, m] = solve (m)
  fail = 0;
  
  if (~isValid(m))
    %showRules;
    m
    fail = 1;
    error('invalid input matrix');
  end;
  
  s = matrixToInternal(m);
  m2 = internalToMatrix(s);
  
  assert(m == m2, ...
         'failed conversion to/from internal representation');

  [done, remaining_old] = isDone(m);
  
  % **** Following loop structure is wonky...
  
  while (~done)
    % do some work, then see if it's made any improvement.
    
    m = usePointConstraints(m);
    
    [done, remaining] = isDone(m);
        
    if (remaining == remaining_old)
      fprintf('No improvement; still %i element(s) remaining\n', ...
              remaining);
      fprintf('Giving up.\n');
      fail = 1;
      break;
    else
      remaining_old = remaining;
    end;
  end;
  
  m
  
return;


% ----------------------------------------------------------------------
% Function:    usePointConstraints
% Inputs:      m
% Outputs:     m_new
% Description: Each element of m must satisfy its row, column and
%              subsquare constraints.  This routine looks at each
%              location, and finds the set S of symbols which could be
%              placed in that location while still satisfying all
%              three constraints.  If |S| = 1, there's only one
%              symbol possible, so it can be placed here.
%              If |S| = 0, no symbol can go here, and something has
%              gone seriously wrong.
%              If |S| > 1, we can't determine what symbol to put
%              here just using "local knowledge"; some other
%              constraints will be needed.
% Notes:       This routine may fill in multiple elements of m at
%              each call.
% See also:    
%
% ----------------------------------------------------------------------
function m_new = usePointConstraints (m)
  filled = 0;
  m_new = m;
  
  for row = 1:9,
    for col = 1:9,
      if (m(row, col) == 0)
        % element is blank, try to fill it.
        fill = usePointConstraintsLoc(m_new, row, col);
        if (fill > 0)
          m_new(row, col) = fill;
        elseif (fill < 0)
          fprintf('No symbol possible for element (%i,%i)\n', ...
                  row, col);
          m
          m_new
          error('Inconsistent state!');
        end;
        % else
        % (can't conclude anything purely locally)
        % end;

      end;
    end;
  end;
  
  if (filled > 0)
    fprintf('Filled in %i element(s)\n', filled);
  end;
return;


% ----------------------------------------------------------------------
% Function:    usePointConstraintsLoc
% Inputs:      m - 9x9 matrix
%              row, col - indices into m.
% Outputs:     fill
% Description: Check constraints at element (row, col)
% Notes:       
% See also:    
%
% ----------------------------------------------------------------------
function fill = usePointConstraintsLoc (m, row, col)
  rowSet = availableSymbols(m(row,:));
  colSet = availableSymbols(m(:,col));
  sqrSet = availableSymbols(sqrElements(m, row, col));
  
  V = rowSet & colSet & sqrSet;
  sizeV = length(find(V~=0));
  if (sizeV == 0)
    fill = -1;
    % error, inconsistent!
    
  elseif (sizeV == 1)
    fill = (find(V~=0));
    % return the index of the only possible symbol
    
  else
    fill = 0;
    % (can't conclude anything purely locally)
  end;
return;


% ----------------------------------------------------------------------
% Function:    sqrElements
% Inputs:      
% Outputs:     
% Description: 
% Notes:       
% See also:    
%
% ----------------------------------------------------------------------
function v = sqrElements (m, row, col)
  v = zeros(1,9);
  
  subSquareRow = 3*floor((row-1)/3);
  subSquareCol = 3*floor((col-1)/3);
  
  k = 0;
  for col = subSquareCol+(1:3),
    for row = subSquareRow+(1:3),
      k = k+1;
      v(k) = m(row, col);
    end;
  end;
return;


% ----------------------------------------------------------------------
% Function:    availableSymbols
% Inputs:      
% Outputs:     
% Description: Fill list with true where a symbol is not yet used
%              in v.
% Notes:       
% See also:    
%
% ----------------------------------------------------------------------
function list = availableSymbols (v);
  list = zeros(1:9);
  
  assert(9 == length(v));
  
  for k = 1:length(v), 
    if (isempty(find(v == k)))
      list(k) = true;
    end;
  end;
return;




% ----------------------------------------------------------------------
% Function:    showRules
% Inputs:      
% Outputs:     
% Description: Print some helpful information
% Notes:       
% See also:    
%
% ----------------------------------------------------------------------
function showRules ()
  fprintf('\nSolver for sudoku puzzles\n\n');
  
  fprintf('Expects 1 argument, a 9x9 matrix\n');
  fprintf('Matrix entries must be the integers 0, 1, ..., 9\n');
  fprintf(['There must be no more than one of each of the integers\n', ...
           '1, 2, ..., 9 in each row, column and subsquare.\n', ...
           '"subsquare" means one of the 9 3x3 submatrices formed\n', ...
           'by carving the 9x9 matrix up in the obvious way.\n']);
  
return;


% ----------------------------------------------------------------------
% Function:    isDone
% Inputs:      m - 9x9 matrix
% Outputs:     done - logical true/false
%              remaining - integer, number of elements still blank.
% Description: Determines whether problem is solved, i.e.
%              - satisfies all constraints, and
%              - all entries are filled.
% Notes:       Could just compute 'remaining' and use remaining > 0
%              as a test for completion.
% See also:    
%
% ----------------------------------------------------------------------
function [done, remaining] = isDone (m)
  done = isValid(m);
  
  if (~done)
    remaining = 999;
    return;
  end;
  
  
  remaining = length(find(m == 0));
  done = (remaining == 0);
  
  if (~done)
    % Give a break-down of what's missing
    count = zeros(1, 9);
    for k = 1:9,
      count(k) = length(find(m == k));
    end;
    fprintf('There are %i element(s) still blank.\n', remaining);
    fprintf('Number of each symbol used:\t');
    %fprintf(' %3i', 1:9);
    %fprintf('\n');
    fprintf(' %3i', count);
    fprintf('\n');
  end;
return;



% ----------------------------------------------------------------------
% Function:    isValid
% Inputs:      m - 9x9 matrix
% Outputs:     valid - logical true/false
% Description: Inspect the matrix to determine whether all the
%              constraints are satisfied:
%              - at most one of each integer 1..9 in each row
%              - at most one of each integer 1..9 in each column
%              - at most one of each integer 1..9 in each subsquare
%
%              For each constraint, build an array, 'count', to
%              tally the number of each integer found in this
%              subunt (row, column or subsquare) found, and then
%              check at most one of each.
%
%              Subsquares are numbered
%                  1  2  3
%                  4  5  6
%                  7  8  9
%
% Notes:       Should I have one of these for the internal
%              representation?
%              Should I return some warning of what's wrong?
% See also:    
%
% ----------------------------------------------------------------------
function valid = isValid (m)
  valid = (size(m) == [9, 9]);
  if (~valid)
    fprintf('isValid: size must be 9x9\n');
    return;
  end;
  
  
  valid = ((min(min(m)) >= 0) && (max(max(m)) <= 9));
  if (~valid)
    fprintf(['isValid: ', ...
            'all entries must be integers between 0 and 9\n']);
    return;
  end;
  
  
  % 1. check rows
  for row = 1:9,
    count = zeros(1, 9);
    for col = 1:9,
      data = m(row, col);
      if (data > 0)
        count(data) = count(data)+1;
      end;
    end;
    valid = (max(count) <= 1);
    if (~valid)
      fprintf('isValid: row %i looks bad\n', row);
      return;
    end;  
  end;
  
  
  % 2. check columns
  for col = 1:9,
    count = zeros(1, 9);
    for row = 1:9,
      data = m(row, col);
      if (data > 0)
        count(data) = count(data)+1;
      end;
    end;
    valid = (max(count) <= 1);
    if (~valid)
      fprintf('isValid: col %i looks bad\n', col);
      return;
    end;  
  end;
  
  
  % 3. check subsquares
  % TODO: use v = sqrElements somehow
  for k = 0:8,
    count = zeros(1, 9);
    rowBase = 3*floor(k/3);
    colBase = 3*mod(k,3);
    for col = colBase+(1:3),
      for row = rowBase+(1:3),
        data  = m(row, col);
        if (data > 0)
          count(data) = count(data)+1;
        end;
      end;
    end;
%DEBUG    fprintf('isValid: subsquare %i: rowBase %i colBase %i', ...
%DEBUG            k, rowBase, colBase);
%DEBUG    fprintf(' %i ', count);
%DEBUG    fprintf('\n');
    
    valid = (max(count) <= 1);
    if (~valid)
      fprintf('isValid: subsquare %i looks bad\n', k+1);
      return;
    end;  
  end;
  
return;



% ----------------------------------------------------------------------
% Function:    matrixToInternal
% Inputs:      m - 9x9 matrix
% Outputs:     s - internal representation
% Description: Convert a matrix to whatever representation I decide
%              to use internally.
%              Matrix m must consist of integers from 0 to 9, with
%              0 used to denote a blank (unallocated) element.
% Notes:       
% See also:    
%
% ----------------------------------------------------------------------
function s = matrixToInternal (m)
  s = 2.^m;
return;


% ----------------------------------------------------------------------
% Function:    internalToMatrix
% Inputs:      s - internal representation
% Outputs:     m - 9x9 matrix
% Description: Convert internal representation to a matrix.
%              (e.g. for output)
%              Matrix m consists of integers from 0 to 9, with
%              0 used to denote a blank (unallocated) element.
% Notes:       
% See also:    matrixToInternal
%
% ----------------------------------------------------------------------
function m = internalToMatrix (s)
  m = log2(s);
return;


% ----------------------------------------------------------------------
