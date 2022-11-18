clear();
clc();

board = [1 2 3 4 5 6 7 0 8];
goal = [1 2 3 4 5 6 7 8 0];
solver = Solver(board, 1000, 20, goal);
solver.solution();
solver.getChromosomeStr(solver.best_select(1).chromosome)
