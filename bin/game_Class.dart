import 'dart:io';
import 'dart:math';
import 'Character_Class.dart';
import 'Monster_Class.dart';

Random random = Random();

class Game {
  late Character character;
  List<Monster> monsterList = [];
  int point = 0;
  int monsterListLength = 0;
  int monsterListIndex = 0;

  void startGame() {
    print('게임을 시작합니다!');
    loadCharacter();
    loadMonsters();
    BonusHealth();
    character.showStatus();
    print('\n');

    while (true) {
      print('새로운 몬스터가 나타났습니다!');
      Monster monster = getRandomMonster();
      monsterList.removeAt(monsterListIndex);
      monster.showStatus();
      print('\n');
      String? y_or_n = 'p';

      battle(monster);

      if (point == monsterListLength) {
        endGame(true);
      }

      stdout.write('다음 몬스터와 싸우시겠습니까? (y / n):');
      while (y_or_n != 'y') {
        y_or_n = stdin.readLineSync();
        if (y_or_n != null && y_or_n.isNotEmpty) {
          if (y_or_n == 'y') {
            break;
          } else if (y_or_n == 'n') {
            endGame(false);
          } else {
            print('올바른 값을 입력하세요.');
          }
        }
      }
    }
  }

  //도전 기능 1
  void BonusHealth() {
    int luck = random.nextInt(100);
    if (luck <= 30) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  void battle(Monster monster) {
    String? select;

    while (true) {
      print('${character.name}의 턴');

      do {
        stdout.write('행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템): ');
        select = stdin.readLineSync();

        if (select != null && select.isNotEmpty) {
          try {
            int choice = int.parse(select);

            if (choice == 1) {
              character.attack(monster);
              break;
            } else if (choice == 2) {
              character.defend(monster);
              break;
            } else if (choice == 3) {
              character.useItem(); //도전 기능 2
              continue;
            } else {
              print('올바른 값을 입력하세요.');
            }
          } catch (e) {
            print('숫자를 입력하세요!');
          }
        }
      } while (true);

      if (monster.health <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        point += 1;
        print('\n');
        break;
      }

      print('\n');

      print('${monster.name}의 턴');
      monster.attack(character);
      character.showStatus();
      monster.showStatus();

      print('\n');

      //도전 기능 3
      monster.turnCounter++;
      if (monster.turnCounter % 3 == 0) {
        monster.increaseDefense();
        print('\n');
      }

      if (character.health <= 0) {
        print('캐릭터가 사망했습니다. \n게임을 종료합니다');
        endGame(false);
      }
    }
  }

  Monster getRandomMonster() {
    monsterListIndex = random.nextInt(monsterList.length);
    return monsterList[monsterListIndex];
  }

  //필수 기능 1
  void loadCharacter() {
    try {
      stdout.write('캐릭터 이름을 입력하세요: '); //필수 기능 2
      String? character_Name = stdin.readLineSync();
      while (character_Name == null ||
          character_Name.isEmpty ||
          !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(character_Name)) {
        print('올바른 이름을 입력하세요. (영문만 허용)');
        stdout.write('캐릭터 이름을 입력하세요: ');
        character_Name = stdin.readLineSync();
      }

      final file = File('bin/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.trim().split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');

      character = Character(
        character_Name,
        int.parse(stats[0]),
        int.parse(stats[1]),
        int.parse(stats[2]),
      );
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  //필수 기능 1
  void loadMonsters() {
    try {
      final file = File('bin/monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        var stats = line.trim().split(',');
        if (stats.length != 3) throw FormatException('Invalid monster data');

        monsterList.add(
          Monster(stats[0], int.parse(stats[1]), int.parse(stats[2]), 0),
        );
      }
      monsterListLength = monsterList.length;
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  //필수 기능 3
  void endGame(bool win) {
    String? y_or_n;

    stdout.write('결과를 저장하시겠습니까? (y / n) : ');

    do {
      y_or_n = stdin.readLineSync();
      if (y_or_n == 'y') {
        final result =
            '이름: ${character.name}\n남은 체력: ${character.health}\n결과: ${win ? '승리' : '패배'}';
        File('result.txt').writeAsStringSync(result);
        print('저장완료!');
      } else if (y_or_n == 'n')
        print('게임을 종료합니다.');
      else
        stdout.write("( y 또는 n 를 입력해주세요.)");
    } while (y_or_n != 'y' && y_or_n != 'n');

    exit(0);
  }
}
