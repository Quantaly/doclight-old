part of 'worker_service.dart';

class RenderingService {
  final WorkerService _worker;
  final html.AnchorElement _downloadAnchor = _createDownloadAnchor();

  RenderingService(this._worker);

  Future<String> renderDocument(int id) async {
    var request = RenderRequest((b) => b..id = id);
    var responseF = _worker._client.sendRequest(
        'render', serializers.serializeWith(RenderRequest.serializer, request));
    html.window.alert('Rendering has started. It may take a while, '
        'but please leave this tab open. '
        'The PDF will be automatically saved as soon as it is ready.');
    var response =
        serializers.deserializeWith(RenderResponse.serializer, await responseF);
    return response.url;
  }

  void download(String url, String name) {
    _downloadAnchor
      ..href = url
      ..download = name
      ..click();
  }

  Future<void> renderAndDownload(int id, String name) async {
    download(await renderDocument(id), name);
  }

  static html.AnchorElement _createDownloadAnchor() {
    var ret = html.AnchorElement()..style.display = 'none';
    html.window.document.querySelector('body').append(ret);
    return ret;
  }
}
