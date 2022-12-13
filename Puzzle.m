classdef Puzzle < handle
    properties
      puzzle
      goal
    end

    methods
      function obj = Puzzle(puzzle, goal)
        obj.puzzle = reshape(puzzle, [3, 3])';
        obj.goal = reshape(goal, [3, 3])';
      end
      
      function [current_move, next_move] = validMove(obj, pre_move, next_move)
        i = [1, 2, 3, 4];
        i(i == pre_move.getOpposite()) = [];
        i(i == next_move.getOpposite()) = [];
        
        [x, y] = find(obj.puzzle == 0);
        
        if x ~= 2
          i(i == x) = [];
        end
        
        if y == 1
          i(i == 4) = [];
        end
        
        if y == 3
          i(i == 2) = [];
        end
        
        if isempty(i)
          current_move = next_move.getOpposite();
          next_move = next_move.getDifferent();
          return;
        end
        
        current_move = Direction(i(randi(length(i))));
      end

      function move(obj, direction)
        if ~isa(direction, 'Direction')
            ex = MException('MyComponent:invalidInstance','direction must be an instance of Direction Enum');
            throw(ex);
        end

        [x, y] = find(obj.puzzle == 0);

        if direction == Direction.up
          if x == 1
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end

          obj.swap([x, y], [x - 1, y]);
        elseif direction == Direction.right
          if y == 3
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end

          obj.swap([x, y], [x, y + 1]);
        elseif direction == Direction.down
          if x == 3
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end

          obj.swap([x, y], [x + 1, y]);
        elseif direction == Direction.left
          if y == 1
            ex = MException('MyComponent:invalidInstance','Invalid movement');
            throw(ex);
          end

          obj.swap([x, y], [x, y - 1]);
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
