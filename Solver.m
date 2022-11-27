classdef Solver < handle
  properties
    board
    max_generation
    population_size
    chromosome_len
    n_select_chromosome
    inc_range_chromosome
    inc_size_chromosome
    best_select
    goal
  end

  methods
    function obj = Solver(board, max_generation, population_size, goal)
      obj.board = board;
      obj.max_generation = max_generation;
      obj.population_size = population_size;
      obj.chromosome_len = 20;
      obj.n_select_chromosome = 3;
      obj.inc_range_chromosome = 50;
      obj.inc_size_chromosome = 5;
      obj.goal = goal;
    end

    function chromosome = createChromosome(~, len)
      chromosome = repmat(Direction.base, 1, len);

      for i = (1:len)
        chromosome(i) = Direction(randi(4));
      end
    end

    function population = initializePopulation(obj)
      population = repmat(Direction.base, obj.population_size, obj.chromosome_len);

      for i = (1:obj.population_size)
        population(i, :) = obj.createChromosome(obj.chromosome_len);
      end
    end

    function chromosome = mutation(obj, chromosome)
      len = length(chromosome);

      if len < obj.chromosome_len
        chromosome = [chromosome, obj.createChromosome(obj.chromosome_len - len)];
      end

      if chromosome(1).isOpposite(chromosome(2))
        chromosome(2) = chromosome(2).getDifferent();
      end

      for i = (3:obj.chromosome_len)
        if (chromosome(i).isEqual(chromosome(i - 2)) && chromosome(i).isEqual(chromosome(i - 1))) || (chromosome(i).isOpposite(chromosome(i - 1)))
          chromosome(i) = chromosome(i - 1).getDifferentAxis();
        end
      end
    end

    function [chromosome, puzzle] = applyChromosomeToPuzzle(obj, chromosome)
      puzzle = Puzzle(obj.board, obj.goal);
      i = 1;

      while i <= length(chromosome)
        try
          if puzzle.fitness() == 0
            chromosome = [chromosome(1:i - 1), repmat(Direction.base, 1, obj.chromosome_len - i + 1)];
            return;
          end

          puzzle.move(chromosome(i));
	      i = i + 1;
        catch
          chromosome(i) = chromosome(i).getDifferentAxis();
        end
      end
    end

    function chromosomes = crossing(obj, chromosome1, chromosome2)
      chromosomes = repmat(Direction.base, 10, obj.chromosome_len);
      i = randi([1, floor(obj.chromosome_len / 2)]);
      j = randi([floor(obj.chromosome_len / 2) + 1, obj.chromosome_len]);

      chromosomes(1, :) = [chromosome1(1:i - 1), chromosome2(i:end)];
      chromosomes(2, :) = [chromosome2(1:i - 1), chromosome1(i:end)];

      chromosomes(3, :) = [chromosome1(1:j - 1), chromosome2(j:end)];
      chromosomes(4, :) = [chromosome2(1:j - 1), chromosome1(j:end)];
    
      chromosomes(5, :) = [chromosome1(1:i - 1), chromosome2(i:j - 1), chromosome1(j:end)];
      chromosomes(6, :) = [chromosome2(1:i - 1), chromosome1(i:j - 1), chromosome2(j:end)];
    
      chromosomes(7, :) = [chromosome1(j:end), chromosome1(1:i - 1), chromosome2(i:j - 1)];
      chromosomes(8, :) = [chromosome2(j:end), chromosome2(1:i - 1), chromosome1(i:j - 1)];
    
      chromosomes(9, :) = [chromosome2(i:j - 1), chromosome1(1:i - 1), chromosome1(j:end)];
      chromosomes(10, :) = [chromosome1(i:j - 1), chromosome2(1:i - 1), chromosome2(j:end)];
    end

    function res = crossover(obj, chromosomes, index)
      res = [chromosomes; repmat(Direction.base, (obj.n_select_chromosome - index) * 10, obj.chromosome_len)];

      if obj.n_select_chromosome == index
        return;
      end

      for i = (index + 1:obj.n_select_chromosome)
        from = size(chromosomes, 1) + 1 + ((i - index - 1) * 10);
        to = from + 9;
        res(from:to, :) = obj.crossing(chromosomes(index, :), chromosomes(i, :));
      end

      res = obj.crossover(res, index + 1);
    end

    function res = selection(obj, chromosomes)
      tmp.chromosome = repmat(Direction.base, 1, obj.chromosome_len);
      tmp.puzzle = Puzzle(obj.board, obj.goal);
      res = repmat(tmp, 1, size(chromosomes, 1));

      for i = (1:size(chromosomes, 1))
        [chromosome, puzzle] = obj.applyChromosomeToPuzzle(chromosomes(i, :));
	    res(i).chromosome = chromosome;
        res(i).puzzle = puzzle;
      end

      [~, i] = sort(arrayfun(@(x) x.puzzle.fitness(), res));
      res = res(i);
      res = res(1:obj.n_select_chromosome);
    end
    
    function str = getChromosomeStr(~, chromosome)
      str = '';
      
      for i = (1:length(chromosome))
        if chromosome(i) ~= 0
          str = strcat(str, chromosome(i).getDirectionStr(), ', ');
        end
      end
    end

    function solution(obj)
      generation = 0;
      n_inc = 0;
      best_mdis = 36;

      population = obj.initializePopulation();

      while generation < obj.max_generation
        generation = generation + 1;

        for i = (1:size(population, 1))
          population(i, :) = obj.mutation(population(i, :));
        end

        slct = obj.selection(population);
        mdis = slct(1).puzzle.fitness();
        population = repmat(Direction.base, length(slct), obj.chromosome_len);

        for i = (1:length(slct))
          population(i, :) = slct(i).chromosome;
        end

        if mdis < best_mdis
          best_mdis = mdis;
          best_select_ = slct(1);
        end

        if floor(generation / obj.inc_range_chromosome) > n_inc
          n_inc = n_inc + 1;
          obj.chromosome_len = obj.chromosome_len + obj.inc_size_chromosome;
        end

%         implement

        if mdis == 0
          obj.best_select = best_select_;
          break;
        end

        population = obj.crossover(population, 1);
      end
    end
  end
end
