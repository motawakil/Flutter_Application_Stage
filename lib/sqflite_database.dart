import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db; // _db:  is a private variable that holds a reference to the SQLite database. 

  DatabaseHelper.internal();

  // Method to initialize the database
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }
  Future<Database> initDb() async { // initDb() responsible for initializing the SQLite
    String databasesPath = await getDatabasesPath(); // Store the Database path 
    String path = join(databasesPath, 'your_database_name.db');

    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Method to create the tables in the database
 void _onCreate(Database db, int newVersion) async {
  // Create Utilisateurs table
  await db.execute('''
    CREATE TABLE Utilisateurs (
      id INTEGER PRIMARY KEY,
      Nom_Utilisateur TEXT,
      Prenom_Utilisateur TEXT,
      Email_Inst TEXT,
      password TEXT,
      Role TEXT,
      Date_Naissance TEXT
    )
  ''');
  // Create Stages table
  await db.execute('''
    CREATE TABLE Stages (
      id INTEGER PRIMARY KEY,
      Sujet_Stage TEXT,
      Lieu_Stage TEXT,
      Type_Stage TEXT,
      id_Professeur INTEGER REFERENCES Professeurs(id)
    )
  ''');

  // Create Stages_Etudiants table
  await db.execute('''
    CREATE TABLE Stages_Etudiants (
      id INTEGER PRIMARY KEY,
      id_Stage INTEGER REFERENCES Stages(id),
      id_Etudiant INTEGER REFERENCES Etudiants(id)
    )
  ''');
  // Create Missions table
  await db.execute('''
    CREATE TABLE Missions (
      id INTEGER PRIMARY KEY,
      Titre_Mission TEXT,
      Etat_Mission TEXT,
      Date_Debut_Mission TEXT,
      Date_Fin_Mission TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');

  // Create Objectifs table
  await db.execute('''
    CREATE TABLE Objectifs (
      id INTEGER PRIMARY KEY,
      Text_Objectif TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');

  // Create Realisations table
  await db.execute('''
    CREATE TABLE Realisations (
      id INTEGER PRIMARY KEY,
      Date_Realisation TEXT,
      Remarque TEXT,
      id_Mission INTEGER REFERENCES Missions(id)
    )
  ''');

  // Create Etudiants table
  await db.execute('''
    CREATE TABLE Etudiants (
      id INTEGER PRIMARY KEY,
      Filiere TEXT,
      Branche TEXT,
      id_Utilisateur INTEGER REFERENCES Utilisateurs(id)
    )
  ''');

  // Create Professeurs table

  await db.execute('''
    CREATE TABLE Professeurs (
      id INTEGER PRIMARY KEY,
      Specialite TEXT,
      id_Utilisateur INTEGER REFERENCES Utilisateurs(id)
    )
  ''');
}
}
