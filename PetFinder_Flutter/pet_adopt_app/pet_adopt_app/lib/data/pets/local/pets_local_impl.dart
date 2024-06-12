import 'package:pet_adopt_app/data/remote/network_constants.dart';
import 'package:pet_adopt_app/model/pets/pets.dart';
import 'package:sqflite/sqflite.dart';

class PetsLocalImpl {
  Database? _db;

  Future<List<Pet>> getPetFavorites() async {
    Database db = await _getDb();

    final items = await db.query(NetworkConstants.FAVORITES_TABLE);
    final petListFavorites =
        items.map((e) => PetDB.fromMap(e).toPet()).toList();

    await closeDb();

    return petListFavorites;
  }

  addPetFavorites(Pet pet) async {
    Database db = await _getDb();

    PetDB petbd = PetDB.fromPet(pet);

    await db.insert(NetworkConstants.FAVORITES_TABLE, petbd.toMap());
    await closeDb();
  }

  deletePetFavorites(Pet pet) async {
    Database db = await _getDb();

    await db.delete(NetworkConstants.FAVORITES_TABLE,
        where: 'id = ?', whereArgs: [PetDB.fromPet(pet).id]);
    await closeDb();
  }

  Future<bool> isFavorite(Pet pet) async {
    List<Pet> favoritePets = await getPetFavorites();
    return favoritePets.any((p) => p.id == pet.id);
  }

  static const String createTableQuery = '''
  CREATE TABLE IF NOT EXISTS ${NetworkConstants.FAVORITES_TABLE} (
    id INTEGER PRIMARY KEY,
    organization_id TEXT,
    url TEXT,
    type TEXT,
    breeds TEXT,
    age TEXT,
    gender TEXT,
    size TEXT,
    name TEXT,
    description TEXT,
    photos TEXT,
    email TEXT,
    phone TEXT,
    city TEXT,
    isFavorite INTEGER
  )
''';

  Future<Database> _getDb() async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDatabase('pet_favorites_list.db');
    }

    await _createTables(_db!);

    return _db!;
  }

  closeDb() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
  }

  _createTables(Database db) async {
    db.execute(createTableQuery);
  }
}
