import 'dart:math';
import 'Character_Class.dart';
import 'Unit.dart';

Random random = Random();
int monsterPower = random.nextInt(30);

class Monster extends Unit {
  int turnCounter = 0; //도전 기능 3

  Monster(String name, int health, int attack_Power, int defense_Power)
    : super(name, health, attack_Power, defense_Power); // 부모 생성자 호출

  //도전 기능 4 : 몬스터의 공격력이 계속 바뀌는게 showStatus에 표시됨
  void attack(Character character) {
    monsterPower =
        random.nextInt(attack_Power - character.defense_Power) +
        character.defense_Power;
    int damage = monsterPower - character.defense_Power;
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage만큼의 피해를 입혔습니다.');
  }

  void increaseDefense() {
    defense_Power += 2;
    print('${name}의 방어력이 증가했습니다! 현재 방어력: $defense_Power');
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $monsterPower, 방어력: $defense_Power');
  }
}
