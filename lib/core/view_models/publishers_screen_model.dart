import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../locator.dart';
import '../models/publisher.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class PublishersScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();

  List<Publisher> _publishers = [];
  List<Publisher> get publishers => _publishers;
  void _setPublishers(List<Publisher> publishers) {
    _publishers = publishers;
    notifyListeners();
  }

  Future<void> fetchPublishersFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final publishers = await _remoteService.fetchPublishers();
      _setPublishers(publishers);
    } else {
      _setPublishers(publishers);
    }
    setState(ViewState.idle);
  }
}