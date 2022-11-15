classdef Direction < int8
    enumeration
      Up (1)
      Right (2)
      Down (3)
      Left (4)
    end
    methods
      function is = isEqual(obj, direction)
        is = obj == direction;
      end
      function is = isOpposite(obj, direction)
        is = abs(obj - direction) == 2;
      end
      function opp = getOpposite(obj)
        if obj > 2
          opp = Direction(obj - 2);
        else
          opp = Direction(obj + 2);
        end
      end
      function diff = getDifferent(obj)
        i = [1 2 3 4];
        i(i == obj) = [];
        diff = Direction(i(randi(3)));
      end
      function diff = getDifferentAxis(obj)
        i = [1 2 3 4];
        i(i == obj) = [];
        i(i == obj.getOpposite()) = [];
        diff = Direction(i(randi(2)));
      end
    end
end