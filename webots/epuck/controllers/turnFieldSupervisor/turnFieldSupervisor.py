# File:         slave.py
# Date:         September 08
# Description:  This controller gives to its node the following behavior:
#               Listen the keyboard. According to the pressed key, send a
#               message through an emitter or handle the position of Robot1
# Author:       fabien.rohrer@cyberbotics.com

from controller import Supervisor,Emitter,Node,Field
import sys, os, copy, math
import struct
from runsets import *

ID_GOAL = 0.0
ID_POSE = 1.0
ID_OBSTACLE_APPEAR = 2.0
ID_OBSTACLE_DISAPPEAR = 3.0


class TurnFieldSupervisor (Supervisor):
    timeStep = 128
    controllerStep = 64

    def __init__(self):
        Supervisor.__init__(self)
        self.emitter = self.getEmitter('emitter')
        self.robot = self.getFromDef('E-PUCK')
        if self.robot is None:
            # robot might be None if the controller is about to quit
            sys.exit(1)

        self.translation = self.robot.getField('translation')
        self.rotation = self.robot.getField('rotation')
        #self.keyboardEnable(self.timeStep)

        self.runSet = RunSet()
        self.setupRobot()
        self.runSet.run()
        print self.runSet
        for e in self.runSet.events:
            print e

    def setupRobot(self):
        self.translation.setSFVec3f(list(worldCoordinates(self.runSet.start)))

    def emitDoubles(self,listOfDoubles):
        s = struct.pack('d'*len(listOfDoubles), *listOfDoubles)
        return self.emitter.send(s)

    def emitPose(self):
        trans = self.translation.getSFVec3f()
        rot = self.rotation.getSFRotation()
        return self.emitDoubles([ID_POSE]+trans+rot)

    def initGoal(self):
        self.emitDoubles([ID_GOAL] + self.runSet.goal)

    def rotatedBox(self,box,rotation):
        angle = rotation[3]%math.pi
        print angle
        if angle < math.pi * 1.0/4.0 or angle > math.pi * 3.0/4.0:
            box = [box[2], box[1], box[0]]
        return box

    def executeEvents(self, t):
        executed = []
        for e in self.runSet.events:
            if e.time <= t:
                print e
                o = self.getFromDef(e.object)
                translation = o.getField('translation')
                e.rotation = o.getField('rotation').getSFRotation()
                e.boxSize = o.getField('boxSize').getSFVec3f()

                pe = self.runSet.executedEvents.get(e.object)
                if pe:
                    self.emitDoubles([ID_OBSTACLE_DISAPPEAR] + pe.targetPosition + self.rotatedBox(pe.boxSize,pe.rotation))
                self.emitDoubles([ID_OBSTACLE_APPEAR] + e.targetPosition + self.rotatedBox(e.boxSize,e.rotation))
                translation.setSFVec3f(e.targetPosition)
                self.runSet.executedEvents[e.object] = e
                executed.append(e)
        for e in executed:
            self.runSet.events.remove(e)

    def logPose(self, t):
        self.runSet.logPose(t, self.translation.getSFVec3f(), self.rotation.getSFRotation())

    def checkGoal(self):
        translation = self.translation.getSFVec3f()
        #print 'Distance to goal: {0:.3f}'.format(self.runSet.goalDistance(translation))
        return self.runSet.goalReached(translation)


    def run(self):
        """Main loop"""

        self.initGoal()

        t = 0
        while True:
            self.emitPose()
            self.executeEvents(t)
            self.logPose(t)

            if t > self.runSet.MAX_TIME or self.checkGoal():
                self.runSet.close()
                self.simulationRevert()
                break

            # perform a simulation step, quit the loop when
            # the controller has been killed
            if self.step(self.timeStep) == -1: break
            t += self.timeStep / self.controllerStep
            #print t

if __name__ == '__main__':
    controller = TurnFieldSupervisor()
    controller.run()
