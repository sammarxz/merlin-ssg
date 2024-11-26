using GLib;

namespace Merlin {
  public class BuildCommand {
      private const string CONTENT_DIR = "content";
      private const string OUTPUT_DIR = "public";
      
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
                  stdout.printf("Directory: %s\n", child_path);
                  scan_directory(child_path);
              } else if (name.has_suffix(".md")) {
                  process_markdown_file(child_path);
              }
          }
      }

      private void process_markdown_file(string file_path) {
          stdout.printf("Processing markdown file: %s\n", file_path);
          // TODO: Implementar a conversão de markdown para HTML
      }
  }
}