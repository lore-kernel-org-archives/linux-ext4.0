From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v2 4/4] ext4: Make cache hits/misses per-cpu counts
Date: Fri,  8 Apr 2016 12:16:22 -0400
Message-ID: <1460132182-11690-5-git-send-email-Waiman.Long@hpe.com>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch changes the es_stats_cache_hits and es_stats_cache_misses
statistics counts to per-cpu variables to reduce cacheline contention
issues whem multiple threads are trying to update those counts
simultaneously. It uses the new per-cpu stats APIs provided by the
percpu_stats.h header file.

With a 38-threads fio I/O test with 2 shared files (on DAX-mount
NVDIMM) running on a 4-socket Haswell-EX server with 4.6-rc1 kernel,
the aggregated bandwidths before and after the patch were:

  Test          W/O patch       With patch      % change
  ----          ---------       ----------      --------
  Read-only     10173MB/s       16141MB/s        +58.7%
  Read-write     2830MB/s        4315MB/s        +52.5%

Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
---
 fs/ext4/extents_status.c |   22 +++++++++++++---------
 fs/ext4/extents_status.h |   11 +++++++++--
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e38b987..bfa8d63 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -825,9 +825,9 @@ out:
 		es->es_pblk = es1->es_pblk;
 		if (!ext4_es_is_referenced(es1))
 			ext4_es_set_referenced(es1);
-		stats->es_stats_cache_hits++;
+		percpu_stats_inc(&stats->es_stats, es_stats_cache_hits);
 	} else {
-		stats->es_stats_cache_misses++;
+		percpu_stats_inc(&stats->es_stats, es_stats_cache_misses);
 	}
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
@@ -1113,9 +1113,9 @@ int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
 		   percpu_counter_sum_positive(&es_stats->es_stats_all_cnt),
 		   percpu_counter_sum_positive(&es_stats->es_stats_shk_cnt));
-	seq_printf(seq, "  %lu/%lu cache hits/misses\n",
-		   es_stats->es_stats_cache_hits,
-		   es_stats->es_stats_cache_misses);
+	seq_printf(seq, "  %llu/%llu cache hits/misses\n",
+		   percpu_stats_sum(&es_stats->es_stats, es_stats_cache_hits),
+		   percpu_stats_sum(&es_stats->es_stats, es_stats_cache_misses));
 	if (inode_cnt)
 		seq_printf(seq, "  %d inodes on list\n", inode_cnt);
 
@@ -1142,8 +1142,6 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	sbi->s_es_nr_inode = 0;
 	spin_lock_init(&sbi->s_es_lock);
 	sbi->s_es_stats.es_stats_shrunk = 0;
-	sbi->s_es_stats.es_stats_cache_hits = 0;
-	sbi->s_es_stats.es_stats_cache_misses = 0;
 	sbi->s_es_stats.es_stats_scan_time = 0;
 	sbi->s_es_stats.es_stats_max_scan_time = 0;
 	err = percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0, GFP_KERNEL);
@@ -1153,15 +1151,20 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	if (err)
 		goto err1;
 
+	err = percpu_stats_init(&sbi->s_es_stats.es_stats, es_stats_cnt, 0);
+	if (err)
+		goto err2;
+
 	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
 	sbi->s_es_shrinker.count_objects = ext4_es_count;
 	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
 	err = register_shrinker(&sbi->s_es_shrinker);
 	if (err)
-		goto err2;
+		goto err3;
 
 	return 0;
-
+err3:
+	percpu_stats_destroy(&sbi->s_es_stats.es_stats);
 err2:
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
 err1:
@@ -1173,6 +1176,7 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 {
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
+	percpu_stats_destroy(&sbi->s_es_stats.es_stats);
 	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f7aa24f..c163189 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -11,6 +11,8 @@
 #ifndef _EXT4_EXTENTS_STATUS_H
 #define _EXT4_EXTENTS_STATUS_H
 
+#include <linux/percpu_stats.h>
+
 /*
  * Turn on ES_DEBUG__ to get lots of info about extent status operations.
  */
@@ -67,10 +69,15 @@ struct ext4_es_tree {
 	struct extent_status *cache_es;	/* recently accessed extent */
 };
 
+enum ext4_es_stat_type {
+	es_stats_cache_hits,
+	es_stats_cache_misses,
+	es_stats_cnt,
+};
+
 struct ext4_es_stats {
 	unsigned long es_stats_shrunk;
-	unsigned long es_stats_cache_hits;
-	unsigned long es_stats_cache_misses;
+	struct percpu_stats es_stats;
 	u64 es_stats_scan_time;
 	u64 es_stats_max_scan_time;
 	struct percpu_counter es_stats_all_cnt;
-- 
1.7.1
