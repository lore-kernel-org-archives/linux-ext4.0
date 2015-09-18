From: Albino B Neto <bino@riseup.net>
Subject: [PATCH] Fix style and return NULL
Date: Fri, 18 Sep 2015 19:01:02 -0300
Message-ID: <1442613662-5100-1-git-send-email-bino@riseup.net>
References: <tytso@mit.edu>
Cc: Albino B Neto <bino@riseup.net>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:59645 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbbIRWCK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 18:02:10 -0400
In-Reply-To: <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Line "if (!ext4_has_metadata_csum(sb))".

Second patch and sorry error.

  Albino

Signed-off-by: Albino B Neto <bino@riseup.net>
---
 fs/ext4/mmp.c | 98 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 6eb1a61..d30c945 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,18 +7,21 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb,
+			    struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
 	__u32 csum;
 
-	csum = ext4_chksum(sbi, sbi->s_csum_seed, (char *)mmp, offset);
+	csum = ext4_chksum(sbi, sbi->s_csum_seed,
+			   (char *)mmp, offset);
 
 	return cpu_to_le32(csum);
 }
 
-static int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
+static int ext4_mmp_csum_verify(struct super_block *sb, 
+				struct mmp_struct *mmp)
 {
 	if (!ext4_has_metadata_csum(sb))
 		return 1;
@@ -26,10 +29,11 @@ static int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
 	return mmp->mmp_checksum == ext4_mmp_csum(sb, mmp);
 }
 
-static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
+static void ext4_mmp_csum_set(struct super_block *sb,
+			      struct mmp_struct *mmp)
 {
 	if (!ext4_has_metadata_csum(sb))
-		return;
+		return NULL;
 
 	mmp->mmp_checksum = ext4_mmp_csum(sb, mmp);
 }
@@ -38,13 +42,14 @@ static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
  * Write the MMP block using WRITE_SYNC to try to get the block on-disk
  * faster.
  */
-static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
+static int write_mmp_block(struct super_block *sb,
+			   struct buffer_head *bh)
 {
 	struct mmp_struct *mmp = (struct mmp_struct *)(bh->b_data);
 
 	/*
-	 * We protect against freezing so that we don't create dirty buffers
-	 * on frozen filesystem.
+	 * We protect against freezing so that we don't create dirty 
+	 * buffers on frozen filesystem.
 	 */
 	sb_start_write(sb);
 	ext4_mmp_csum_set(sb, mmp);
@@ -74,9 +79,11 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	if (*bh)
 		clear_buffer_uptodate(*bh);
 
-	/* This would be sb_bread(sb, mmp_block), except we need to be sure
-	 * that the MD RAID device cache has been bypassed, and that the read
-	 * is not blocked in the elevator. */
+	/* 
+	 * This would be sb_bread(sb, mmp_block), except we need to be sure
+	 * that the MD RAID device cache has been bypassed, and that 
+	 * the read is not blocked in the elevator. 
+	*/
 	if (!*bh) {
 		*bh = sb_getblk(sb, mmp_block);
 		if (!*bh) {
@@ -113,11 +120,13 @@ warn_exit:
  * Dump as much information as possible to help the admin.
  */
 void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
-		    const char *function, unsigned int line, const char *msg)
+		    const char *function, unsigned int line, 
+							const char *msg)
 {
 	__ext4_warning(sb, function, line, "%s", msg);
 	__ext4_warning(sb, function, line,
-		       "MMP failure info: last update time: %llu, last update "
+		       "MMP failure info: last update time: %llu, 
+		       last update " 
 		       "node: %s, last update device: %s\n",
 		       (long long unsigned int) le64_to_cpu(mmp->mmp_time),
 		       mmp->mmp_nodename, mmp->mmp_bdevname);
@@ -148,8 +157,8 @@ static int kmmpd(void *data)
 	 * Start with the higher mmp_check_interval and reduce it if
 	 * the MMP block is being updated on time.
 	 */
-	mmp_check_interval = max(EXT4_MMP_CHECK_MULT * mmp_update_interval,
-				 EXT4_MMP_MIN_CHECK_INTERVAL);
+	mmp_check_interval = max(EXT4_MMP_CHECK_MULT * 
+			mmp_update_interval, EXT4_MMP_MIN_CHECK_INTERVAL);
 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
 
@@ -171,34 +180,38 @@ static int kmmpd(void *data)
 		 */
 		if (retval) {
 			if ((failed_writes % 60) == 0)
-				ext4_error(sb, "Error writing to MMP block");
+				ext4_error(sb, "Error writing 
+						to MMP block");
 			failed_writes++;
 		}
 
 		if (!(le32_to_cpu(es->s_feature_incompat) &
 		    EXT4_FEATURE_INCOMPAT_MMP)) {
-			ext4_warning(sb, "kmmpd being stopped since MMP feature"
-				     " has been disabled.");
+			ext4_warning(sb, "kmmpd being stopped 
+						since MMP feature"
+						" has been disabled.");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
 
 		if (sb->s_flags & MS_RDONLY) {
-			ext4_warning(sb, "kmmpd being stopped since filesystem "
-				     "has been remounted as readonly.");
+			ext4_warning(sb, "kmmpd being stopped 
+					since filesystem "
+				"has been remounted as readonly.");
 			EXT4_SB(sb)->s_mmp_tsk = NULL;
 			goto failed;
 		}
 
 		diff = jiffies - last_update_time;
 		if (diff < mmp_update_interval * HZ)
-			schedule_timeout_interruptible(mmp_update_interval *
-						       HZ - diff);
+			schedule_timeout_interruptible
+				(mmp_update_interval * HZ - diff);
 
 		/*
 		 * We need to make sure that more than mmp_check_interval
-		 * seconds have not passed since writing. If that has happened
-		 * we need to check if the MMP block is as we left it.
+		 * seconds have not passed since writing. If that has 
+		 * happened we need to check if the MMP block is as 
+		 * we left it.
 		 */
 		diff = jiffies - last_update_time;
 		if (diff > mmp_check_interval * HZ) {
@@ -214,13 +227,17 @@ static int kmmpd(void *data)
 				goto failed;
 			}
 
-			mmp_check = (struct mmp_struct *)(bh_check->b_data);
+			mmp_check = (struct mmp_struct *)
+					(bh_check->b_data);
 			if (mmp->mmp_seq != mmp_check->mmp_seq ||
-			    memcmp(mmp->mmp_nodename, mmp_check->mmp_nodename,
+			    memcmp(mmp->mmp_nodename, 
+						mmp_check->mmp_nodename,
 				   sizeof(mmp->mmp_nodename))) {
 				dump_mmp_msg(sb, mmp_check,
-					     "Error while updating MMP info. "
-					     "The filesystem seems to have been"
+					     "Error while updating 
+							  MMP info. "
+					     "The filesystem seems 
+					                to have been"
 					     " multiply mounted.");
 				ext4_error(sb, "abort");
 				goto failed;
@@ -229,11 +246,11 @@ static int kmmpd(void *data)
 		}
 
 		 /*
-		 * Adjust the mmp_check_interval depending on how much time
-		 * it took for the MMP block to be written.
+		 * Adjust the mmp_check_interval depending on how much 
+		 * time it took for the MMP block to be written.
 		 */
-		mmp_check_interval = max(min(EXT4_MMP_CHECK_MULT * diff / HZ,
-					     EXT4_MMP_MAX_CHECK_INTERVAL),
+		mmp_check_interval = max(min(EXT4_MMP_CHECK_MULT * 
+				diff / HZ, EXT4_MMP_MAX_CHECK_INTERVAL),
 					 EXT4_MMP_MIN_CHECK_INTERVAL);
 		mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
 	}
@@ -278,7 +295,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	struct mmp_struct *mmp = NULL;
 	struct mmpd_data *mmpd_data;
 	u32 seq;
-	unsigned int mmp_check_interval = le16_to_cpu(es->s_mmp_update_interval);
+	unsigned int mmp_check_interval = le16_to_cpu
+				(es->s_mmp_update_interval);
 	unsigned int wait_time = 0;
 	int retval;
 
@@ -309,7 +327,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		goto skip;
 
 	if (seq == EXT4_MMP_SEQ_FSCK) {
-		dump_mmp_msg(sb, mmp, "fsck is running on the filesystem");
+		dump_mmp_msg(sb, mmp, "fsck is running 
+					on the filesystem");
 		goto failed;
 	}
 
@@ -318,11 +337,13 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	/* Print MMP interval if more than 20 secs. */
 	if (wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4)
-		ext4_warning(sb, "MMP interval %u higher than expected, please"
-			     " wait.\n", wait_time * 2);
+		ext4_warning(sb, "MMP interval %u higher than
+						expected, please"
+					" wait.\n", wait_time * 2);
 
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
+		ext4_warning(sb, "MMP startup interrupted, 
+						failing mount\n");
 		goto failed;
 	}
 
@@ -351,7 +372,8 @@ skip:
 	 * wait for MMP interval and check mmp_seq.
 	 */
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
-		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
+		ext4_warning(sb, "MMP startup interrupted, 
+						failing mount\n");
 		goto failed;
 	}
 
-- 
2.1.4

