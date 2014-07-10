
import os, math

class RunSet(object):
    PATH = "../../runSets"
    GOAL_RADIUS = 7
    GOAL_REACHED_LIMIT = 20
    #GOAL_REACHED_LIMIT = 2000
    MAX_TIME = 2000

    def __init__(self, runSet=None, runId=None):
        self.name = runSet or self.getActiveRunSet()
        self.path = os.path.abspath(os.path.join(self.PATH, self.name))
        self.runId = runId or self.getId()
        self.runCount = 0
        self.log = None
        self.start = self.getStart()
        self.goal = self.getGoal()
        self.events = self.getEvents()
        self.executedEvents = {}
        self.goalReachedCounter = self.GOAL_REACHED_LIMIT

    def __repr__(self):
        return 'Run {} with {} events{}'.format(self.runId, len(self.events), self.log and ': Logging to {}'.format(self.log.name) or '')

    def run(self):
        if self.runId:
            self.log = file(os.path.join(self.path, 'run{}.mat'.format(self.runId)), 'w')
        else:
            print 'Unable to open log file, missing run id!'

    def logPose(self, t, translation, rotation):
        if self.log:
            x, y = fieldCoordinates(translation)
            row = [str(t)] + ['{0:.8f}'.format(v) for v in [y, translation[1], x] + rotation]
            self.log.write('\t'.join(row))
            self.log.write('\n')

    def getActiveRunSet(self):
        activeSets = realLines(file(os.path.join(self.PATH, 'runSet.txt')).readlines())
        if activeSets:
            return activeSets[0]
        else:
            raise "No active run set specified"

    def getId(self):
        for run in range(1, 1000):
            if not os.path.exists(os.path.join(self.path, 'run{}.mat'.format(run))):
                return run

    def getPosition(self, posFile):
        if self.runId:
            positions = realLines(file(os.path.join(self.path, posFile)).readlines())
            self.runCount = max(self.runCount, len(positions))
            if len(positions) >= self.runId:
                p = positions[self.runId-1].split('\t')
            else:
                p = positions[-1].split('\t')
            return [float(v) for v in p]

    def getStart(self):
        return self.getPosition('startPositions.mat')

    def getGoal(self):
        return self.getPosition('goalPositions.mat')

    def goalDistance(self, translation):
        x, y = fieldCoordinates(translation)
        dx = self.goal[1] - x
        dy = self.goal[0] - y
        return math.sqrt(dx * dx + dy * dy)

    def goalReached(self, translation):
        if self.goalDistance(translation) < self.GOAL_RADIUS:
            self.goalReachedCounter -= 1
        return self.goalReachedCounter <= 0

    def getEvents(self):
        try:
            events = realLines(file(os.path.join(self.path, 'events.txt')).readlines())
            events = [e.split('\t') for e in events]
            return [Event(e) for e in events if int(e[0]) == self.runId]
        except IOError:
            return []

    def close(self):
        if self.log:
            self.log.close()

class Event(object):
    def __init__(self, event):
        self.time = int(event[1])
        self.object = event[2]
        self.targetPosition = [float(v) for v in event[3:6]]

    def __repr__(self):
        return 'Move of {1} to {2},{3},{4} at time {0}'.format(self.time, self.object, *self.targetPosition)


## -- Helper functions -- ##

def realLines(lines):
    """Parses out any commented lines and removes any initial blanks of specified list of strings"""
    rl = []
    for r in lines:
        r = r.strip()
        if r and r[0] != '#':
            rl.append(r)
    return rl

def worldCoordinates(fieldCoord):
    print fieldCoord
    y = (fieldCoord[0]-10)/100.0-0.95
    x = (fieldCoord[2]-10)/-100.0+0.95
    return y, 0.03, x

def fieldCoordinates(translation):
    y = (translation[0]+0.95)*100+10
    x = (translation[2]-0.95)*-100+10
    return x, y

