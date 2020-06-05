class ConfigUri {
  String host;
  String port;
  String uri;

  ConfigUri() {
    // this.host = "10.0.2.2";
    // this.port = "3000";
    this.uri = "api/colfunding-gateway-ms";
    this.host = "104.154.23.227";
    this.port = "";
    this.uri  =  "crowdlending/api/colfunding-gateway-ms";
  }
  String getUri() {
    // String url = 'http://$host:$port/$uri';
    // print(url);
    String url = 'http://$host$port/$uri';

    return url;
  }
}
