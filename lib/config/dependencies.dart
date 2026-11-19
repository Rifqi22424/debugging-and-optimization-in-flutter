import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/book_repository.dart';
import '../data/services/catalog_service.dart';

List<SingleChildWidget> get providers => [
      Provider(create: (context) => CatalogService()),
      Provider(create: (context) => BookRepository(service: context.read())),
    ];
