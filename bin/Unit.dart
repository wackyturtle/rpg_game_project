//필수 기능 4
abstract class Unit {
  String name;
  int health;
  int attack_Power;
  int defense_Power;

  Unit(this.name, this.health, this.attack_Power, this.defense_Power);

  void showStatus();
}
