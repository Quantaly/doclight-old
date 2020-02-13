part of 'worker_service.dart';

class ImageManipulationService {
  final WorkerService _worker;

  ImageManipulationService(this._worker);

  Future<void> rotateImageClockwise(int id) async {
    await _worker._client.sendRequest(
        'rotateImageClockwise',
        serializers.serializeWith(
            RotateRequest.serializer, RotateRequest((b) => b..id = id)));
  }
}
