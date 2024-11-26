using GLib;

namespace Merlin {
  private class MarkdownFile {
      public string content { get; set; }
      public string path { get; set; }
      
      public MarkdownFile(string path, string content) {
          this.path = path;
          this.content = content;
      }
      
      public string get_output_path() {
          return path.replace(
              BuildCommand.CONTENT_DIR, 
              BuildCommand.OUTPUT_DIR
          ).replace(".md", ".html");
      }
  }

  public class BuildCommand {
      public const string CONTENT_DIR = "content";
      public const string OUTPUT_DIR = "public";
      
      public void execute() throws Error {
          check_content_directory();
          ensure_output_directory();
          scan_directory(CONTENT_DIR);
      }
      
      private void check_content_directory() throws Error {
          var dir = File.new_for_path(CONTENT_DIR);
          
          if (!dir.query_exists()) {
              throw new MerlinError.CONTENT_NOT_FOUND(
                  "Content directory not found. Please create a '%s' directory.", 
                  CONTENT_DIR
              );
          }
      }

      private void ensure_output_directory() throws Error {
          var dir = File.new_for_path(OUTPUT_DIR);
          
          if (!dir.query_exists()) {
              dir.make_directory();
              stdout.printf("Created output directory: %s\n", OUTPUT_DIR);
          }
      }
      
      private void scan_directory(string path) throws Error {
          var dir = File.new_for_path(path);
          var enumerator = dir.enumerate_children(
              FileAttribute.STANDARD_NAME + "," + 
              FileAttribute.STANDARD_TYPE,
              FileQueryInfoFlags.NONE
          );
          
          FileInfo? file_info = null;
          while ((file_info = enumerator.next_file()) != null) {
              var name = file_info.get_name();
              var child_path = Path.build_filename(path, name);
              
              if (file_info.get_file_type() == FileType.DIRECTORY) {
                  var relative_path = child_path.replace(CONTENT_DIR, OUTPUT_DIR);
                  ensure_directory(relative_path);
                  scan_directory(child_path);
              } else if (name.has_suffix(".md")) {
                  process_markdown_file(child_path);
              }
          }
      }

      private void ensure_directory(string path) throws Error {
          var dir = File.new_for_path(path);
          if (!dir.query_exists()) {
              dir.make_directory();
              stdout.printf("Created directory: %s\n", path);
          }
      }

      private void process_markdown_file(string file_path) throws Error {
          stdout.printf("Processing markdown file: %s\n", file_path);
          
          var file = File.new_for_path(file_path);
          uint8[] contents;
          string etag_out;
          
          try {
              file.load_contents(null, out contents, out etag_out);
              var content = (string) contents;
              
              var md_file = new MarkdownFile(file_path, content);
              create_html_file(md_file);
              
          } catch (Error e) {
              stderr.printf("Error reading file %s: %s\n", file_path, e.message);
              throw e;
          }
      }

      private void create_html_file(MarkdownFile md_file) throws Error {
          var output_path = md_file.get_output_path();
          var output_file = File.new_for_path(output_path);
          
          // Por enquanto, apenas copia o conteúdo raw
          var parent = output_file.get_parent();
          if (parent != null && !parent.query_exists()) {
              parent.make_directory_with_parents();
          }
          
          stdout.printf("Creating HTML file: %s\n", output_path);
          
          var html_content = """
              <!DOCTYPE html>
              <html>
              <head>
                  <meta charset="UTF-8">
                  <title>Page</title>
              </head>
              <body>
                  <pre>%s</pre>
              </body>
              </html>
          """.printf(md_file.content);
          
          output_file.replace_contents(
              html_content.data,
              null,
              false,
              FileCreateFlags.REPLACE_DESTINATION,
              null
          );
      }
  }
}
