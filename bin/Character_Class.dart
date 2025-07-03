import 'Monster_Class.dart';
import 'Unit.dart';

class Character extends Unit {
  bool itemUsed = false;

  Character(String name, int health, int attack_Power, int defense_Power)
    : super(name, health, attack_Power, defense_Power); // 부모 생성자 호출

  void attack(Monster monster) {
    int damage = attack_Power - monster.defense_Power;
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage만큼의 피해를 입혔습니다.');
  }

  //도전 기능 2
  void useItem() {
    if (!itemUsed) {
      attack_Power *= 2;
      itemUsed = true;
      print('$name이(가) 아이템을 사용하여 공격력이 두 배로 증가했습니다!');
    } else {
      print('이미 아이템을 사용했습니다.');
    }
  }

  void defend(Monster monster) {
    int recover = monsterPower - defense_Power;
    health += recover;
    monsterPower = random.nextInt(monster.attack_Power - defense_Power);
    print('$name이(가) 방어 태세를 취하여 $recover만큼의 체력을 얻었습니다.');
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attack_Power, 방어력: $defense_Power');
  }
}
