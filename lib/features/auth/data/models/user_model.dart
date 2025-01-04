import 'dart:convert';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String email;
  final bool emailVerified;
  final String? displayName;
  final String? photoURL;
  final bool disabled;
  final Metadata metadata;

  User({
    required this.uid,
    required this.email,
    required this.emailVerified,
    this.displayName,
    this.photoURL,
    required this.disabled,
    required this.metadata,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      emailVerified: json['emailVerified'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      disabled: json['disabled'],
      metadata: Metadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'emailVerified': emailVerified,
      'displayName': displayName,
      'photoURL': photoURL,
      'disabled': disabled,
      'metadata': metadata.toJson(),
    };
  }

  @override
  List<Object?> get props =>
      [uid, email, emailVerified, displayName, photoURL, disabled, metadata];
}

class Metadata extends Equatable {
  final String? lastSignInTime;
  final String creationTime;
  final String? lastRefreshTime;

  Metadata({
    this.lastSignInTime,
    required this.creationTime,
    this.lastRefreshTime,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      lastSignInTime: json['lastSignInTime'],
      creationTime: json['creationTime'],
      lastRefreshTime: json['lastRefreshTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastSignInTime': lastSignInTime,
      'creationTime': creationTime,
      'lastRefreshTime': lastRefreshTime,
    };
  }

  @override
  List<Object?> get props => [lastSignInTime, creationTime, lastRefreshTime];
}
