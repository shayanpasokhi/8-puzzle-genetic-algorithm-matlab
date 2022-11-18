classdef Direction < int8
    enumeration
      base (0)
      up (1)
      right (2)
      down (3)
      left (4)
    end

    methods
      function str = getDirectionStr(obj)
        tmp = ['U', 'R', 'D', 'L'];
        str = tmp(obj);
      end
          
      function is = isEqual(obj, direction)
        is = obj == direction;
      end

      function is = isOpposite(obj, direction)
        if obj == 0 || direction == 0
          is = 0;
        else
          is = abs(obj - direction) == 2;
        end
      end

      function opp = getOpposite(obj)
        if obj == 0
          opp = Direction(0);
        elseif obj > 2
          opp = Direction(obj - 2);
        else
          opp = Direction(obj + 2);
        end
      end

      function diff = getDifferent(obj)
        if obj == 0
          diff = Direction(0);
        else
          i = [1, 2, 3, 4];
          i(i == obj) = [];
          diff = Direction(i(randi(3)));
        end
      end

      function diff = getDifferentAxis(obj)
        if obj == 0
          diff = Direction(0);
        else
          i = [1, 2, 3, 4];
          i(i == obj) = [];
          i(i == obj.getOpposite()) = [];
          diff = Direction(i(randi(2)));
        end
      end
    end
end
