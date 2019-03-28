// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pic.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$PicSerializable extends SerializableMap {
  ObjectId get id;
  String get title;
  String get desc;
  String get author;
  String get uploaderId;
  ImageInformation get original;
  ImageInformation get compressed;
  ImageInformation get preview;
  List<Tag> get tags;
  set id(ObjectId v);
  set title(String v);
  set desc(String v);
  set author(String v);
  set uploaderId(String v);
  set original(ImageInformation v);
  set compressed(ImageInformation v);
  set preview(ImageInformation v);
  set tags(List<Tag> v);
  Map<String, dynamic> asMap();
  String toJson();
  String toString();
  void readFromMap(Map<String, dynamic> map);
  APISchemaObject documentSchema(APIDocumentContext context);
  void read(Map<String, dynamic> object,
      {Iterable<String> ignore,
      Iterable<String> reject,
      Iterable<String> require});

  operator [](Object __key) {
    switch (__key) {
      case '_id':
        return id;
      case 'title':
        return title;
      case 'desc':
        return desc;
      case 'author':
        return author;
      case 'uploaderId':
        return uploaderId;
      case 'original':
        return original;
      case 'compressed':
        return compressed;
      case 'preview':
        return preview;
      case 'tags':
        return tags;
      case 'asMap':
        return asMap;
      case 'toJson':
        return toJson;
      case 'toString':
        return toString;
      case 'readFromMap':
        return readFromMap;
      case 'documentSchema':
        return documentSchema;
      case 'read':
        return read;
    }
    throwFieldNotFoundException(__key, 'Pic');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case '_id':
        id = fromSerialized(__value, () => new ObjectId());
        return;
      case 'title':
        title = __value;
        return;
      case 'desc':
        desc = __value;
        return;
      case 'author':
        author = __value;
        return;
      case 'uploaderId':
        uploaderId = __value;
        return;
      case 'original':
        original = fromSerialized(__value, () => new ImageInformation());
        return;
      case 'compressed':
        compressed = fromSerialized(__value, () => new ImageInformation());
        return;
      case 'preview':
        preview = fromSerialized(__value, () => new ImageInformation());
        return;
      case 'tags':
        tags =
            fromSerialized(__value, [() => new List<Tag>(), () => new Tag()]);
        return;
    }
    throwFieldNotFoundException(__key, 'Pic');
  }

  Iterable<String> get keys => PicClassMirror.fields.keys;
}

abstract class _$ImageInformationSerializable extends SerializableMap {
  int get width;
  int get height;
  int get fileSize;
  String get link;
  ObjectId get fileId;
  String get ext;
  double get aspectRatio;
  set width(int v);
  set height(int v);
  set fileSize(int v);
  set link(String v);
  set fileId(ObjectId v);
  set ext(String v);
  String toJson();
  Map<String, dynamic> asMap();
  void readFromMap(Map<String, dynamic> object);
  APISchemaObject documentSchema(APIDocumentContext context);
  void read(Map<String, dynamic> object,
      {Iterable<String> ignore,
      Iterable<String> reject,
      Iterable<String> require});

  operator [](Object __key) {
    switch (__key) {
      case 'width':
        return width;
      case 'height':
        return height;
      case 'fileSize':
        return fileSize;
      case 'link':
        return link;
      case 'fileId':
        return fileId;
      case 'ext':
        return ext;
      case 'aspectRatio':
        return aspectRatio;
      case 'toJson':
        return toJson;
      case 'asMap':
        return asMap;
      case 'readFromMap':
        return readFromMap;
      case 'documentSchema':
        return documentSchema;
      case 'read':
        return read;
    }
    throwFieldNotFoundException(__key, 'ImageInformation');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'width':
        width = __value;
        return;
      case 'height':
        height = __value;
        return;
      case 'fileSize':
        fileSize = __value;
        return;
      case 'link':
        link = __value;
        return;
      case 'fileId':
        fileId = fromSerialized(__value, () => new ObjectId());
        return;
      case 'ext':
        ext = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'ImageInformation');
  }

  Iterable<String> get keys => ImageInformationClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_Pic__Constructor([positionalParams, namedParams]) => new Pic();

const $$Pic_fields_id = const DeclarationMirror(
  name: '_id',
  type: ObjectId,
);
const $$Pic_fields_title = const DeclarationMirror(name: 'title', type: String);
const $$Pic_fields_desc = const DeclarationMirror(name: 'desc', type: String);
const $$Pic_fields_author =
    const DeclarationMirror(name: 'author', type: String);
const $$Pic_fields_uploaderId =
    const DeclarationMirror(name: 'uploaderId', type: String);
const $$Pic_fields_original =
    const DeclarationMirror(name: 'original', type: ImageInformation);
const $$Pic_fields_compressed =
    const DeclarationMirror(name: 'compressed', type: ImageInformation);
const $$Pic_fields_preview =
    const DeclarationMirror(name: 'preview', type: ImageInformation);
const $$Pic_fields_tags =
    const DeclarationMirror(name: 'tags', type: const [List, Tag]);

const PicClassMirror = const ClassMirror(
    name: 'Pic',
    constructors: const {
      '': const FunctionMirror(name: '', $call: _Pic__Constructor)
    },
    fields: const {
      '_id': $$Pic_fields_id,
      'title': $$Pic_fields_title,
      'desc': $$Pic_fields_desc,
      'author': $$Pic_fields_author,
      'uploaderId': $$Pic_fields_uploaderId,
      'original': $$Pic_fields_original,
      'compressed': $$Pic_fields_compressed,
      'preview': $$Pic_fields_preview,
      'tags': $$Pic_fields_tags
    },
    getters: const [
      '_id',
      'title',
      'desc',
      'author',
      'uploaderId',
      'original',
      'compressed',
      'preview',
      'tags'
    ],
    setters: const [
      '_id',
      'title',
      'desc',
      'author',
      'uploaderId',
      'original',
      'compressed',
      'preview',
      'tags'
    ],
    methods: const {
      'asMap': const FunctionMirror(
        name: 'asMap',
        returnType: const [
          Map,
          const [String, dynamic]
        ],
      ),
      'toJson': const FunctionMirror(
        name: 'toJson',
        returnType: String,
      ),
      'toString': const FunctionMirror(
        name: 'toString',
        returnType: String,
      ),
      'readFromMap': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'map',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        name: 'readFromMap',
        returnType: null,
      ),
      'documentSchema': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'context', type: APIDocumentContext, isRequired: true)
        ],
        name: 'documentSchema',
        returnType: APISchemaObject,
      ),
      'read': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'object',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        namedParameters: const {
          'ignore': const DeclarationMirror(
              name: 'ignore', type: const [Iterable, String], isNamed: true),
          'reject': const DeclarationMirror(
              name: 'reject', type: const [Iterable, String], isNamed: true),
          'require': const DeclarationMirror(
              name: 'require', type: const [Iterable, String], isNamed: true)
        },
        name: 'read',
        returnType: null,
      )
    },
    superclass: Serializable);

_ImageInformation__Constructor([positionalParams, namedParams]) =>
    new ImageInformation();

const $$ImageInformation_fields_width =
    const DeclarationMirror(name: 'width', type: int);
const $$ImageInformation_fields_height =
    const DeclarationMirror(name: 'height', type: int);
const $$ImageInformation_fields_fileSize =
    const DeclarationMirror(name: 'fileSize', type: int);
const $$ImageInformation_fields_link =
    const DeclarationMirror(name: 'link', type: String);
const $$ImageInformation_fields_fileId =
    const DeclarationMirror(name: 'fileId', type: ObjectId);
const $$ImageInformation_fields_ext =
    const DeclarationMirror(name: 'ext', type: String);
const $$ImageInformation_fields_aspectRatio =
    const DeclarationMirror(name: 'aspectRatio', type: double, isFinal: true);

const ImageInformationClassMirror = const ClassMirror(
    name: 'ImageInformation',
    constructors: const {
      '': const FunctionMirror(name: '', $call: _ImageInformation__Constructor)
    },
    fields: const {
      'width': $$ImageInformation_fields_width,
      'height': $$ImageInformation_fields_height,
      'fileSize': $$ImageInformation_fields_fileSize,
      'link': $$ImageInformation_fields_link,
      'fileId': $$ImageInformation_fields_fileId,
      'ext': $$ImageInformation_fields_ext,
      'aspectRatio': $$ImageInformation_fields_aspectRatio
    },
    getters: const [
      'width',
      'height',
      'fileSize',
      'link',
      'fileId',
      'ext',
      'aspectRatio'
    ],
    setters: const ['width', 'height', 'fileSize', 'link', 'fileId', 'ext'],
    methods: const {
      'toJson': const FunctionMirror(
        name: 'toJson',
        returnType: String,
      ),
      'asMap': const FunctionMirror(
        name: 'asMap',
        returnType: const [
          Map,
          const [String, dynamic]
        ],
      ),
      'readFromMap': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'object',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        name: 'readFromMap',
        returnType: null,
      ),
      'documentSchema': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'context', type: APIDocumentContext, isRequired: true)
        ],
        name: 'documentSchema',
        returnType: APISchemaObject,
      ),
      'read': const FunctionMirror(
        positionalParameters: const [
          const DeclarationMirror(
              name: 'object',
              type: const [
                Map,
                const [String, dynamic]
              ],
              isRequired: true)
        ],
        namedParameters: const {
          'ignore': const DeclarationMirror(
              name: 'ignore', type: const [Iterable, String], isNamed: true),
          'reject': const DeclarationMirror(
              name: 'reject', type: const [Iterable, String], isNamed: true),
          'require': const DeclarationMirror(
              name: 'require', type: const [Iterable, String], isNamed: true)
        },
        name: 'read',
        returnType: null,
      )
    },
    superclass: Serializable);
