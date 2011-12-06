function direction_arrows2 ( xyuv_file, scale )

%% DIRECTION_ARROWS2 makes an arrow plot of a direction field.
%
%  Discussion:
%
%    The data is stored in one files, containing XY coordinates and UV velocity values.  
%    The file is in the "TABLE" format.
%
%    In particular, each line of the file should contain the X and Y coordinates 
%    and the U and V velocity components for a single point.  Comment lines may be 
%    included if they begin with the special symbol "#".
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    13 September 2005
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, character XYUV_FILE, the name of the coordinate and velocity file.
%
%    Input, real SCALE, a scale factor.
%
  timestamp ( );
  fprintf ( 1, '\n' );
  fprintf ( 1, 'DIRECTION_ARROWS2:\n' );
  fprintf ( 1, '  Arrow plots of a direction field.\n' );
  
  if ( nargin < 1 )
    fprintf ( 1, '\n' );
    xyuv_file = input ( 'Enter name of XYUV file, such as ''xyuv.txt'':  ' );
  end

  if ( nargin < 2 )
    fprintf ( 1, '\n' );
    scale = input ( ...
      'Enter a scale factor for the velocities (1.0 for no magnification): ' );
  end

  xyuv = load ( xyuv_file );
  x = xyuv(:,1);
  y = xyuv(:,2);
  u = xyuv(:,3);
  v = xyuv(:,4);

  mag = sqrt ( u(:).^2 + v(:).^2 );
  mag_max = max ( mag );
%
%  As part of the normalization process, we also intend to ignore velocity
%  vectors whose magnitude is less than 1/10000 of the largest velocity.
%
  i = find ( mag ~= 0 & 0.0001 * mag_max <= mag );
  
  u(i) = u(i) ./ mag(i);
  v(i) = v(i) ./ mag(i);
  
  quiver ( x(i), y(i), u(i), v(i), scale, 'b' );
  axis equal
  hold on

  k = convhull ( x, y );
  plot ( x(k), y(k), 'r' );
  hold on
%
%  Plot an invisible frame.  This will help to force all the plots to
%  be the same size.
%
  x_min = min ( x );
  x_max = max ( x );
  y_min = min ( y );
  y_max = max ( y );
  delta = 0.05 * max ( x_max - x_min, y_max - y_min );
  
  plot ( [ x_min - delta, ...
           x_max + delta, ...
           x_max + delta, ...
           x_min - delta, ...
           x_min - delta ], ...
         [ y_min - delta, ...
           y_min - delta, ...
           y_max + delta, ...
           y_max + delta, ...
           y_min - delta ], ...
         'w' );
         
  hold off

  fprintf ( 1, '\n' );
  fprintf ( 1, 'DIRECTION_ARROWS2:\n' );
  fprintf ( 1, '  Normal end of execution.\n' );

  timestamp ( );

  return
end

