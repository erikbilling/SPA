
TIME_APPEAR = (30, 700)
TIME_DURATION = (2, 500)

import os, sys, random
from runsets import RunSet

def selectRunSet():
    runSet = RunSet()
    while raw_input('Generate obstacle events for {}? (Y/n): '.format(runSet.path)).strip().lower() not in ('','y'):
        name = raw_input('Specify run set [{}]:'.format(runSet.name))
        try:
            runSet = RunSet(name)
        except IOError:
            print '{} does not exist.'.format(name)
    return runSet

def randomizeEvents(runSet):
    eventPath = os.path.join(runSet.path,'events.txt')
    f = file(eventPath, 'w')
    for run in range(1,runSet.runCount+1):
        timeAppear = random.randint(*TIME_APPEAR)
        timeDisappear = timeAppear + random.randint(*TIME_DURATION)
        f.writelines([
            '{0}\t{1}\tMaze_Wall1\t-0.9\t0.03\t0.65\n'.format(run, timeAppear),
            '{0}\t{1}\tMaze_Wall1\t-2\t0.03\t0.65\n'.format(run, timeDisappear)
#            '{0}\t{1}\tMaze_Wall3\t-0.825\t0.03\t0.65\n'.format(run, timeAppear),
#            '{0}\t{1}\tMaze_Wall3\t-2\t0.03\t0.65\n'.format(run, timeDisappear)
        ])
    f.close()
    print '{} events written to {}'.format(run*2,eventPath)

def main():
    runSet = selectRunSet()
    randomizeEvents(runSet)


if __name__ == '__main__':
    main()
