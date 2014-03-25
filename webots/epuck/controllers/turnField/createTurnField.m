function createTurnField(sim, fsize, direction, angshift, epuck, psInput)

if ~sim.isElement([epuck '.lw'])
  sim.addElement(SumInputs([epuck '.lw'],1),{},{},epuck);
end
if ~sim.isElement([epuck '.rw'])
  sim.addElement(SumInputs([epuck '.rw'],1),{},{},epuck);
end

astep = 2*pi/100;
pirange = -pi:astep:pi-astep;
% alpha = 1.2;
alpha = 1;
% betha = pi/4;
betha = pi/3;

% lw = (sin(-pi:astep:pi-astep)+cos(-pi:astep:pi-astep)) * 300 + 10;
% lw = (sin(-pi:astep:pi-astep)+cos(-pi:astep:pi-astep)) * 400 + 15;
lw = sin(pirange*alpha+betha) * 500;
% lw = (sin(pirange)+cos(pirange)) * 350;
% lw = (sin(-pi:astep:pi-astep)+cos(-pi:astep:pi-astep)) * 1000 + 50;
rw = lw(end:-1:1);

sim.addElement(AngularDisplace([direction '.heading'],fsize,angshift,30,4),'epuck','heading');
sim.addElement(WeightedMax([direction '.max'],1, 2), [direction '.intention']);
sim.addElement(NeuralField([direction '.turn'], fsize, 3, -5, 4),{[direction '.heading'],[direction '.max'],psInput,'ps-exec'});
sim.addElement(LateralInteractions1D([direction '.turn.lateral'],fsize,0,0,0,0,-0.05,true),[direction '.turn'],[],[direction '.turn']);
sim.addElement(WeightedMax([direction '.lw'],1,lw),[direction '.turn'],{},[epuck '.lw']);
sim.addElement(WeightedMin([direction '.rw.min'],1,rw),[direction '.turn'],{},[epuck '.rw']);
sim.addElement(WeightedMax([direction '.rw'],1,rw),[direction '.turn'],{},[epuck '.rw']);
sim.addElement(WeightedMin([direction '.lw.min'],1,lw),[direction '.turn'],{},[epuck '.lw']);

end

