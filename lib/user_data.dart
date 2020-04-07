import 'package:hive/hive.dart';

part 'user_data.g.dart';


Future registerHiveuserSettings(){
  Hive.registerAdapter(UserSettingsAdapter());
}


@HiveType(typeId: 1)
class UserSettings extends HiveObject{
  @HiveField(0)
  bool has_played_tutorial = false;
}




