classdef Puzzle < handle
    properties
      puzzle
      goal
    end
    methods
      function obj = Puzzle(puzzle, goal)
        obj.puzzle = reshape(puzzle, [3 3])';
        obj.goal = reshape(goal, [3 3])';
      end
      function move(obj, direction)
        if ~isa(direction, 'Direction')
            ex = MException('MyComponent:invalidInstance','direction must be an instance of Direction Enum');
            throw(ex);
        end
        [x, y] = find(obj.puzzle == 0);
        if direction == Direction.Up
          if x == 1
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end
          obj.swap([x, y], [x-1, y]);
        elseif direction == Direction.Right
          if y == 3
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end
          obj.swap([x, y], [x, y+1]);
        elseif direction == Direction.Down
          if x == 3
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end
          obj.swap([x, y], [x+1, y]);
        elseif direction == Direction.Left
          if y == 1
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end
          obj.swap([x, y], [x, y-1]);
        end
      end
      function swap(obj, coordinate1, coordinate2)
        tmp = obj.puzzle(coordinate1(1), coordinate1(2));
		obj.puzzle(coordinate1(1), coordinate1(2)) = obj.puzzle(coordinate2(1), coordinate2(2));
		obj.puzzle(coordinate2(1), coordinate2(2)) = tmp;
      end
      function mdis = fitness(obj)
        mdis = 0;
        for i = (1:3)
          for j = (1:3)
            if obj.goal(i, j) == 0
              continue;
            end
            [x, y] = find(obj.puzzle == obj.goal(i, j));
            mdis = mdis + abs(x - i) + abs(y - j);
          end
        end
      end
    end
end