// ignore_for_file: constant_identifier_names

enum LoadState { loading, idle, success, error, loadmore, done }

enum LoginLoadState { loading, idle, success, error, unverified }

enum CurrentState { loggedIn, onboarded, initial }

enum OverLayType { loader, message, none, toast }

enum MessageType { error, success }


extension LoadExtension on LoadState {
  bool get isLoading => this == LoadState.loading;
  bool get isLoaded => this == LoadState.success;
  bool get isError => this == LoadState.error;
  bool get isInitial => this == LoadState.idle;
  bool get isLoadMore => this == LoadState.loadmore;
  bool get isCompleted => this == LoadState.done;
}


