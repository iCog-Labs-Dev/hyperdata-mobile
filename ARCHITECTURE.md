# Architecture Documentation

## Overview

Leyu Mobile follows **Clean Architecture** principles with clear separation of concerns, making the codebase maintainable, testable, and scalable.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Controllers, State Management)    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Models, Data Sources, Repositories)   │
└─────────────────────────────────────────┘
```

## Layer Details

### 1. Presentation Layer

**Responsibility**: Handle UI and user interactions

**Components**:
- **Pages**: Full-screen views
- **Widgets**: Reusable UI components
- **Controllers**: State management with GetX

**Example Structure**:
```
features/auth/presentation/
├── controllers/
│   └── auth_controller.dart
├── pages/
│   ├── login_page.dart
│   └── register_page.dart
└── widgets/
    ├── login_form_widget.dart
    └── register_form_widget.dart
```

**Guidelines**:
- Keep UI logic in controllers
- Make widgets as dumb as possible
- Use GetX for state management
- Separate business logic from UI

### 2. Domain Layer

**Responsibility**: Business logic and rules

**Components**:
- **Entities**: Business objects
- **Use Cases**: Business operations
- **Repository Interfaces**: Data access contracts

**Example Structure**:
```
features/auth/domain/
├── entities/
│   └── user_entity.dart
├── repositories/
│   └── auth_repository.dart
└── usecases/
    └── auth_usecase.dart
```

**Guidelines**:
- No dependencies on outer layers
- Pure Dart code (no Flutter dependencies)
- Define repository interfaces
- Implement business rules

### 3. Data Layer

**Responsibility**: Data access and management

**Components**:
- **Models**: Data transfer objects
- **Data Sources**: API clients, local storage
- **Repository Implementations**: Concrete implementations

**Example Structure**:
```
features/auth/data/
├── datasources/
│   ├── auth_remote_data_source.dart
│   └── auth_local_data_source.dart
├── models/
│   └── user_model.dart
└── repositories/
    └── auth_repository_impl.dart
```

**Guidelines**:
- Implement repository interfaces from domain
- Handle data transformations
- Manage caching strategies
- Handle errors and exceptions

## Core Components

### API Client

**Location**: `lib/core/api/`

**Responsibilities**:
- HTTP requests with Dio
- Request/response interceptors
- Error handling
- Token management

**Key Files**:
- `api_client.dart` - HTTP client configuration
- `api_constants.dart` - API endpoints
- `api_interceptor.dart` - Request/response interceptors

### Cache Management

**Location**: `lib/core/cache/`

**Responsibilities**:
- Local data persistence with Hive
- Secure storage for sensitive data
- Cache invalidation strategies

**Key Files**:
- `cache_manager.dart` - Cache operations
- `local_storage.dart` - Secure storage wrapper
- `cache_keys.dart` - Cache key constants

### Services

**Location**: `lib/core/services/`

**Responsibilities**:
- Cross-cutting concerns
- Third-party integrations
- Shared functionality

**Key Files**:
- `audio_manager_service.dart` - Audio management
- `onesignal_service.dart` - Push notifications
- `onboarding_service.dart` - Onboarding state

### Localization

**Location**: `lib/core/localization/`

**Responsibilities**:
- Multi-language support
- Translation management
- Locale switching

**Key Files**:
- `app_translations.dart` - Translation loader
- `localization_controller.dart` - Locale management
- `translations/` - Language files

## State Management

### GetX Pattern

```dart
// Controller
class HomeController extends GetxController {
  final _tasks = <Task>[].obs;
  List<Task> get tasks => _tasks;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading.value = true;
    try {
      final result = await taskUseCase.getTasks();
      _tasks.value = result;
    } finally {
      _isLoading.value = false;
    }
  }
}

// View
class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return LoadingWidget();
      }
      return ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(task: controller.tasks[index]);
        },
      );
    });
  }
}
```

## Navigation

### Route Management

**Location**: `lib/routes/`

**Pattern**: Named routes with GetX

```dart
// Define routes
class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const taskDetail = '/task-detail';
}

// Configure pages
class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}

// Navigate
Get.toNamed(AppRoutes.home);
Get.offAllNamed(AppRoutes.login);
Get.back();
```

## Dependency Injection

### GetX Bindings

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut(() => TaskRemoteDataSource(Get.find()));

    // Repositories
    Get.lazyPut(() => TaskRepository(Get.find()));

    // Use cases
    Get.lazyPut(() => TaskUseCase(Get.find()));

    // Controllers
    Get.lazyPut(() => HomeController(Get.find()));
  }
}
```

## Error Handling

### Failure Pattern

```dart
// Define failures
abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

// Use Either for error handling
Future<Either<Failure, List<Task>>> getTasks() async {
  try {
    final tasks = await remoteDataSource.fetchTasks();
    return Right(tasks);
  } on DioException catch (e) {
    return Left(NetworkFailure(e.message ?? 'Network error'));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}

// Handle in controller
final result = await taskUseCase.getTasks();
result.fold(
  (failure) => showErrorMessage(failure.message),
  (tasks) => _tasks.value = tasks,
);
```

## Data Flow

### Complete Flow Example

```
User Action (UI)
      ↓
Controller Method
      ↓
Use Case
      ↓
Repository Interface
      ↓
Repository Implementation
      ↓
Data Source (Remote/Local)
      ↓
API/Database
      ↓
Response
      ↓
Model → Entity
      ↓
Use Case
      ↓
Controller
      ↓
UI Update
```

### Code Example

```dart
// 1. User taps button
onPressed: () => controller.submitTask(task)

// 2. Controller
Future<void> submitTask(Task task) async {
  final result = await taskUseCase.submitTask(task);
  result.fold(
    (failure) => showError(failure.message),
    (success) => showSuccess('Task submitted'),
  );
}

// 3. Use Case
Future<Either<Failure, bool>> submitTask(Task task) async {
  return await repository.submitTask(task);
}

// 4. Repository
Future<Either<Failure, bool>> submitTask(Task task) async {
  try {
    await remoteDataSource.submitTask(task.toModel());
    await localDataSource.cacheTask(task.toModel());
    return Right(true);
  } catch (e) {
    return Left(NetworkFailure(e.toString()));
  }
}

// 5. Data Source
Future<void> submitTask(TaskModel task) async {
  await apiClient.post('/tasks/submit', data: task.toJson());
}
```

## Testing Strategy

### Unit Tests

Test business logic in isolation:

```dart
test('should return tasks when API call succeeds', () async {
  // Arrange
  when(mockDataSource.fetchTasks())
      .thenAnswer((_) async => [mockTask]);

  // Act
  final result = await repository.getTasks();

  // Assert
  expect(result, Right([mockTask]));
});
```

### Widget Tests

Test UI components:

```dart
testWidgets('should display task list', (tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.byType(TaskCard), findsWidgets);
});
```

### Integration Tests

Test complete flows:

```dart
testWidgets('complete task submission flow', (tester) async {
  // Navigate to task
  await tester.tap(find.byType(TaskCard).first);
  await tester.pumpAndSettle();

  // Submit task
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  // Verify success
  expect(find.text('Task submitted'), findsOneWidget);
});
```

## Performance Considerations

### Optimization Strategies

1. **Lazy Loading**: Load data on demand
2. **Pagination**: Load data in chunks
3. **Caching**: Cache frequently accessed data
4. **Image Optimization**: Use cached_network_image
5. **List Optimization**: Use ListView.builder
6. **Const Constructors**: Use const where possible

### Memory Management

```dart
@override
void onClose() {
  // Dispose controllers
  textController.dispose();

  // Cancel subscriptions
  subscription?.cancel();

  // Close streams
  streamController.close();

  super.onClose();
}
```

## Security

### Best Practices

1. **Environment Variables**: Store secrets in .env
2. **Secure Storage**: Use flutter_secure_storage for tokens
3. **HTTPS**: All API calls over HTTPS
4. **Input Validation**: Validate all user inputs
5. **Token Refresh**: Automatic token refresh
6. **Error Messages**: Don't expose sensitive info

## Scalability

### Adding New Features

1. Create feature folder in `lib/features/`
2. Implement data layer (models, data sources, repositories)
3. Implement domain layer (entities, use cases)
4. Implement presentation layer (controllers, pages, widgets)
5. Add routes in `lib/routes/`
6. Create bindings for dependency injection
7. Add tests

### Module Independence

Each feature module should be:
- **Self-contained**: All related code in one folder
- **Independent**: Minimal dependencies on other features
- **Testable**: Easy to test in isolation
- **Reusable**: Components can be reused

## Conclusion

This architecture provides:
- ✅ Clear separation of concerns
- ✅ Testability at all layers
- ✅ Maintainability and scalability
- ✅ Independence of frameworks
- ✅ Flexibility to change implementations

For questions or suggestions, see [CONTRIBUTING.md](CONTRIBUTING.md).
