import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/interview_session.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveInterviewSession(InterviewSession session) async {
    await _db.collection('interview_sessions').add(session.toMap());
  }
}
