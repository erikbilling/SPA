function move = setupMove(sim,direction,fsize,shift)
  sigma_exc = 2;
  ic = 3;
  tau = 5; % struct('motivation',5,'precondition',5,'intention',5,'cos',20);
  
  epuckShift = ceil(shift * -0.2);
  lateralConnectionShift = shift;
  move = EBMove(sim,direction,fsize,tau, -5, 4, sigma_exc, ...
    {'motivation',{'stimulus 1','stimulus 2','map-output'},'cos','epuck-exec'}, ...
    {'motivation','precondition',{'shift',shift},'precondition','intention',{'shift',-shift}, 'intention','cos',ic});
  move.createLateralConnections(lateralConnectionShift);
  sim.addElement(ShiftInput([direction '.inhib'],fsize,epuckShift,-15,false),[direction '.cos'],{},[direction '.precondition']);
end

