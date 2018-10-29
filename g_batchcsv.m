function g_batchcsv(path_in, path_out)
global goose

    dirL = dir(path_in);
 
    for i = 1:length(dirL)
        if ~strcmp(dirL(i).name(1),'.')

            filename = dirL(i).name;            
            
            try
                g_open(1, filename, path_in)
                for frame = 1:goose.video.nFrames  %goose.video.nFrames/nFrames
                    analyze_frame(frame)
                end        
                idx = find(goose.analysis.framedone);
                M = [idx; goose.analysis.amp(idx)];
                csvwrite(fullfile(path_out, [filename(1:end-4),'.csv']), M');
                disp(sprintf('%s - done - %s', datestr(now, 13), filename));

            catch
                disp(sprintf('%s - fail - %s', datestr(now, 13), filename));

            end
        end
        goose.current.iFrame = 1;
    end
end


function analyze_frame(frame)
global goose

    goose.current.iFrame = frame;

    if ~goose.analysis.framedone(frame) || goose.set.process.overwrite
        
        refresh_display;
        four(goose.current.img);
        
        ylim = [0, max(goose.analysis.amp*1.2)+.00001];
        set(goose.gui.ax_gamp,'YLim',ylim);
        set(goose.gui.line_pos_ind_gamp,'YData',ylim)

        x = find(goose.analysis.framedone);
        y = goose.analysis.amp(x);
        set(goose.current.plot_gamp, 'XData',x, 'YData',y);
        drawnow;

        goose.current.nFramesDone = length(x);
        set(goose.gui.edit_gamp_done,'String',[num2str(goose.current.nFramesDone),' (',sprintf('%4.2f',goose.current.nFramesDone/goose.video.nFrames*100),'%)'])
        set(goose.gui.edit_gamp,'String',sprintf('%3.2f%', goose.analysis.amp(frame)));

    end

end