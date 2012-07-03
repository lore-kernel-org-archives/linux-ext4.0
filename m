From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
Date: Tue,  3 Jul 2012 21:10:42 +0200
Message-ID: <1341342642-4156-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360Ab2GCTK5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2012 15:10:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With a minor tweaks regarding minimum extent size to discard and
discarded bytes reporting the FITRIM can be enabled on bigalloc file
system and it works without any problem.

This patch fixes minlen handling and discarded bytes reporting to
take into consideration bigalloc enabled file systems and finally
removes the restriction and allow FITRIM to be used on file system with
bigalloc feature enabled.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ioctl.c   |    7 -------
 fs/ext4/mballoc.c |    5 +++--
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e34deac..9d6e0bc 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -420,13 +420,6 @@ resizefs_out:
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
-		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
-			ext4_msg(sb, KERN_ERR,
-				 "FITRIM not supported with bigalloc");
-			return -EOPNOTSUPP;
-		}
-
 		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1cd6994..c4bd0a6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4984,7 +4984,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	start = range->start >> sb->s_blocksize_bits;
 	end = start + (range->len >> sb->s_blocksize_bits) - 1;
-	minlen = range->minlen >> sb->s_blocksize_bits;
+	minlen = EXT4_NUM_B2C(EXT4_SB(sb),
+			      range->minlen >> sb->s_blocksize_bits);
 
 	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
 	    unlikely(start >= max_blks))
@@ -5044,6 +5045,6 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		atomic_set(&EXT4_SB(sb)->s_last_trim_minblks, minlen);
 
 out:
-	range->len = trimmed * sb->s_blocksize;
+	range->len = EXT4_C2B(EXT4_SB(sb), trimmed) << sb->s_blocksize_bits;
 	return ret;
 }
-- 
1.7.7.6

