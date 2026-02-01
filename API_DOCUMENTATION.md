# API Documentation

## Overview

This document describes the API integration in Leyu Mobile app. The app communicates with a RESTful API for all backend operations.

## Base Configuration

### Environment Variables

API configuration is managed through environment variables:

```env
API_BASE_URL=http://your-api-url.com/api
```

See [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) for configuration details.

### API Client

**Location**: `lib/core/api/api_client.dart`

The API client is built on Dio with the following features:
- Automatic token management
- Request/response interceptors
- Error handling
- Timeout configuration
- Retry logic

## Authentication

### JWT Token Management

The app uses JWT (JSON Web Tokens) for authentication:

- **Access Token**: Short-lived token for API requests
- **Refresh Token**: Long-lived token for obtaining new access tokens

### Token Flow

```
1. User logs in
   ↓
2. Receive access + refresh tokens
   ↓
3. Store tokens securely
   ↓
4. Include access token in API requests
   ↓
5. On 401 error, refresh access token
   ↓
6. Retry original request
```

### Implementation

```dart
// Login
POST /auth/login
Body: {
  "phone": "+251912345678",
  "password": "password123"
}

Response: {
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": { ... }
}

// Refresh Token
POST /auth/refresh-access-token
Body: {
  "refreshToken": "eyJhbGc..."
}

Response: {
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc..."
}
```

## API Endpoints

### Authentication Endpoints

#### Register
```
POST /auth/register
Body: {
  "phone": "+251912345678"
}
Response: {
  "verificationId": "uuid"
}
```

#### Activate Account
```
POST /auth/activate
Body: {
  "verificationId": "uuid",
  "phone": "+251912345678",
  "otp": "123456"
}
Response: {
  "accessToken": "...",
  "user": { ... }
}
```

#### Login
```
POST /auth/login
Body: {
  "phone": "+251912345678",
  "password": "password123"
}
Response: {
  "accessToken": "...",
  "refreshToken": "...",
  "user": { ... }
}
```

#### Request OTP (Password Reset)
```
POST /auth/request-otp
Body: {
  "phone": "+251912345678"
}
Response: {
  "success": true
}
```

#### Reset Password
```
POST /auth/reset-password
Body: {
  "phone": "+251912345678",
  "otp": "123456",
  "newPassword": "newpassword123"
}
Response: {
  "success": true
}
```

### Task Endpoints

#### Get Tasks
```
GET /tasks
Query Params:
  - status: "available" | "in_progress" | "completed"
  - type: "speech_to_text" | "text_to_speech" | "text_to_text"
  - page: number
  - limit: number

Response: {
  "tasks": [
    {
      "id": "uuid",
      "title": "Task Title",
      "description": "Task Description",
      "type": "speech_to_text",
      "status": "available",
      "reward": 10.50,
      "deadline": "2026-02-01T00:00:00Z"
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 20
}
```

#### Get Task Detail
```
GET /tasks/:id
Response: {
  "id": "uuid",
  "title": "Task Title",
  "description": "Task Description",
  "instructions": "Detailed instructions...",
  "type": "speech_to_text",
  "dataset": {
    "id": "uuid",
    "name": "Dataset Name"
  },
  "microTasks": [
    {
      "id": "uuid",
      "content": "Sample text to read",
      "status": "not_started"
    }
  ]
}
```

#### Submit Task
```
POST /tasks/:id/submit
Body: FormData {
  "microTaskId": "uuid",
  "audioFile": File (for audio tasks),
  "textContent": "transcribed text" (for text tasks)
}
Response: {
  "success": true,
  "submission": {
    "id": "uuid",
    "status": "under_review"
  }
}
```

### Profile Endpoints

#### Get Profile
```
GET /profile
Response: {
  "id": "uuid",
  "firstName": "John",
  "middleName": "Doe",
  "lastName": "Smith",
  "email": "john@example.com",
  "phone": "+251912345678",
  "profilePicture": "https://...",
  "gender": "Male",
  "birthDate": "1990-01-01",
  "language": { ... },
  "dialect": { ... }
}
```

#### Update Profile
```
PUT /profile
Body: {
  "firstName": "John",
  "middleName": "Doe",
  "lastName": "Smith",
  "email": "john@example.com"
}
Response: {
  "success": true,
  "user": { ... }
}
```

#### Upload Profile Picture
```
POST /profile/picture
Body: FormData {
  "file": File
}
Response: {
  "profilePicture": "https://..."
}
```

#### Change Password
```
POST /profile/change-password
Body: {
  "currentPassword": "oldpassword",
  "newPassword": "newpassword"
}
Response: {
  "success": true
}
```

### Notification Endpoints

#### Get Notifications
```
GET /notifications/me
Query Params:
  - page: number
  - limit: number

Response: {
  "notifications": [
    {
      "id": "uuid",
      "title": "Notification Title",
      "message": "Notification message",
      "type": "task_assigned",
      "isRead": false,
      "createdAt": "2026-01-27T10:00:00Z"
    }
  ],
  "total": 50,
  "unreadCount": 10
}
```

#### Mark as Read
```
PUT /notifications/:id/read
Response: {
  "success": true
}
```

#### Mark All as Read
```
PUT /notifications/read-all
Response: {
  "success": true
}
```

#### Get Unread Count
```
GET /notifications/count-new
Response: {
  "count": 10
}
```

### Base Data Endpoints

#### Get Languages
```
GET /languages
Response: {
  "languages": [
    {
      "id": "uuid",
      "name": "Amharic",
      "code": "am"
    }
  ]
}
```

#### Get Dialects
```
GET /dialects
Query Params:
  - languageId: uuid

Response: {
  "dialects": [
    {
      "id": "uuid",
      "name": "Addis Ababa",
      "languageId": "uuid"
    }
  ]
}
```

## Request/Response Format

### Request Headers

All authenticated requests must include:

```
Authorization: Bearer <access_token>
Content-Type: application/json
Accept: application/json
```

### Response Format

#### Success Response

```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}
```

#### Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": { ... }
  }
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error

## Error Handling

### Error Types

```dart
// Network errors
class NetworkFailure extends Failure {
  NetworkFailure(String message);
}

// Server errors
class ServerFailure extends Failure {
  ServerFailure(String message);
}

// Validation errors
class ValidationFailure extends Failure {
  ValidationFailure(String message);
}

// Authentication errors
class AuthFailure extends Failure {
  AuthFailure(String message);
}
```

### Error Handling Pattern

```dart
try {
  final response = await apiClient.get('/endpoint');
  return Right(response.data);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    return Left(AuthFailure('Unauthorized'));
  } else if (e.response?.statusCode == 404) {
    return Left(NotFoundFailure('Resource not found'));
  } else {
    return Left(NetworkFailure(e.message ?? 'Network error'));
  }
} catch (e) {
  return Left(UnknownFailure(e.toString()));
}
```

## Interceptors

### Request Interceptor

```dart
// Add authentication token
onRequest: (options, handler) {
  final token = await getAccessToken();
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  return handler.next(options);
}
```

### Response Interceptor

```dart
// Handle token refresh
onError: (error, handler) async {
  if (error.response?.statusCode == 401) {
    // Refresh token
    final newToken = await refreshAccessToken();

    // Retry request
    final options = error.requestOptions;
    options.headers['Authorization'] = 'Bearer $newToken';
    final response = await dio.fetch(options);

    return handler.resolve(response);
  }
  return handler.next(error);
}
```

## File Upload

### Multipart Form Data

```dart
// Upload audio file
final formData = FormData.fromMap({
  'microTaskId': taskId,
  'audioFile': await MultipartFile.fromFile(
    filePath,
    filename: 'recording.m4a',
    contentType: MediaType('audio', 'm4a'),
  ),
});

final response = await apiClient.post(
  '/tasks/$taskId/submit',
  data: formData,
);
```

## Pagination

### Request

```dart
GET /tasks?page=1&limit=20
```

### Response

```json
{
  "data": [ ... ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

## Rate Limiting

The API may implement rate limiting:

- **Limit**: 100 requests per minute per user
- **Headers**:
  - `X-RateLimit-Limit`: Total allowed requests
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Time when limit resets

## Caching Strategy

### Cache-Control Headers

```
Cache-Control: max-age=3600, must-revalidate
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
```

### Implementation

```dart
// Cache GET requests
final cachedResponse = await cacheManager.get(url);
if (cachedResponse != null && !isExpired(cachedResponse)) {
  return cachedResponse;
}

// Fetch from API
final response = await apiClient.get(url);

// Cache response
await cacheManager.put(url, response);
```

## Testing

### Mock API Responses

```dart
// Mock successful response
when(mockApiClient.get('/tasks'))
    .thenAnswer((_) async => Response(
      data: {'tasks': []},
      statusCode: 200,
    ));

// Mock error response
when(mockApiClient.get('/tasks'))
    .thenThrow(DioException(
      requestOptions: RequestOptions(path: '/tasks'),
      response: Response(
        statusCode: 401,
        requestOptions: RequestOptions(path: '/tasks'),
      ),
    ));
```

## Security Considerations

### Best Practices

1. **HTTPS Only**: All API calls over HTTPS
2. **Token Storage**: Store tokens in secure storage
3. **Token Expiry**: Implement automatic token refresh
4. **Input Validation**: Validate all inputs before sending
5. **Error Messages**: Don't expose sensitive information
6. **Rate Limiting**: Respect API rate limits
7. **Timeout**: Set appropriate timeouts

### Token Security

```dart
// Store tokens securely
await secureStorage.write(
  key: 'access_token',
  value: accessToken,
);

// Never log tokens
// ❌ Bad
print('Token: $accessToken');

// ✅ Good
logger.d('Token received');
```

## Troubleshooting

### Common Issues

#### 401 Unauthorized
- Check if token is valid
- Verify token refresh logic
- Ensure Authorization header is set

#### 404 Not Found
- Verify endpoint URL
- Check API base URL configuration
- Ensure resource exists

#### Network Timeout
- Check internet connection
- Increase timeout duration
- Implement retry logic

#### 422 Validation Error
- Check request body format
- Verify required fields
- Validate data types

## Additional Resources

- [API Constants](lib/core/api/api_constants.dart)
- [API Client](lib/core/api/api_client.dart)
- [API Interceptor](lib/core/api/api_interceptor.dart)
- [Environment Setup](ENVIRONMENT_SETUP.md)

## Support

For API-related issues:
1. Check this documentation
2. Review error logs
3. Test with API client (Postman, Insomnia)
4. Contact backend team

---

**Last Updated**: January 27, 2026
