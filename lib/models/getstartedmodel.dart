class GetstartedModel {
  late int index;
  late String title;
  late String content;

  GetstartedModel({
    required this.index,
    required this.title,
    required this.content,
  });
}

List<GetstartedModel> getstarted = [
  GetstartedModel(
    index: 0,
    title: "Services Recommendation",
    content:
        "Discover the best local services wherever you are! Whether it's restaurants, hotels, or activities, we’ll show you trusted recommendations based on real reviews and your preferences.",
  ),
  GetstartedModel(
    index: 1,
    title: "Help Within Reach",
    content:
        "Safety is our top priority. Instantly access emergency contacts and local help services with our one-tap SOS feature.",
  ),
  GetstartedModel(
    index: 2,
    title: "Community Chat",
    content:
        "Connect with other travelers in real time! Share tips, ask for advice, or make new friends in public chat rooms or private messages.",
  ),
];
