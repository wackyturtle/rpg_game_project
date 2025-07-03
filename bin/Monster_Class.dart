import 'Character_Class.dart';
import 'Unit.dart';

class Monster extends Unit{
  
  Monster(String name, int health, int attack_Power, int defense_Power) : super(name, health, attack_Power, defense_Power); // 부모 생성자 호출

  void attack(Character character){
    int damage = attack_Power - character.defense_Power;
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage만큼의 피해를 입혔습니다.');
  }

  @override
  void showStatus(){
    print('$name - 체력: $health, 공격력: $attack_Power, 방어력: $defense_Power');
  }
}