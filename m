From: Waiman Long <Waiman.Long@hpe.com>
Subject: [PATCH v3 2/2] ext4: Make cache hits/misses per-cpu counts
Date: Tue, 12 Apr 2016 14:12:55 -0400
Message-ID: <1460484775-33359-3-git-send-email-Waiman.Long@hpe.com>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>,
	Waiman Long <Waiman.Long@hpe.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t4625.austin.hp.com ([15.73.212.76]:50496 "EHLO
	g2t4625.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749AbcDLSNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2016 14:13:20 -0400
Received: from g2t4620.austin.hp.com (g2t4620.austin.hp.com [15.73.212.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t4625.austin.hp.com (Postfix) with ESMTPS id 708E22B45
	for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2016 18:13:19 +0000 (UTC)
In-Reply-To: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
 fs/ext4/extents_status.c |   38 +++++++++++++++++++++++++++++---------
 fs/ext4/extents_status.h |    4 ++--
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e38b987..92ca56d 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -770,6 +770,15 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 }
 
 /*
+ * For pure statistics count, use a large batch size to make sure that
+ * it does percpu update as much as possible.
+ */
+static inline void ext4_es_stats_inc(struct percpu_counter *fbc)
+{
+	__percpu_counter_add(fbc, 1, (1 << 30));
+}
+
+/*
  * ext4_es_lookup_extent() looks up an extent in extent status tree.
  *
  * ext4_es_lookup_extent is called by ext4_map_blocks/ext4_da_map_blocks.
@@ -825,9 +834,9 @@ out:
 		es->es_pblk = es1->es_pblk;
 		if (!ext4_es_is_referenced(es1))
 			ext4_es_set_referenced(es1);
-		stats->es_stats_cache_hits++;
+		ext4_es_stats_inc(&stats->es_stats_cache_hits);
 	} else {
-		stats->es_stats_cache_misses++;
+		ext4_es_stats_inc(&stats->es_stats_cache_misses);
 	}
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
@@ -1113,9 +1122,9 @@ int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
 		   percpu_counter_sum_positive(&es_stats->es_stats_all_cnt),
 		   percpu_counter_sum_positive(&es_stats->es_stats_shk_cnt));
-	seq_printf(seq, "  %lu/%lu cache hits/misses\n",
-		   es_stats->es_stats_cache_hits,
-		   es_stats->es_stats_cache_misses);
+	seq_printf(seq, "  %lld/%lld cache hits/misses\n",
+		   percpu_counter_sum_positive(&es_stats->es_stats_cache_hits),
+		   percpu_counter_sum_positive(&es_stats->es_stats_cache_misses));
 	if (inode_cnt)
 		seq_printf(seq, "  %d inodes on list\n", inode_cnt);
 
@@ -1142,8 +1151,6 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	sbi->s_es_nr_inode = 0;
 	spin_lock_init(&sbi->s_es_lock);
 	sbi->s_es_stats.es_stats_shrunk = 0;
-	sbi->s_es_stats.es_stats_cache_hits = 0;
-	sbi->s_es_stats.es_stats_cache_misses = 0;
 	sbi->s_es_stats.es_stats_scan_time = 0;
 	sbi->s_es_stats.es_stats_max_scan_time = 0;
 	err = percpu_counter_init(&sbi->s_es_stats.es_stats_all_cnt, 0, GFP_KERNEL);
@@ -1153,15 +1160,26 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	if (err)
 		goto err1;
 
+	err = percpu_counter_init(&sbi->s_es_stats.es_stats_cache_hits, 0, GFP_KERNEL);
+	if (err)
+		goto err2;
+
+	err = percpu_counter_init(&sbi->s_es_stats.es_stats_cache_misses, 0, GFP_KERNEL);
+	if (err)
+		goto err3;
+
 	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
 	sbi->s_es_shrinker.count_objects = ext4_es_count;
 	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
 	err = register_shrinker(&sbi->s_es_shrinker);
 	if (err)
-		goto err2;
+		goto err4;
 
 	return 0;
-
+err4:
+	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
+err3:
+	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_hits);
 err2:
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
 err1:
@@ -1173,6 +1191,8 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 {
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
+	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_hits);
+	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	unregister_shrinker(&sbi->s_es_shrinker);
 }
 
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index f7aa24f..d537868 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -69,10 +69,10 @@ struct ext4_es_tree {
 
 struct ext4_es_stats {
 	unsigned long es_stats_shrunk;
-	unsigned long es_stats_cache_hits;
-	unsigned long es_stats_cache_misses;
 	u64 es_stats_scan_time;
 	u64 es_stats_max_scan_time;
+	struct percpu_counter es_stats_cache_hits;
+	struct percpu_counter es_stats_cache_misses;
 	struct percpu_counter es_stats_all_cnt;
 	struct percpu_counter es_stats_shk_cnt;
 };
-- 
1.7.1

