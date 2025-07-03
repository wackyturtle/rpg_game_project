import 'dart:io';
import 'Monster_Class.dart';
import 'Unit.dart';

void loadCharacter() {
  try {
    stdout.write('캐릭터 이름을 입력하세요: ');
    String? character_Name = stdin.readLineSync();
    while (character_Name == null || character_Name.isEmpty || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(character_Name)) {
      print('올바른 이름을 입력하세요. (한글/영문만 허용)');
      stdout.write('캐릭터 이름을 입력하세요: ');
      character_Name = stdin.readLineSync();
    }

    final file = File('bin/characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');
    if (stats.length != 3) throw FormatException('Invalid character data');
    

    String name = getCharacterName();
    character = Character(name, int.parse(stats[0]), int.parse(stats[1]), int.parse(stats[2]));
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

class Character extends Unit{
  
  Character(String name, int health, int attack_Power, int defense_Power) : super(name, health, attack_Power, defense_Power); // 부모 생성자 호출

  void attack(Monster monster){
    int damage = attack_Power - monster.defense_Power;
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage만큼의 피해를 입혔습니다.');
  }

  void defend(Monster monster){
    int recover = monster.attack_Power - defense_Power;
    health += recover;
    print('$name이(가) 방어 태세를 취하여 $recover만큼의 체력을 얻었습니다.');
  }

  @override
  void showStatus(){
    print('$name - 체력: $health, 공격력: $attack_Power, 방어력: $defense_Power');
  }
}