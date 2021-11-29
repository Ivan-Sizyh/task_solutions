require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_passenger'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_passenger'

class Program

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
    @attempt = 0
  end

  def start
    while true
      @attempt = 0
      puts "Выберите операцию: \n1 - Создать станцию, поезд, маршрут\n2 - Операции с созданными объектами\n3 - Получить информацию об объекте\n4 - Завершить программу"
      print "Операция:"

      case gets.chomp.to_i

      when 1#Создать станцию, поезд, маршрут

        create_new_object

      when 2#Опрерации с объектами

        operation_with_object

      when 3#Просмотреть список станций или поездов на станции

        show_objects_info

      else
        break
      end
    end
  end



  attr_accessor :stations, :trains, :routes, :attempt, :wagons

  def create_new_object
    puts "Выберите операцию:\n1 - Создать станцию\n2 - Создать поезд\n3 - Создать маршрут\n4 - Создать вагон\n5 - Вернуться назад"
    print"Операция:"

    case gets.chomp.to_i

    when 1#Создать станцию
      create_station
    when 2 #Создать поезд
      create_train
    when 3#Создать маршрут
      create_route
    when 4#Создать вагон
      create_wagon
    else
      puts "Выбрана операция возврата"
    end
  end

  def operations_with_route
    puts "Выберите операции для маршрута:\n1 - Удалить станцию\n2 - Добавить станцию\n3 - Вернуться"
    print "Операция:"
    operation = gets.chomp
    print"Введите ID маршрута, который хотите редактировать:"
    route_id = gets.chomp.to_i
    print "Введите название станции:"
    station_name = gets.chomp

    if (@routes.length >= route_id.to_i) & (route_id.to_i > 0)

      case operation.to_i
      when 1#Удаление

        delete_route(route_id, station_name)

      when 2#Добавить станцию

        add_station(route_id, station_name)

      else
        puts "Выбрана операция возврата"
      end

    else
      puts "Маршрута с таким ID не найдено"
    end
  end

  def operations_with_train
    puts "Выберите операции для поезда:\n1 - Назначить маршрут\n2 - Добавить вагон\n3 - Отцепить вагон\n4 - Переместить поезд\n5 - Вернуться"
    print "Операция:"
    operation = gets.chomp

    print"Введите номер поезда:"
    train_number = gets.chomp

    train = @trains.filter{|item| item.number.to_s == train_number}.first

    if train
      puts "Поезд #{train.number} найден"
      case operation.to_i
      when 1 #Присвоить маршрут
        train_set_route(train)
      when 2 #Добавить вагон
        train_add_wagon(train)
      when 3 #Отцепить вагон
        train_remove_wagon(train)
      when 4 #Движение
        train_move(train)
      else
        puts "Выбрана операция возврата"
      end
    else
      puts "Поезда с номером #{train_number} не найдено"
    end
  end

  def operation_with_object
    puts "Выберите тип операции:\n1 - Операции с маршрутами\n2 - Операции с поездами\n3 - Операции с вагонами\n4 - Вернуться назад"
    print"Операция:"
    case gets.chomp.to_i

    when 1#Операции с маршрутами
      operations_with_route
    when 2#Операции с поездами
      operations_with_train
    when 3#Операция с вагонами
      operation_with_wagon
    else
      puts "Выбрана операция возврата"
    end
  end

  def show_objects_info
    @routes.each do |route|
      @stations = @stations | route.stations_list
    end

    puts "Выберите операцию:\n1 - Просмотреть список станций\n2 - Просмотреть список поездов на станции\n3 - Вывести список вагонов у поезда\n4 - Вернуться"
    print "Операция:"

    case gets.chomp.to_i
    when 1 #Список станций
      show_stations
    when 2 #Просмотреть список поездов
      show_trains_on_station
    when 3
      show_train_wagons
    else
      puts "Выбрана операция возврата"
    end
  end

  def create_station
    print"Введите название станции:"
    station_name = gets.chomp

    station = @stations.filter{|item| item.name == station_name}

    if station.empty?
      @stations << Station.new(station_name)
      puts "Станция #{station_name} создана"
    else
      puts "Станция #{station_name} уже существует"
    end
  rescue RuntimeError => e
    puts e.message
    @attempt += 1
    retry if @attempt < 3
    puts "Совершено максимально число попыток ввода!"
  end

  def create_train
    puts"Введите тип поезда:\n1 - Грузовой\n2 - Пассажирский\n3 - Отменить выбор"
    print "Тип поезда:"
    type = gets.chomp

    if type.to_i == 1 || type.to_i == 2
      print "Введите номер поезда:"
      number = gets.chomp

      train = @trains.filter{|item| item.number == number}

      if train.empty?
        case type.to_i
        when 1
          @trains << CargoTrain.new(number)
          puts "Грузовой поезд №#{number} создан"
        when 2
          @trains << PassengerTrain.new(number)
          puts "Пассажирский поезд №#{number} создан"
        else
        end
      else
        puts "Поезд с таким номером уже существует!"
      end
    end
  rescue RuntimeError => e
    puts e.message
    @attempt += 1
    retry if @attempt < 3
    puts "Совершено максимально число попыток ввода!"
  end

  def create_route
    print "Введите название начальной станции:"
    first_station_name = gets.chomp
    print "Введите название конечной станции:"
    last_station_name = gets.chomp

    route = @routes.filter{|item| (item.stations_list.first.name == first_station_name) && (item.stations_list.last.name == last_station_name)}

    if route.empty?#Проверка на наличие такого объекта
      first_station = @stations.filter{|item| item.name == first_station_name}.first
      last_station = @stations.filter{|item| item.name == last_station_name}.first

      unless first_station
        first_station = Station.new(first_station_name)
        @stations << first_station
      end

      unless last_station
        last_station = Station.new(last_station_name)
        @stations << last_station
      end

      @routes << Route.new(first_station,last_station)

      puts "Маршрут создан. ID созданного маршрута: #{@routes.length}. Используйте его для дальнейших операций с маршрутом"
    else
      puts "Такой маршрут уже существует!"
    end
  rescue RuntimeError => e
    puts e.message
    @attempt += 1
    retry if @attempt < 3
    puts "Совершено максимально число попыток ввода!"
  end

  def create_wagon
    puts "Введите тип вагона:\n1 - Грузовой\n2 - Пассажирский\n3 - Отменить выбор"
    print "Тип вагона:"
    type = gets.chomp

    if type.to_i == 1 || type.to_i == 2
      case type.to_i
      when 1
        print "Введите объем вагона:"
        wagon_value = gets.chomp.to_i
        @wagons << CargoWagon.new(wagon_value)
        puts "Грузовой вагон создан. Объем #{wagon_value}"
        puts "ID вагона #{@wagons.length}. Используйте его для дальнейшей работы с ним"
      when 2
        print "Введите количество мест в вагоне:"
        wagon_seats = gets.chomp.to_i
        @wagons << PassengerWagon.new(wagon_seats)
        puts "Пассажирский вагон создан. Количество мест #{wagon_seats}"
        puts "ID вагона #{@wagons.length}. Используйте его для дальнейшей работы с ним"
      else
      end
    end
  rescue RuntimeError => e
    puts e.message
    @attempt += 1
    retry if @attempt < 3
    puts "Совершено максимально число попыток ввода!"
  end

  def operation_with_wagon
    print "Введите ID вагона:"
    wagon_id = gets.chomp.to_i

    if wagon_id <= @wagons.length
      wagon = @wagons[wagon_id - 1]
      case wagon.type
      when "грузовой"
        puts "Свободный объем #{wagon.free_volume}"
        print "Введите заполняемый объем:"
        wagon.fill(gets.chomp.to_i)
        puts "Свободный объем #{wagon.free_volume}"
      when "пассажирский"
        if wagon.empty_seats_count.zero?
          puts "Свободных мест в вагоне нет!"
        else
          wagon.take_wagon_seat
          puts "Одно место было занято. Свободных мест #{wagon.empty_seats_count}"
        end
      else
      end
    else
      puts "Введен некоректный ID"
    end

  end

  def delete_route(route_id, station_name)
    if @routes[route_id - 1].stations_list.length > 2

      station_for_op = @routes[route_id - 1].stations_list.filter{|cycle_station| cycle_station.name == station_name}.first

      if station_for_op
        if (station_for_op.get_station_trains.empty?) & (@routes[route_id - 1].stations_list.first != station_for_op) &
          (@routes[route_id - 1].stations_list.last != station_for_op) #Проверить лист

          @routes[route_id - 1].delete_station(station_for_op)
          puts "Станция удалена"
        else
          puts "Удаление начальной, конечной станции маршрута невозможно. Также наличие поездов на удаляемой станции недопустимо!"
        end
      end
    else
      puts "У маршрута не может быть менее двух станций!"
    end
  end

  def add_station(route_id, station_name)
    if @routes[route_id - 1].stations_list.filter{ |station| station.name == station_name }.empty?#Есть ли в маршруте такая станция?
      station = @stations.filter{|item| item.name == station_name}.first

      if station
        @routes[route_id - 1].add_station(station)
        puts "Станция #{station.name} добавлена"
      else
        new_station = Station.new(station_name)
        @stations << new_station
        @routes[route_id - 1].add_station(new_station)
        puts "Станция #{new_station.name} добавлена"
      end
    else
      puts "Эта станция уже присутствует в маршруте"
    end
  end

  def train_set_route(train)
    print"Введите ID маршрута, который хотите присвоить поезду:"
    route_id = gets.chomp.to_i
    if (@routes.length >= route_id) & (route_id > 0)
      train.route = routes[route_id - 1]
      puts "Маршурт №#{route_id} присвоен поезду №#{train.number}"
    else
      puts "Маршрута с таким ID не найдено. Максимальный ID - #{@routes.length}"
    end
  end

  def train_add_wagon(train)
    print "Введите ID вагона:"
    wagon_id = gets.chomp.to_i

    if wagon_id <= @wagons.length
      wagon = @wagons[wagon_id - 1]
      if @trains.filter{|item| item.wagons_list.include? wagon}.empty? && train.type == wagon.type
          train.add_wagon(wagon)
          puts "Вагон присоединен!"
      else
        puts "Этот вагон не может быть присоединен!"
      end
    else
      puts "Введен некоректный ID"
    end
  end

  def train_remove_wagon(train)
    if train.wagons_list.length > 0
      if train.type == "пассажирский"
        train.remove_wagon(train.wagons_list.last)
        puts "У пассажирского поезда №#{train.number} отцплен вагон"
      elsif train.type == "грузовой"
        train.remove_wagon(train.wagons_list.last)
        puts "У грузового поезда №#{train.number} отцплен вагон"
      else
        puts "К этому поезду нельзя присоединять вагоны"
      end
    else
      puts "У поезда #{train.number} отсутствуют вагоны"
    end
  end

  def train_move(train)
    puts "Выберите направление для движения:\n1 - Вперед\n2 - Назад\n3 - Вернуться"
    print "Операция:"
    case gets.chomp.to_i
    when 1
      if train.route
        if train.to_next_station
          puts "Поезд прибыл на станцию #{train.station.name}"
        else
          puts "Поезд находится на конечной станции!"
        end
      else
        puts "У поезда нет маршурта!"
      end
    when 2
      if train.route
        if train.to_back_station
          puts "Поезд прибыл на станцию #{train.station.name}"
        else
          puts "Поезд находится на начальной станции!"
        end
      else
        puts "У поезда нет маршурта!"
      end
    else
      puts "Выбрана команда возврата"
    end
  end

  def show_stations
    if @stations.empty?
      puts "Вы не добавили ни одной станции!"
    else
      puts "Все существующие станции:"
      @stations.each_with_index do |station, index|
        index += 1
        puts "#{index} - #{station.name}"
      end
    end
  end

  def show_trains_on_station
    print "Введите название станции:"
    station_name = gets.chomp

    station = @stations.filter{|item| item.name == station_name}.first

    if station
      if station.get_station_trains.empty?
        puts "На станции нет поездов"
      else
        puts "Список поездов на станции #{station.name}:"
        block = lambda { |train| puts "Поезд №#{train.number} имеет тип #{train.type}. Количество вагонов #{train.wagons_list.length}" }
        station.operation_with_trains(block)
      end
    else
      puts "Станция #{station_name} не найдена"
    end
  end

  def show_train_wagons
    print "Введите номер поезда:"
    train_number = gets.chomp

    train = @trains.filter{|item| item.number == train_number}.first

    if train
      counter = 0
      if train.type == "грузовой"
        train.operation_with_wagons do |wagon|
          counter += 1
          puts "#{wagon.type.capitalize!} вагон №#{counter}. Объем вагона - #{wagon.volume}. Занятый объем - #{wagon.occupied_volume}. Свободный объем - #{wagon.free_volume}"
        end
      elsif train.type == "пассажирский"
        train.operation_with_wagons do |wagon|
          counter += 1
          puts "#{wagon.type.capitalize!} вагон №#{counter}. Мест в вагоне - #{wagon.seats}. Занятых мест - #{wagon.taken_seats}. Свободных мест - #{wagon.empty_seats_count}"
        end
      end
    else
      puts "Поезда с номером #{train_number} не существует"
    end
  end
end

pr = Program.new
pr.start

pr.stations << Station.new("XD")
pr.stations << Station.new("DX")
pr.stations << Station.new("Marmok")