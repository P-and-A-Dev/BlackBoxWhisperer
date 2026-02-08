class ArtifactManifest {
  final String schemaVersion;
  final String runId;
  final String projectRoot;
  final String adapter;
  final String createdAt;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> outputs;

  ArtifactManifest({
    required this.schemaVersion,
    required this.runId,
    required this.projectRoot,
    required this.adapter,
    required this.createdAt,
    required this.inputs,
    required this.outputs,
  });

  factory ArtifactManifest.fromJson(Map<String, dynamic> json) {
    return ArtifactManifest(
      schemaVersion: json['schemaVersion'] as String,
      runId: json['runId'] as String,
      projectRoot: json['projectRoot'] as String,
      adapter: json['adapter'] as String,
      createdAt: json['createdAt'] as String,
      inputs: json['inputs'] as Map<String, dynamic>,
      outputs: json['outputs'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'runId': runId,
      'projectRoot': projectRoot,
      'adapter': adapter,
      'createdAt': createdAt,
      'inputs': inputs,
      'outputs': outputs,
    };
  }
}
