From: Beata Michalska <b.michalska@samsung.com>
Subject: [PATCH v2 2/2] ext4: Add pollable sysfs entry for block threshold
 events
Date: Mon, 16 Mar 2015 14:25:29 +0100
Message-ID: <1426512329-24299-3-git-send-email-b.michalska@samsung.com>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
To: lczerner@redhat.com, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add support for pollable sysfs entry for available
logical blocks threshold, allowing the userspace
to wait for the notification whenever the threshold
is reached instead of periodically calling the statfs.
This is supposed to work as a single-shot notifiaction
to reduce the number of triggered events.

Signed-off-by: Beata Michalska <b.michalska@samsung.com>
---
 Documentation/filesystems/ext4.txt |   11 +++++++
 fs/ext4/balloc.c                   |   28 ++++++++---------
 fs/ext4/ext4.h                     |    5 +++
 fs/ext4/super.c                    |   59 +++++++++++++++++++++++++++++++++++-
 4 files changed, 88 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 6c0108e..54d8f4d 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -446,6 +446,17 @@ Files in /sys/fs/ext4/<devname>
 ..............................................................................
  File                         Content
 
+ available_blks_thres         This RW file represents a threshold of available
+                              logical blocks within the filesystem. Once
+                              enabled, a notification shall be triggered
+                              whenever the number of available blocks drops
+                              below the specified limit, awakening any
+                              process awaiting events (through poll, i.e.)
+                              on this very file. Note, that this works only
+                              as a single-shot notification: once triggered,
+                              the notifications will get disabled, restoring
+                              the threshold to its default value (-1).
+
  delayed_allocation_blocks    This file is read-only and shows the number of
                               blocks that are dirty in the page cache, but
                               which do not have their location in the
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 5e6a9ca..9c1be88 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -519,12 +519,12 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 				  s64 nclusters, unsigned int flags)
 {
-	s64 free_clusters, dirty_clusters, rsv, resv_clusters;
+	s64 free_clusters, dirty_clusters, rsv, resv_clusters, bound_clusters;
 	struct percpu_counter *fcc = &sbi->s_freeclusters_counter;
 	struct percpu_counter *dcc = &sbi->s_dirtyclusters_counter;
 
-	free_clusters  = percpu_counter_read_positive(fcc);
-	dirty_clusters = percpu_counter_read_positive(dcc);
+	free_clusters  = percpu_counter_sum_positive(fcc);
+	dirty_clusters = percpu_counter_sum_positive(dcc);
 	resv_clusters = atomic64_read(&sbi->s_resv_clusters);
 
 	/*
@@ -534,34 +534,34 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	rsv = (ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits) +
 	      resv_clusters;
 
-	if (free_clusters - (nclusters + rsv + dirty_clusters) <
-					EXT4_FREECLUSTERS_WATERMARK) {
-		free_clusters  = percpu_counter_sum_positive(fcc);
-		dirty_clusters = percpu_counter_sum_positive(dcc);
-	}
+	bound_clusters = nclusters + rsv + dirty_clusters;
 	/* Check whether we have space after accounting for current
 	 * dirty clusters & root reserved clusters.
 	 */
-	if (free_clusters >= (rsv + nclusters + dirty_clusters))
-		return 1;
+	if (free_clusters >= bound_clusters)
+		goto done;
 
 	/* Hm, nope.  Are (enough) root reserved clusters available? */
 	if (uid_eq(sbi->s_resuid, current_fsuid()) ||
 	    (!gid_eq(sbi->s_resgid, GLOBAL_ROOT_GID) && in_group_p(sbi->s_resgid)) ||
 	    capable(CAP_SYS_RESOURCE) ||
 	    (flags & EXT4_MB_USE_ROOT_BLOCKS)) {
-
 		if (free_clusters >= (nclusters + dirty_clusters +
 				      resv_clusters))
-			return 1;
+			goto done;
 	}
 	/* No free blocks. Let's see if we can dip into reserved pool */
 	if (flags & EXT4_MB_USE_RESERVED) {
-		if (free_clusters >= (nclusters + dirty_clusters))
-			return 1;
+		if (free_clusters >= (bound_clusters - rsv))
+			goto done;
 	}
 
 	return 0;
+
+done:
+	ext4_available_blks_thres_notify(sbi,
+		EXT4_C2B(sbi, free_clusters - bound_clusters));
+	return 1;
 }
 
 int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e10a94c..84103bc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1309,6 +1309,7 @@ struct ext4_sb_info {
 	unsigned long s_sectors_written_start;
 	u64 s_kbytes_written;
 
+	atomic64_t available_blks_thres;
 	/* the size of zero-out chunk */
 	unsigned int s_extent_max_zeroout_kb;
 
@@ -2207,6 +2208,9 @@ extern int ext4_alloc_flex_bg_array(struct super_block *sb,
 				    ext4_group_t ngroup);
 extern const char *ext4_decode_error(struct super_block *sb, int errno,
 				     char nbuf[16]);
+extern void ext4_verify_available_blks_thres(struct ext4_sb_info *sbi);
+extern void ext4_available_blks_thres_notify(struct ext4_sb_info *sbi,
+				      s64 ablocks);
 
 extern __printf(4, 5)
 void __ext4_error(struct super_block *, const char *, unsigned int,
@@ -2542,6 +2546,7 @@ void ext4_mark_group_corrupted(struct ext4_sb_info *sbi,
 	if (!EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
 		percpu_counter_sub(&sbi->s_freeclusters_counter, grp->bb_free);
 	set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+	ext4_verify_available_blks_thres(sbi);
 }
 
 /*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b4dfba3..ee45ae0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2558,10 +2558,63 @@ static ssize_t reserved_clusters_store(struct ext4_attr *a,
 	if (parse_strtoull(buf, -1ULL, &val))
 		return -EINVAL;
 	ret = ext4_reserve_clusters(sbi, val);
-
+	ext4_verify_available_blks_thres(sbi);
 	return ret ? ret : count;
 }
 
+void ext4_available_blks_thres_notify(struct ext4_sb_info *sbi, s64 ablocks)
+{
+	s64 available_blks_thres = atomic64_read(&sbi->available_blks_thres);
+
+	if (available_blks_thres >= 0 && ablocks <= available_blks_thres) {
+		sysfs_notify(&sbi->s_kobj, NULL, "available_blks_thres");
+		/* Prevent flooding notifications */
+		atomic64_set(&sbi->available_blks_thres, ~0LLU);
+	}
+}
+
+void ext4_verify_available_blks_thres(struct ext4_sb_info *sbi)
+{
+	struct ext4_super_block *es = sbi->s_es;
+	unsigned long long ablocks;
+
+	if (atomic64_read(&sbi->available_blks_thres) < 0)
+		/* No limit set -> no notification needed */
+		return;
+
+	/* Verify the limit has not been reached. If so notify the watchers */
+	ablocks = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
+		 percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
+	ablocks -= (ext4_r_blocks_count(es) +
+		  EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters)));
+	ext4_available_blks_thres_notify(sbi, ablocks);
+}
+
+static ssize_t available_blks_thres_show(struct ext4_attr *a,
+					struct ext4_sb_info *sbi, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lld\n",
+			atomic64_read(&sbi->available_blks_thres));
+
+}
+
+static ssize_t available_blks_thres_store(struct ext4_attr *a,
+					struct ext4_sb_info *sbi,
+					const char *buf, size_t count)
+{
+	struct ext4_super_block *es = sbi->s_es;
+	unsigned long long bcount, val;
+
+	bcount = ext4_blocks_count(es);
+	if (parse_strtoull(buf, bcount, &val))
+		return -EINVAL;
+	if (val != atomic64_read(&sbi->available_blks_thres)) {
+		atomic64_set(&sbi->available_blks_thres, val);
+		ext4_verify_available_blks_thres(sbi);
+	}
+	return count;
+}
+
 static ssize_t trigger_test_error(struct ext4_attr *a,
 				  struct ext4_sb_info *sbi,
 				  const char *buf, size_t count)
@@ -2631,6 +2684,7 @@ EXT4_RO_ATTR(delayed_allocation_blocks);
 EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
 EXT4_RW_ATTR(reserved_clusters);
+EXT4_RW_ATTR(available_blks_thres);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
@@ -2658,6 +2712,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(session_write_kbytes),
 	ATTR_LIST(lifetime_write_kbytes),
 	ATTR_LIST(reserved_clusters),
+	ATTR_LIST(available_blks_thres),
 	ATTR_LIST(inode_readahead_blks),
 	ATTR_LIST(inode_goal),
 	ATTR_LIST(mb_stats),
@@ -4174,6 +4229,8 @@ no_journal:
 		goto failed_mount6;
 	}
 
+	atomic64_set(&sbi->available_blks_thres, ~0LLU);
+
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		if (!ext4_fill_flex_info(sb)) {
 			ext4_msg(sb, KERN_ERR,
-- 
1.7.9.5
