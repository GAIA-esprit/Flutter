const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const quizsPageDisplayName = "Quizs";
const quizsPageRoute = "/quizs";

const productsPageDisplayName = "Shop";
const productsPageRoute = "/products";

const ordersPageDisplayName = "Orders";
const orderssPageRoute = "/orders";

const postPageDisplayName = "Posts";
const postPageRoute = "/posts";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
 MenuItem(overviewPageDisplayName, overviewPageRoute),
 MenuItem(quizsPageDisplayName, quizsPageRoute),
MenuItem(postPageDisplayName, postPageRoute),
MenuItem(productsPageDisplayName, productsPageRoute),
 MenuItem(clientsPageDisplayName, clientsPageRoute),
 MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
