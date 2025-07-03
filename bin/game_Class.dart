import 'dart:ffi';
import 'dart:io';

import 'Character_Class.dart';
import 'Monster_Class.dart';

class Game{
  Character? character;
  List<Monster> MonsterList = [];
  int point = 0;

void startGame(){




}
void battle(){
}
void getRandomMonster(){
}


void loadCharacter() {
  try {
      stdout.write('캐릭터 이름을 입력하세요: ');
      String? character_Name = stdin.readLineSync();
      while (character_Name == null || character_Name.isEmpty || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(character_Name)) {
        print('올바른 이름을 입력하세요. (한글/영문만 허용)');
        stdout.write('캐릭터 이름을 입력하세요: ');
        character_Name = stdin.readLineSync();
      }

      final file = File('characters.txt');
      final stats = file.readAsStringSync().trim().split(',');
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      character = Character(character_Name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void EndGame(bool win){
    String? yorn;

    stdout.write('결과를 저장하시겠습니까? (y / n)');
    
    do{
      yorn = stdin.readLineSync();
      if ( yorn == 'y'){
      final result = '이름: ${character.name}\n남은 체력: ${character.health}\n결과: ${win ? '승리' : '패배'}';
      File('result.txt').writeAsStringSync(result);
      print('저장완료!.');
      }
      else if( yorn == 'n')print('게임을 종료합니다.');
      else print("( y 또는 n 를 입력해주세요.)");
    }
    while( yorn != 'y' || yorn != 'n');
  }




}