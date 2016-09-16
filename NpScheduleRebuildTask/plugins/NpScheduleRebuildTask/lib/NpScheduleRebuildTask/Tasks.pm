package NpScheduleRebuildTask::Tasks;
use strict;
use Data::Dumper;
sub do_task {
  my $plugin = MT->component('NpScheduleRebuildTask');
  require MT::Website;
  my @websites = MT::Website->load();
  foreach my $website (@websites) {
    require MT::Blog;
    my $blog = MT::Blog->load($website->id);
    my $site_path = $blog->site_path;
    my $blog_id = 'blog:' . $website->id;
    my $blog_config_index_template_ids = $plugin->get_config_value('blog_config_index_template_ids', $blog_id) || "";
    my @blog_config_index_template_ids = split(/,/, $blog_config_index_template_ids);
    foreach my $blog_config_index_template_id (@blog_config_index_template_ids){
      next unless $blog_config_index_template_id;
      my $tmpl = MT::Template->load( $blog_config_index_template_id );
      my $file = $tmpl->outfile;
      require File::Spec;
      unless ( File::Spec->file_name_is_absolute($file) ) {
          $file = File::Spec->catfile( $site_path, $file );
      }
      my $fmgr = $blog->file_mgr;
      $fmgr->delete($file);
      MT->rebuild_indexes(
        BlogID   => $website->id,
        Template => $tmpl,
        Force    => 1,
      );
    }
  }
}

sub doLog {
  my ($msg, $class) = @_;
  return unless defined($msg);
  require MT::Log;
  my $log = new MT::Log;
  $log->message($msg);
  $log->level(MT::Log::DEBUG());
  $log->class($class) if $class;
  $log->save or die $log->errstr;
}

1;
