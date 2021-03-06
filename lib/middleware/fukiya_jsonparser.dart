part of fukiya;

class FukiyaJsonParser implements FukiyaMiddleware {

  String getName() {
    return "FukiyaJsonParser";
  }

  bool process(FukiyaContext context, Completer completer) {
    var contentType = context.request.headers.contentType;
    if(contentType != null && contentType.primaryType == "application" && contentType.subType == "json") {
      _parseJsonBody(context, completer);
      return true;
    }
    return false;
  }

  void _parseJsonBody(FukiyaContext context, Completer completer) {
    List<String> lines = new List<String>();
    context.request.transform(new Utf8Decoder())
                   .transform(new LineSplitter())
                   .listen((String line) {
                     lines.add(line);
                   },
                   onError: (e) => print("[Fukiya][FormParser]${e}"),
                   onDone: () {
                     context.parsedBody = JSON.parse(lines.join("\n"));
                     completer.complete(context);
                   });
  }
}



