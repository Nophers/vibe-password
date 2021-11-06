module app; 
import vibe.vibe; 

import vibe.appmain;
import vibe.http.auth.basic_auth;
import vibe.http.router;
import vibe.http.server;
import std.functional : toDelegate;




bool checkPassword(string user, string password) 
{
	return user == "admins" && password == "r4MKC(uu2;M:?7/ggRSDVvvgtighwDOFIJF";
}

void auth(HTTPServerRequest req, HTTPServerResponse res)
{
	
}

void main() {
	auto router = new URLRouter; 

	router.get("/admin", performBasicAuth("Site Realm", toDelegate(&checkPassword))); 
	router.any("*", &auth);

	auto settings = new HTTPServerSettings; 
	settings.port = 8000;
	settings.bindAddresses = ["::1", "127.0.0.1"]; 

	auto listener = listenHTTP(settings, router); 
	scope(exit) listener.stopListening(); 
	runApplication();
}

// Authenticating - Interface
class WebInterface {
	private {
		SessionVar!(bool, "authenticated") ms_authenticated;
	}
}

void index()
	{
		bool authenticated = ms_authenticated;
		render!("/admin", authenticated);
		// index.dt ~ /views/index.dt
	}

void postLogin(string username, string password)
	{
		enforceHTTP(username == "user" && password == "secret",
			HTTPStatus.forbidden, "Invalid credentials!");
		ms_authenticated = true;
		redirect("/");
		// If the Data is incorrect, redirect to the Main Page
	}
	
	// POST /logout
	@method(HTTPMethod.POST) @path("logout")
	void postLogout()
	{
		ms_authenticated = false;
		terminateSession();
		redirect("/");
		// redirect to the Main Page after Logout
	}
}