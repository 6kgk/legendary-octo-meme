import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 【职教通】前端服务层 - 深度对齐作业帮 OCR 架构
// 职责：处理图像上传、OCR 识别与苏格拉底式启发逻辑流

class TutorService {
  static const String baseUrl = "http://10.0.2.2:3000";

  // 1. 拍搜 OCR 识别流
  Future<Map<String, dynamic>> recognizeQuestion(String imagePath) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/tutor/recognize'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    
    // 模拟网络延迟与识别过程
    await Future.delayed(Duration(seconds: 2));
    
    return {
      "questionId": "Q_TRIG_001",
      "content": "求 sin(75°) 的值。",
      "topic": "三角变换",
      "weakPoint": "辅助角公式/特殊角性质",
      "isPrerequisiteMissing": true,
      "prerequisiteTopic": "相似三角形比例"
    };
  }

  // 2. 苏格拉底式流式引导 (Task #102)
  Stream<String> getSocraticStream(String userId, String base64Image, String message) async* {
    final client = http.Client();
    final request = http.Request('POST', Uri.parse('$baseUrl/api/tutor/guide/stream'));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'userId': userId,
      'imageBase64': base64Image,
      'userMessage': message,
      'subject': '数学'
    });

    try {
      final response = await client.send(request);
      final stream = response.stream.transform(utf8.decoder).transform(LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final String dataStr = line.substring(6);
          if (dataStr == '[DONE]') break;
          try {
            final Map<String, dynamic> data = jsonDecode(dataStr);
            if (data.containsKey('chunk')) {
              yield data['chunk'];
            }
          } catch (e) {
            // 忽略非 JSON 数据行
          }
        }
      }
    } finally {
      client.close();
    }
  }
}
