using Soup;

string getChapter(string link, string num) {
    var fileEnding = ".htm";
    string url = "%s%s%s".printf (link,num,fileEnding);
    stdout.printf ("Getting chapter from %s\n", url);
    var session = new Soup.Session ();
    var message = new Soup.Message ("GET", url);
    session.send_message (message);
    return (string) message.response_body.data   ;
}
int main (string[] args) {
    stdout.printf ("Output: \n%s\n", getChapter("https://www.mechon-mamre.org/p/pt/pt26", "01"));
    return 0;
}
