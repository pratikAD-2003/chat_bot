// FINAL, CORRECTED MODEL FOR THE /responses ENDPOINT
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GenerateTaskResponse {
  final String? id;
  final String? status;
  final List<Output>? output;

  GenerateTaskResponse({this.id, this.status, this.output});

  factory GenerateTaskResponse.fromJson(Map<String, dynamic> json) {
    return GenerateTaskResponse(
      id: json['id'],
      status: json['status'],
      output: (json['output'] as List<dynamic>?)
          ?.map((v) => Output.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Output {
  final String? type;
  final String? role;
  final List<Content>? content;

  Output({this.type, this.role, this.content});

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
      type: json['type'],
      role: json['role'],
      content: (json['content'] as List<dynamic>?)
          ?.map((v) => Content.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Content {
  final String? type;
  final String? text;

  Content({this.type, this.text});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'],
      text: json['text'],
    );
  }
}