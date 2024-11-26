public errordomain MerlinError {
  INVALID_COMMAND
}

public class Merlin {
  private static bool version = false;

  private const OptionEntry[] options = {
    { "version", 'v', 0, OptionArg.NONE, ref version, "Display version number", null },
    { null }
  };

  public static int main(string[] args) {
    try {
        var opt_context = new OptionContext("[command] - Static site generator");
        opt_context.set_help_enabled(true);
        opt_context.add_main_entries(options, null);
        opt_context.parse(ref args);

        if (version) {
            stdout.printf("Merlin v0.1.0\n");
            return 0;
        }

        if (args.length < 2) {
            stdout.printf("Usage: merlin [command]\n");
            stdout.printf("Commands:\n");
            stdout.printf("  build    Build the static site\n");
            stdout.printf("  serve    Start development server\n");
            stdout.printf("  new      Create new content\n");
            return 1;
        }

        switch (args[1]) {
            case "build":
                stdout.printf("Building site...\n");
                break;
            case "serve":
                stdout.printf("Starting development server...\n");
                break;
            case "new":
                stdout.printf("Creating new content...\n");
                break;
            default:
                throw new MerlinError.INVALID_COMMAND("Unknown command: %s", args[1]);
        }

        return 0;
    } catch (Error e) {
        stderr.printf("Error: %s\n", e.message);
        return 1;
    };
  }
}
