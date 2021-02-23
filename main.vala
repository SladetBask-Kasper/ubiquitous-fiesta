using Gtk;
using Soup;

public class TextFileViewer : Window {

    private TextView text_view;

    public TextFileViewer () {
        this.title = "Bible Viewer";
        this.window_position = WindowPosition.CENTER;
        set_default_size (400*4, 300*4);

        var toolbar = new Toolbar ();
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);

        var open_icon = new Gtk.Image.from_icon_name ("document-open", 
            IconSize.SMALL_TOOLBAR);
        var open_button = new Gtk.ToolButton (open_icon, "Open");
        open_button.is_important = true;
        toolbar.add (open_button);
        open_button.clicked.connect (on_open_clicked);
        
        string initialPage = this.getChapter("https://www.mechon-mamre.org/p/pt/pt26", "01");
        this.text_view = new TextView ();
        this.text_view.buffer.text = initialPage;
        this.text_view.editable = false;
        this.text_view.cursor_visible = false;

        var scroll = new ScrolledWindow (null, null);
        scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll.add (this.text_view);

        var vbox = new Box (Orientation.VERTICAL, 0);
        vbox.pack_start (toolbar, false, true, 0);
        vbox.pack_start (scroll, true, true, 0);
        add (vbox);
    }

    private void on_open_clicked () {
        var file_chooser = new FileChooserDialog ("Open File", this,
                                      FileChooserAction.OPEN,
                                      "_Cancel", ResponseType.CANCEL,
                                      "_Open", ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            open_file (file_chooser.get_filename ());
        }
        file_chooser.destroy ();
    }
    private string getChapter(string link, string num) {
        var fileEnding = ".htm";
        string url = "%s%s%s".printf (link,num,fileEnding);
        stdout.printf ("Getting chapter from %s\n", url);
        var session = new Soup.Session ();
        var message = new Soup.Message ("GET", url);
        session.send_message (message);
        return (string) message.response_body.data   ;
    }

    private void open_file (string filename) {
        try {
            string text;
            FileUtils.get_contents (filename, out text);
            this.text_view.buffer.text = text;
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        var window = new TextFileViewer ();
        window.destroy.connect (Gtk.main_quit);
        var iconPath = "appimg.png";
        try { window.icon = new Gdk.Pixbuf.from_file (iconPath); } 
        catch (Error e) {
            stderr.printf ("Could not load application icon: %s\n%s\n", iconPath, e.message);
        }
        window.show_all ();

        Gtk.main ();
        return 0;
    }
}

