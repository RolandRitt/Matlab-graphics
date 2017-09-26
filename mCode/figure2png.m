function figure2png(H,FileName)

figure(H);
drawnow;
print('-opengl','-dpng','-loose',FileName);