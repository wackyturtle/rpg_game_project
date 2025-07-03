import 'dart:io';
import 'dart:math';

abstract class Unit {
  String name;
  int health;
  int attackPower;
  int defensePower;

  Unit(this.name, this.health, this.attackPower, this.defensePower);

  void showStatus();
}

class Character extends Unit {
  bool itemUsed = false;

  Character(String name, int health, int attackPower, int defensePower)
    : super(name, health, attackPower, defensePower);

  void attackMonster(Monster monster) {
    int damage = max(0, attackPower - monster.defensePower);
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage 데미지를 입혔습니다.');
  }

  void defend(int incomingDamage) {
    int heal = max(0, incomingDamage - defensePower);
    health += heal;
    print('$name이(가) 방어하여 체력이 $heal 회복되었습니다. 현재 체력: $health');
  }

  void useItem() {
    if (!itemUsed) {
      attackPower *= 2;
      itemUsed = true;
      print('$name이(가) 아이템을 사용하여 공격력이 두 배로 증가했습니다!');
    } else {
      print('이미 아이템을 사용했습니다.');
    }
  }

  @override
  void showStatus() {
    print('[$name 상태] 체력: $health | 공격력: $attackPower | 방어력: $defensePower');
  }
}

class Monster extends Unit {
  int maxAttack;
  int turnCounter = 0;

  Monster(String name, int health, int maxAttack)
    : maxAttack = maxAttack,
      super(name, health, 0, 0) {
    attackPower = 0;
  }

  void attackCharacter(Character character) {
    attackPower = max(character.defensePower, Random().nextInt(maxAttack + 1));
    int damage = max(0, attackPower - character.defensePower);
    character.health -= damage;
    print('${name}이(가) ${character.name}에게 $damage 데미지를 입혔습니다.');
  }

  void increaseDefense() {
    defensePower += 2;
    print('${name}의 방어력이 증가했습니다! 현재 방어력: $defensePower');
  }

  @override
  void showStatus() {
    print('[$name 상태] 체력: $health | 공격력: $attackPower | 방어력: $defensePower');
  }
}

class Game {
  late Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;
  final random = Random();

  void startGame() {
    print('=== 게임을 시작합니다 ===');

    loadCharacter();
    loadMonsters();
    grantBonusHealth();

    while (character.health > 0 && defeatedMonsters < monsters.length) {
      Monster monster = getRandomMonster();
      bool result = battle(monster);

      if (!result) {
        print('게임 오버! ${character.name}이(가) 쓰러졌습니다.');
        saveResult(false);
        return;
      }

      defeatedMonsters++;
      if (defeatedMonsters == monsters.length) {
        print('축하합니다! 모든 몬스터를 물리치고 승리하였습니다!');
        saveResult(true);
        return;
      }

      stdout.write('다음 몬스터와 대결하시겠습니까? (y/n): ');
      String? input = stdin.readLineSync();
      if (input?.toLowerCase() != 'y') {
        print('게임을 종료합니다.');
        saveResult(false);
        return;
      }
    }
  }

  bool battle(Monster monster) {
    print('\n=== ${monster.name}와의 전투 시작! ===');
    while (character.health > 0 && monster.health > 0) {
      character.showStatus();
      monster.showStatus();

      stdout.write('\n행동 선택 - 공격(1), 방어(2), 아이템(3): ');
      String? input = stdin.readLineSync();

      if (input == '1') {
        character.attackMonster(monster);
      } else if (input == '2') {
        monster.attackCharacter(character);
        character.defend(monster.attackPower);
        continue;
      } else if (input == '3') {
        character.useItem();
        continue;
      } else {
        print('잘못된 입력입니다. 다시 선택하세요.');
        continue;
      }

      if (monster.health <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        monsters.remove(monster);
        return true;
      }

      monster.attackCharacter(character);

      monster.turnCounter++;
      if (monster.turnCounter % 3 == 0) {
        monster.increaseDefense();
      }
    }

    return character.health > 0;
  }

  Monster getRandomMonster() {
    return monsters[random.nextInt(monsters.length)];
  }

  void loadCharacter() {
    try {
      stdout.write('캐릭터 이름을 입력하세요: ');
      String? input = stdin.readLineSync();
      while (input == null ||
          input.isEmpty ||
          !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        print('올바른 이름을 입력하세요. (한글/영문만 허용)');
        stdout.write('캐릭터 이름을 입력하세요: ');
        input = stdin.readLineSync();
      }

      final file = File('characters.txt');
      final stats = file.readAsStringSync().trim().split(',');
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      character = Character(input, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void loadMonsters() {
    try {
      final file = File('monsters.txt');
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        var stats = line.trim().split(',');
        if (stats.length != 3) throw FormatException('Invalid monster data');

        String name = stats[0];
        int health = int.parse(stats[1]);
        int maxAttack = int.parse(stats[2]);

        monsters.add(Monster(name, health, maxAttack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void grantBonusHealth() {
    if (random.nextDouble() <= 0.3) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  void saveResult(bool win) {
    stdout.write('결과를 저장하시겠습니까? (y/n): ');
    String? input = stdin.readLineSync();
    if (input?.toLowerCase() == 'y') {
      final result =
          '이름: ${character.name}\n남은 체력: ${character.health}\n결과: ${win ? '승리' : '패배'}';
      File('result.txt').writeAsStringSync(result);
      print('결과가 result.txt에 저장되었습니다.');
    }
  }
}

void main() {
  Game game = Game();
  game.startGame();
}
