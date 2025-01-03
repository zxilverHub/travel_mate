class Usermodel {
  late int id;
  late String username;
  late String imgURL;

  Usermodel({
    required this.id,
    required this.username,
    required this.imgURL,
  });
}

List<Usermodel> usersFromModel = [
  Usermodel(
    id: 1,
    username: "ZX",
    imgURL: "assets/images/app/comicon.png",
  ),
  Usermodel(
    id: 2,
    username: "HARITH",
    imgURL: "assets/images/app/cornericon.png",
  ),
];
