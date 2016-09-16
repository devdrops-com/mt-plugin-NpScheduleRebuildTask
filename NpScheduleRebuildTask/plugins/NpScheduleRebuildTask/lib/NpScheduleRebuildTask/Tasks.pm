package NpScheduleRebuildTask::Tasks;
use strict;
use Data::Dumper;
sub do_task {
doLog("do_task");
  my $plugin = MT->component('NpScheduleRebuildTask');
  require MT::Website;
  my @websites = MT::Website->load();
  foreach my $website (@websites) {
doLog(Dumper($plugin));
doLog("website_id => " . $website->id);
    # my $blog_config_index_template_ids = $plugin->get_config_value('blog_config_index_template_ids', "blog:$website->id") || "";
    my $blog_id = 'blog:' . $website->id;
    my $blog_config_index_template_ids = $plugin->get_config_value('blog_config_index_template_ids', $blog_id) || "";
doLog("blog_config_index_template_ids => " . $blog_config_index_template_ids);
#     my $word_sys = $plugin->get_config_value('blog_config_index_template_ids', 'system');
# doLog("word_sys => " . $word_sys);
# MT->rebuild_indexes(
#   BlogID   => $website->id,
#   Template => MT::Template->load( 35 ),
#   Force    => 1,
# );
    my @blog_config_index_template_ids = split(/,/, $blog_config_index_template_ids);
  foreach my $blog_config_index_template_id (@blog_config_index_template_ids){
doLog("blog_config_index_template_id => " . $blog_config_index_template_id);
      next unless $blog_config_index_template_id;
    MT->rebuild_indexes(
        BlogID   => $website->id,
        # Template => MT::Template->load( $blog_config_index_template_id ),
        # Force    => 1,
    );
  }
}
#   require MT::Blog;
#   my @blogs = MT::Blog->load();
#   foreach my $blog (@blogs) {
#     my @blog_config_index_template_ids = split(/,/, $plugin->get_config_value('blog_config_index_template_ids', $blog->id));
#     foreach my $blog_config_index_template_id (@blog_config_index_template_ids){
# doLog("blog_config_index_template_id => " . $blog_config_index_template_id);
#       next unless $blog_config_index_template_id;
#       MT->rebuild_indexes(
#         BlogID   => $blog->id,
#         Template => MT::Template->load( $blog_config_index_template_id ),
#         Force    => 1,
#       );
#     }
#   }
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
