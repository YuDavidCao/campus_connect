List<String> tags = [
  "Community service"
      "free",
  "paid",
  "on-campus",
  "off-campus",
  "online",
  "student-held",
  "school-held",
  // "professional skills required",
  // "no professional skills required",
];

final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

// const baseUrl = "http://44.221.194.95:5000";
const baseUrl = "http://10.0.2.2:5000";
