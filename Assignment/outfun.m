% Plotting of optimisation progress

function stop = outfun(x,optimValues,state)
     persistent history searchdir
     stop = false;
 
     switch state
         case 'init'
             hold on
             history.x = [];
             history.fval = [];
             searchdir = [];
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];
         % Concatenate current search direction with 
         % searchdir.
           searchdir = [searchdir;... 
                        optimValues.searchdirection'];
           plot(x(1),x(2),'o');
         % Label points with iteration number and add title.
         % Add .15 to x(1) to separate label from plotted 'o'.
           text(x(1)+.15,x(2),... 
                num2str(optimValues.iteration));
           title('Sequence of Points Computed by fmincon');
         case 'done'
             hold off
             assignin('base', 'optimhistoryx', history.x);
             assignin('base', 'optimhistoryfval', history.fval);
             assignin('base', 'optimsearchdir', searchdir);
         otherwise
    end
end