import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_app/models/post_model.dart';
import 'package:post_app/services/db_service.dart';
import 'package:post_app/services/remote_config.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  int _fetchToken = 0;

  MainBloc() : super(const MainInitial([])) {
    on<GetAllDataEvent>(_fetchAllPost);
    on<SearchMainEvent>(_searchPost);
    on<AllPublicPostEvent>(_publicPost);
    on<MyPostEvent>(_myPost);
    on<ActivateRCEvent>(_activate);
  }

  Future<void> _fetchAllPost(GetAllDataEvent event, Emitter emit) async {
    await _load(emit, () => DBService.readAllPost(), (list) {
      return FetchDataSuccess(list, "Successfully fetched!");
    });
  }

  Future<void> _searchPost(SearchMainEvent event, Emitter emit) async {
    final type = state is MyPostSuccess ? SearchType.me : SearchType.all;
    await _load(emit, () => DBService.searchPost(event.searchText, type),
        SearchMainSuccess.new);
  }

  Future<void> _publicPost(AllPublicPostEvent event, Emitter emit) async {
    await _load(emit, () => DBService.publicPost(), AllPublicPostSuccess.new);
  }

  Future<void> _myPost(MyPostEvent event, Emitter emit) async {
    await _load(emit, DBService.myPost, MyPostSuccess.new);
  }

  Future<void> _load(
    Emitter emit,
    Future<List<Post>> Function() fetch,
    MainState Function(List<Post> list) success,
  ) async {
    final token = ++_fetchToken;
    if (state.items.isNotEmpty) {
      emit(MainLoading(state.items, requestId: token));
    }
    try {
      final list = await fetch();
      if (token != _fetchToken) return;
      emit(success(list));
    } catch (e) {
      if (token != _fetchToken) return;
      emit(success(const []));
    }
  }

  Future<void> _activate(ActivateRCEvent event, Emitter emit) async {
    try {
      await RCService.activate().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Remote Config should not hide an already-loaded feed.
    }
  }
}
