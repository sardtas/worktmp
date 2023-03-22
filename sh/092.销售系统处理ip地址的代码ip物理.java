private String searchByAliyun(String ip) {
    String host = "https://dm-81.data.aliyun.com";
    String path = "/rest/160601/ip/getIpInfo.json";
    String method = "GET";
    String appcode = "b02c09b00db649449ea63cd5459af144";
    Map<String, Object> headers = new HashMap<>();
    headers.put("Authorization", "APPCODE " + appcode);
    Map<String, Object> querys = new HashMap<>();
    querys.put("ip", ip);
    // TODO cache to db
    try {
      String reg = httpClient.get(host+path,querys,headers);
      JSONObject info = JSONObject.parseObject(reg);
      if (info.containsKey("code") && info.getInteger("code") == 0) {// 成功
        JSONObject dataInfo = info.getJSONObject("data");
        if (dataInfo.getString("region").equals(dataInfo.getString("city"))) {
          return dataInfo.getString("city") + dataInfo.getString("isp");
        } else {
          return dataInfo.getString("region") + dataInfo.getString("city")
                    + dataInfo.getString("isp");
        }
      }
    } catch (Exception e) {
      log.warn("search ip by aliyun failure {}", e.getMessage());
    }
    return null;
  }






httpClient
