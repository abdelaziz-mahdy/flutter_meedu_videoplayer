import 'dart:io';

import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class DataSource {
  File? file;
  String? source, package;
  DataSourceType type;
  VideoFormat? formatHint;
  Future<ClosedCaptionFile>? closedCaptionFile; // for subtiles
  Map<String, String>? httpHeaders; // for headers
  DataSource({
    this.file,
    this.source,
    required this.type,
    this.formatHint,
    this.package,
    this.closedCaptionFile,
    this.httpHeaders,
  }) : assert((type == DataSourceType.file && file != null) || source != null);

  DataSource copyWith({
    File? file,
    String? source,
    String? package,
    DataSourceType? type,
    VideoFormat? formatHint,
    Map<String, String>? httpHeaders,
    Future<ClosedCaptionFile>? closedCaptionFile,
  }) {
    return DataSource(
      file: file ?? this.file,
      source: source ?? this.source,
      type: type ?? this.type,
      package: package ?? this.package,
      formatHint: formatHint ?? this.formatHint,
      httpHeaders: httpHeaders ?? this.httpHeaders,
      closedCaptionFile: closedCaptionFile ?? this.closedCaptionFile,
    );
  }
}
