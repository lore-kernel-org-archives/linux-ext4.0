From: Tao Ma <tm@tao.ma>
Subject: [PATCH 4/4 v3] ext4: Speed up FITRIM by recording flags in ext4_group_info.
Date: Fri, 11 Feb 2011 14:29:10 +0800
Message-ID: <1297405750-8011-1-git-send-email-tm@tao.ma>
References: <E9EB058B-97B5-4CF8-951E-48258E1754BD@dilger.ca>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:54558 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751255Ab1BKGaC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Feb 2011 01:30:02 -0500
In-Reply-To: <E9EB058B-97B5-4CF8-951E-48258E1754BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4, when FITRIM is called every time, we iterate all the
groups and do trim one by one. It is a bit time wasting if the
group has been trimmed and there is no change since the last
trim.

So this patch adds a new flag in ext4_group_info->bb_state to
indicate that the group has been trimmed, and it will be cleared
if some blocks is freed(in release_blocks_on_commit). Another
trim_minlen is added in ext4_sb_info to record the last minlen
we use to trim the volume, so that if the caller provide a small
one, we will go on the trim regardless of the bb_state.

A simple test with my intel x25m ssd:
df -h shows:
/dev/sdb2             108G   35G   68G  34% /mnt/ext4
Block size:               4096

run the FITRIM with the following parameter:
range.start = 0;
range.len = UINT64_MAX;
range.minlen = 1048576;

without the patch:
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m4.039s
user	0m0.000s
sys	0m1.020s
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m3.577s
user	0m0.001s
sys	0m1.004s
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m3.380s
user	0m0.000s
sys	0m0.991s

with the patch:
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m3.466s
user	0m0.000s
sys	0m0.966s
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m0.001s
user	0m0.000s
sys	0m0.001s
[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m0.001s
user	0m0.000s
sys	0m0.000s

A big improvement for the 2nd and 3rd run.

Even after I delete some big image files, it is still much
faster than iterating the whole disk.
/dev/sdb2             108G   25G   78G  24% /mnt/ext4

[root@boyu-tm test]# time ./ftrim /mnt/ext4/a
real	0m0.513s
user	0m0.000s
sys	0m0.069s

Cc: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h    |   13 ++++++++++++-
 fs/ext4/mballoc.c |   20 ++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0c8d97b..259887d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1200,6 +1200,9 @@ struct ext4_sb_info {
 	struct ext4_li_request *s_li_request;
 	/* Wait multiplier for lazy initialization thread */
 	unsigned int s_li_wait_mult;
+
+	/* record the last minlen when FITRIM is called. */
+	u64 s_last_trim_minblks;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1970,11 +1973,19 @@ struct ext4_group_info {
 					 * 5 free 8-block regions. */
 };
 
-#define EXT4_GROUP_INFO_NEED_INIT_BIT	0
+#define EXT4_GROUP_INFO_NEED_INIT_BIT		0
+#define EXT4_GROUP_INFO_WAS_TRIMMED_BIT		1
 
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
 
+#define EXT4_MB_GRP_WAS_TRIMMED(grp)	\
+	(test_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
+#define EXT4_MB_GRP_SET_TRIMMED(grp)	\
+	(set_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
+#define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
+	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
+
 #define EXT4_MAX_CONTENTION		8
 #define EXT4_CONTENTION_THRESHOLD	2
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4eadac8..f1eef35 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2687,6 +2687,15 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		rb_erase(&entry->node, &(db->bb_free_root));
 		mb_free_blocks(NULL, &e4b, entry->start_blk, entry->count);
 
+		/*
+		 * Clear the trimmed flag for the group so that the next
+		 * ext4_trim_fs can trim it.
+		 * If the volume is mounted with -o discard, online discard
+		 * is supported and the free blocks will be trimmed online.
+		 */
+		if (!test_opt(sb, DISCARD))
+			EXT4_MB_GRP_CLEAR_TRIMMED(db);
+
 		if (!db->bb_free_root.rb_node) {
 			/* No more items in the per group rb tree
 			 * balance refcounts from ext4_mb_free_metadata()
@@ -4772,6 +4781,10 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 
 	ext4_lock_group(sb, group);
 
+	if (EXT4_MB_GRP_WAS_TRIMMED(e4b->bd_info) &&
+	    minblocks >= EXT4_SB(sb)->s_last_trim_minblks)
+		goto out;
+
 	trace_ext4_trim_all_free(sb, group, start, max);
 
 	while (start < max) {
@@ -4804,6 +4817,10 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 		if ((e4b->bd_info->bb_free - free_count) < minblocks)
 			break;
 	}
+
+	if (!ret)
+		EXT4_MB_GRP_SET_TRIMMED(e4b->bd_info);
+out:
 	ext4_unlock_group(sb, group);
 
 	ext4_debug("trimmed %d blocks in the group %d\n",
@@ -4892,6 +4909,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	}
 	range->len = trimmed * sb->s_blocksize;
 
+	if (!ret)
+		EXT4_SB(sb)->s_last_trim_minblks = minlen;
+
 out:
 	return ret;
 }
-- 
1.6.3.GIT

