
import '../../models/Lists.dart';

class taskList {
  String id;
  int number;
  String name;
  String content;
  String directorId;
  String director;
  String executorId;
  String executor;
  DateTime dateCreate;
  DateTime dateTo;
  String statusId;
  String status;
  bool reportToEnd;
  String resultText;
  String objectId;
  String objectName;
  String generalTaskId;
  String generalTaskName;
  int generalTaskNumber;
  DateTime generalTaskDateCreate;
  String generalTaskExecutor;
  bool timeTracking;
  bool changeDeadline;
  bool resultControl;
  bool taskCloseAuto;
  bool deadlineFromSubtask;
  bool schemeTaxi;

  taskList({
    required this.id,
    required this.number,
    required this.name,
    required this.content,
    required this.directorId,
    required this.director,
    required this.executorId,
    required this.executor,
    required this.dateCreate,
    required this.dateTo,
    required this.statusId,
    required this.status,
    required this.reportToEnd,
    required this.resultText,
    required this.objectId,
    required this.objectName,
    required this.generalTaskId,
    required this.generalTaskName,
    required this.generalTaskNumber,
    required this.generalTaskDateCreate,
    required this.generalTaskExecutor,
    required this.timeTracking,
    required this.changeDeadline,
    required this.resultControl,
    required this.taskCloseAuto,
    required this.deadlineFromSubtask,
    required this.schemeTaxi,
  });

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'number': number,
        'name': name,
        'content': content,
        'directorId': directorId,
        'director': director,
        'executorId': executorId,
        'executor': executor,
        'dateCreate': dateCreate.toIso8601String(),
        'dateTo': dateTo.toIso8601String(),
        'statusId': statusId,
        'status': status,
        'reportToEnd': reportToEnd,
        'resultText': resultText,
        'objectId': objectId ?? '',
        'objectName': objectName ?? '',
        'generalTaskId': generalTaskId ?? '',
        'generalTaskName': generalTaskName ?? '',
        'generalTaskNumber': generalTaskNumber ?? 0,
        'generalTaskDateCreate': generalTaskDateCreate.toIso8601String() ?? DateTime.now().toIso8601String(),
        'generalTaskExecutor': generalTaskExecutor ?? '',
        'timeTracking': timeTracking,
        'changeDeadline': changeDeadline,
        'resultControl': resultControl,
        'taskCloseAuto': taskCloseAuto,
        'deadlineFromSubtask': deadlineFromSubtask,
        'schemeTaxi': schemeTaxi
      };

  taskList.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        number = json['number'],
        name = json['name'],
        content = json['content'],
        director = json['director'],
        directorId = json['directorId'],
        executor = json['executor'],
        executorId = json['executorId'],
        dateCreate = DateTime.tryParse(json['dateCreate'])!,
        dateTo = DateTime.tryParse(json['dateTo'])!,
        statusId = json['statusId'],
        status = json['status'],
        reportToEnd = json['reportToEnd'],
        resultText = json['resultText'],
        objectId = json['objectId'],
        objectName = json['objectName'],
        generalTaskId = json['generalTaskId'],
        generalTaskName = json['generalTaskName'],
        generalTaskNumber = json['generalTaskNumber'] ?? 0,
        generalTaskDateCreate = DateTime.tryParse(json['generalTaskDateCreate'] ?? DateTime.now().toString()) ?? DateTime.now(),
        generalTaskExecutor = json['generalTaskExecutor'] ?? '',
        timeTracking = json['timeTracking'],
        changeDeadline = json['changeDeadline'],
        resultControl = json['resultControl'],
        taskCloseAuto = json['taskCloseAuto'],
        deadlineFromSubtask = json['deadlineFromSubtask'],
        schemeTaxi = json['schemeTaxi'];
}

class taskCommentList {
  String id;
  String userId;
  String userName;
  String comment;
  DateTime date;
  bool system;
  List<ListAttach> file;

  taskCommentList({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.date,
    required this.system,
    required this.file
  });

  taskCommentList.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        userId = json['userId'],
        userName = json['userName'],
        comment = json['comment'],
        system = json['system'],
        date = DateTime.tryParse(json['date'] ?? DateTime.now().toString()) ?? DateTime.now(),
        file = json['file'].map<ListAttach>((item) {
          return ListAttach.fromJson(item);
        }).toList();
}

class taskObservertList {
  String userId;
  String userName;

  taskObservertList({
    required this.userId,
    required this.userName,
  });

  taskObservertList.fromJson(Map<String, dynamic> json) :
        userId = json['observerId'],
        userName = json['observer'];

  Map<String, dynamic> toJson() =>
      {
        'observerId': userId,
        'observer': userName
      };
}

class taskSubTaskList {
  String id;
  int subTaskNumber;
  DateTime subTaskDateCreate;
  String subTaskExecutorId;
  String subTaskExecutor;
  String subTaskName;

  taskSubTaskList({
    required this.id,
    required this.subTaskDateCreate,
    required this.subTaskNumber,
    required this.subTaskExecutorId,
    required this.subTaskExecutor,
    required this.subTaskName,
  });

  taskSubTaskList.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        subTaskDateCreate = DateTime.tryParse(json['subTaskDateCreate'] ?? DateTime.now().toString()) ?? DateTime.now(),
        subTaskNumber = json['subTaskNumber'],
        subTaskExecutorId = json['subTaskExecutorId'],
        subTaskExecutor = json['subTaskExecutor'],
        subTaskName = json['subTaskName'];
}

class resultList {
  String resultId;
  String resultName;
  String resultComment;
  String resultCode;
  String resultFind;

  resultList({
    required this.resultId,
    required this.resultName,
    required this.resultComment,
    required this.resultCode,
    required this.resultFind,
  });

  resultList.fromJson(Map<String, dynamic> json) :
    resultId = json['resultId'],
    resultName = json['resultName'],
    resultComment = json['resultComment'],
    resultCode = json['resultCode'].toString(),
    resultFind = json['resultName'] + json['resultComment'] + json['resultCode'].toString();
}



