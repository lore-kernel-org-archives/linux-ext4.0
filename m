From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/6] [RFC] ext4: super: extend timestamps to 40 bits
Date: Wed, 20 Jun 2018 17:33:03 +0200
Message-ID: <20180620153322.54221-6-arnd@arndb.de>
References: <20180620153322.54221-1-arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The inode timestamps use 34 bits in ext4, but the various timestamps in
the superblock are limited to 32 bits. If every user accesses these as
'unsigned', then this is good until year 2106, but it seems better to
extend this a bit further in the process of removing the deprecated
get_seconds() function.

This adds another byte for each timestamp in the superblock, making
them long enough to store timestamps beyond what is in the inodes,
which seems good enough here (in ocfs2, they are already 64-bit wide,
which is appropriate for a new layout).

I did not modify e2fsprogs, which obviously needs the same change to
actually interpret future timestamps correctly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/ext4.h  |  9 ++++++++-
 fs/ext4/super.c | 35 ++++++++++++++++++++++++++---------
 fs/ext4/sysfs.c | 18 ++++++++++++++++--
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6b4f4369a08c..cac1464383e4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1294,7 +1294,14 @@ struct ext4_super_block {
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
 	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
 	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set */
-	__le32	s_reserved[98];		/* Padding to the end of the block */
+	__u8	s_wtime_hi;
+	__u8	s_mtime_hi;
+	__u8	s_mkfs_time_hi;
+	__u8	s_lastcheck_hi;
+	__u8	s_first_error_time_hi;
+	__u8	s_last_error_time_hi;
+	__u8	s_pad[2];
+	__le32	s_reserved[96];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0c4c2201b3aa..2063d4e5ed08 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -312,6 +312,20 @@ void ext4_itable_unused_set(struct super_block *sb,
 		bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
 }
 
+static void ext4_update_tstamp(__le32 *lo, __u8 *hi)
+{
+	time64_t now = ktime_get_real_seconds();
+
+	now = clamp_val(now, 0, 0xffffffffffull);
+
+	*lo = cpu_to_le32(lower_32_bits(now));
+	*hi = upper_32_bits(now);
+}
+
+static time64_t ext4_get_tstamp(__le32 *lo, __u8 *hi)
+{
+	return ((time64_t)(*hi) << 32) + le32_to_cpu(*lo);
+}
 
 static void __save_error_info(struct super_block *sb, const char *func,
 			    unsigned int line)
@@ -322,11 +336,12 @@ static void __save_error_info(struct super_block *sb, const char *func,
 	if (bdev_read_only(sb->s_bdev))
 		return;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
-	es->s_last_error_time = cpu_to_le32(get_seconds());
+	ext4_update_tstamp(&es->s_last_error_time, &es->s_last_error_time_hi);
 	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
 	es->s_last_error_line = cpu_to_le32(line);
 	if (!es->s_first_error_time) {
 		es->s_first_error_time = es->s_last_error_time;
+		es->s_first_error_time_hi = es->s_last_error_time_hi;
 		strncpy(es->s_first_error_func, func,
 			sizeof(es->s_first_error_func));
 		es->s_first_error_line = cpu_to_le32(line);
@@ -2163,8 +2178,8 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 			 "warning: maximal mount count reached, "
 			 "running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
-		(le32_to_cpu(es->s_lastcheck) +
-			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
+		 (ext4_get_tstamp(&es->s_lastcheck, &es->s_lastcheck_hi) +
+		  le32_to_cpu(es->s_checkinterval) <= ktime_get_real_seconds()))
 		ext4_msg(sb, KERN_WARNING,
 			 "warning: checktime reached, "
 			 "running e2fsck is recommended");
@@ -2173,7 +2188,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
-	es->s_mtime = cpu_to_le32(get_seconds());
+	ext4_update_tstamp(&es->s_mtime, &es->s_mtime_hi);
 	ext4_update_dynamic_rev(sb);
 	if (sbi->s_journal)
 		ext4_set_feature_journal_needs_recovery(sb);
@@ -2839,8 +2854,9 @@ static void print_daily_error_info(struct timer_list *t)
 		ext4_msg(sb, KERN_NOTICE, "error count since last fsck: %u",
 			 le32_to_cpu(es->s_error_count));
 	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at time %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_first_error_time),
+		printk(KERN_NOTICE "EXT4-fs (%s): initial error at time %llu: %.*s:%d",
+		       sb->s_id,
+		       ext4_get_tstamp(&es->s_first_error_time, &es->s_first_error_time_hi),
 		       (int) sizeof(es->s_first_error_func),
 		       es->s_first_error_func,
 		       le32_to_cpu(es->s_first_error_line));
@@ -2853,8 +2869,9 @@ static void print_daily_error_info(struct timer_list *t)
 		printk(KERN_CONT "\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
-		       sb->s_id, le32_to_cpu(es->s_last_error_time),
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %llu: %.*s:%d",
+		       sb->s_id,
+		       ext4_get_tstamp(&es->s_last_error_time, &es->s_last_error_time_hi),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,
 		       le32_to_cpu(es->s_last_error_line));
@@ -4747,7 +4764,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	 * to complain and force a full file system check.
 	 */
 	if (!(sb->s_flags & SB_RDONLY))
-		es->s_wtime = cpu_to_le32(get_seconds());
+		ext4_update_tstamp(&es->s_wtime, &es->s_wtime_hi);
 	if (sb->s_bdev->bd_part)
 		es->s_kbytes_written =
 			cpu_to_le64(EXT4_SB(sb)->s_kbytes_written +
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index b970a200f20c..fe58aa905cbe 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -25,6 +25,8 @@ typedef enum {
 	attr_reserved_clusters,
 	attr_inode_readahead,
 	attr_trigger_test_error,
+	attr_first_error_time,
+	attr_last_error_time,
 	attr_feature,
 	attr_pointer_ui,
 	attr_pointer_atomic,
@@ -182,8 +184,8 @@ EXT4_RW_ATTR_SBI_UI(warning_ratelimit_burst, s_warning_ratelimit_state.burst);
 EXT4_RW_ATTR_SBI_UI(msg_ratelimit_interval_ms, s_msg_ratelimit_state.interval);
 EXT4_RW_ATTR_SBI_UI(msg_ratelimit_burst, s_msg_ratelimit_state.burst);
 EXT4_RO_ATTR_ES_UI(errors_count, s_error_count);
-EXT4_RO_ATTR_ES_UI(first_error_time, s_first_error_time);
-EXT4_RO_ATTR_ES_UI(last_error_time, s_last_error_time);
+EXT4_ATTR(first_error_time, 0444, first_error_time);
+EXT4_ATTR(last_error_time, 0444, last_error_time);
 
 static unsigned int old_bump_val = 128;
 EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
@@ -249,6 +251,12 @@ static void *calc_ptr(struct ext4_attr *a, struct ext4_sb_info *sbi)
 	return NULL;
 }
 
+static ssize_t print_time(char *buf, __le32 lo, __u8 hi)
+{
+	return snprintf(buf, PAGE_SIZE, "%lld",
+			((time64_t)hi << 32) + le32_to_cpu(lo));
+}
+
 static ssize_t ext4_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
@@ -287,6 +295,12 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 				atomic_read((atomic_t *) ptr));
 	case attr_feature:
 		return snprintf(buf, PAGE_SIZE, "supported\n");
+	case attr_first_error_time:
+		return print_time(buf, sbi->s_es->s_first_error_time,
+				       sbi->s_es->s_first_error_time_hi);
+	case attr_last_error_time:
+		return print_time(buf, sbi->s_es->s_last_error_time,
+				       sbi->s_es->s_last_error_time_hi);
 	}
 
 	return 0;
-- 
2.9.0
