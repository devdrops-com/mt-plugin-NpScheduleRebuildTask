package NpScheduleRebuildTask::Tasks;
use strict;

sub do_task {
doLog("do_task");
  my ($ctx, $args) = @_;
  my $blog_id = $ctx->stash('blog_id');
doLog("blog_id => " . $blog_id);
  my $plugin = MT->component('NpScheduleRebuildTask');
  my @blog_config_index_template_ids = split(/,/, $plugin->get_config_value('blog_config_index_template_ids', $blog_id));
doLog("$blog_config_index_template_ids => " . $blog_config_index_template_ids);
  foreach my $blog_config_index_template_id (@blog_config_index_template_ids){
    next unless $$blog_config_index_template_id;
    MT->rebuild_indexes(
      BlogID   => $blog_id,
      Template => MT::Template->load( $blog_config_index_template_id ),
      Force    => 1,
    );
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
