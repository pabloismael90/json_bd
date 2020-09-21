import 'dart:async';
import 'dart:io' as io;
import 'package:json_bd/models/album.dart';
import 'package:json_bd/models/albums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  static const String TABLE = "albums";
  static const String ALBUM_ID = "albumId";
  static const String ID = "id";
  static const String TITLE = "title";
  static const String URL = "url";
  static const String THUMBNAIL_URL = "thumbnailUrl";
  static const String DB_NAME = "albums.bd";

  // iniciarlizar la BD
  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async {
    // Get the Device's Documents directory to store the Offline Database...
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    // Crear BD
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $ALBUM_ID TEXT, $TITLE TEXT, $URL TEXT, $THUMBNAIL_URL TEXT)");
  }

  //Método para insertar el registro del álbum en la base de datos

  Future<Album> save(Album album) async {
    var dbClient = await db;
    // esto insertará el objeto Album en la base de datos después de convertirlo a json
    album.id = await dbClient.insert(TABLE, album.toJson());
    return album;
  }

    //Metodo para retornar todo los albunes de la bd
    Future<Albums> getAlbums() async {
        var dbClient = await db;
        // especifique los nombres de columna que desee en el conjunto de resultados
        List<Map> maps =
            await dbClient.query(TABLE, columns: [ID, TITLE, URL, THUMBNAIL_URL]);
        Albums allAlbums = Albums();
        List<Album> albums = [];
        if (maps.length > 0) {
            for (int i = 0; i < maps.length; i++) {
                albums.add(Album.fromJson(maps[i]));
            }
        }
        allAlbums.albums = albums;
        return allAlbums;
    }

    // Método para eliminar un álbum de la base de datos
    Future<int> delete(int id) async {
        var dbClient = await db;
        return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
    }

    // Método para actualizar un álbum en la base de datos
    Future<int> update(Album album) async {
        var dbClient = await db;
        return await dbClient
            .update(TABLE, album.toJson(), where: '$ID = ?', whereArgs: [album.id]);
    }

    // Método para truncar la tabla
    Future<void> truncateTable() async {
        var dbClient = await db;
        return await dbClient.delete(TABLE);
    }

    // Método para cerrar la base de datos
    Future close() async {
        var dbClient = await db;
        dbClient.close();
    }

}
