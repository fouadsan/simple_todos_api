const url = "http://10.0.2.2:8000/notes/";

var retrieveUrl = Uri.parse(url);

var createUrl = Uri.parse(url + "create/");

Uri deleteUrl(int pk) {
  return Uri.parse(url + "$pk" + "/delete/");
}

Uri updateUrl(int pk) {
  return Uri.parse(url + "$pk" + "/update/");
}
