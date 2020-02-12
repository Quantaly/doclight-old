part of 'worker_service.dart';

class ImageManipulationService {
  final WorkerService _worker;

  ImageManipulationService(this._worker);

  Future<void> rotateImageClockwise(int id) async {
    await _worker._client.sendRequest(
        'rotateImageClockwise', (RotateRequest()..id = id).toJson());
  }
}