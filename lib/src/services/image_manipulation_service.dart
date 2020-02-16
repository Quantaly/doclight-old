part of 'worker_service.dart';

class ImageManipulationService {
  final WorkerService _worker;

  ImageManipulationService(this._worker);

  Future<String> constrainImageSize(String src) async {
    return serializers
        .deserializeWith(
            ConstrainResponse.serializer,
            await _worker._client.sendRequest(
                'constrainImageSize',
                serializers.serializeWith(ConstrainRequest.serializer,
                    ConstrainRequest((b) => b..src = src))))
        .newSrc;
  }

  Future<void> rotateImageClockwise(int id) async {
    await _worker._client.sendRequest(
        'rotateImageClockwise',
        serializers.serializeWith(
            RotateRequest.serializer, RotateRequest((b) => b..id = id)));
  }
}
