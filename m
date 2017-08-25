From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] ext4: avoid Y2038 overflow in recently_deleted()
Date: Fri, 25 Aug 2017 12:48:35 -0600
Message-ID: <1503686915-57151-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:55707 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754890AbdHYSsi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Aug 2017 14:48:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Avoid a 32-bit time overflow in recently_deleted() since i_dtime
(inode deletion time) is stored only as a 32-bit value on disk.
Since i_dtime isn't used for much beyond a boolean value in e2fsck
and is otherwise only used in this function in the kernel, there is
no benefit to use more space in the inode for this field on disk.

Instead, compare only the relative deletion time with the low
32 bits of the time using the newly-added time_before32() helper,
which is similar to time_before() and time_after() for jiffies.

Increase RECENTCY_DIRTY to 300s based on Ted's comments about
usage experience at Google.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Change-Id: I7402e1b3d49ea326f872ec8324933f42b502b9be
---
 fs/ext4/ialloc.c     | 19 +++++++++++++------
 include/linux/time.h | 15 +++++++++++++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 507bfb3..3e73acb 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -692,16 +692,17 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
  * somewhat arbitrary...)
  */
 #define RECENTCY_MIN	5
-#define RECENTCY_DIRTY	30
+#define RECENTCY_DIRTY	300
 
 static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 {
 	struct ext4_group_desc	*gdp;
 	struct ext4_inode	*raw_inode;
 	struct buffer_head	*bh;
-	unsigned long		dtime, now;
-	int	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
-	int	offset, ret = 0, recentcy = RECENTCY_MIN;
+	int inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
+	int offset, ret = 0;
+	int recentcy = RECENTCY_MIN;
+	u32 dtime, now;
 
 	gdp = ext4_get_group_desc(sb, group, NULL);
 	if (unlikely(!gdp))
@@ -718,12 +719,18 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 
 	offset = (ino % inodes_per_block) * EXT4_INODE_SIZE(sb);
 	raw_inode = (struct ext4_inode *) (bh->b_data + offset);
+
+	/* i_dtime is only 32 bits on disk, but we only care about relative
+	 * times in the range of a few minutes (i.e. long enough to sync a
+	 * recently-deleted inode to disk), so using the low 32 bits of the
+	 * clock (a 68 year range) is enough, see time_before32() */
 	dtime = le32_to_cpu(raw_inode->i_dtime);
-	now = get_seconds();
+	now = ktime_get_real_seconds();
 	if (buffer_dirty(bh))
 		recentcy += RECENTCY_DIRTY;
 
-	if (dtime && (dtime < now) && (now < dtime + recentcy))
+	if (dtime && time_before32(dtime, now) &&
+	    time_before32(now, dtime + recentcy))
 		ret = 1;
 out:
 	brelse(bh);
diff --git a/include/linux/time.h b/include/linux/time.h
index 4abb32d..3877136 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -285,4 +285,19 @@ static inline bool itimerspec64_valid(const struct itimerspec64 *its)
 	return true;
 }
 
+/**
+ * time_after32 - compare two 32-bit relative times
+ * @a:	the time which may be after @b
+ * @b:	the time which may be before @a
+ *
+ * time_after32(a, b) returns true if the time @a is after time @b.
+ * time_before32(b, a) returns true if the time @b is before time @a.
+ *
+ * Similar to time_after(), compare two 32-bit timestamps for relative
+ * times.  This is useful for comparing 32-bit seconds values that can't
+ * be converted to 64-bit values (e.g. due to disk format or wire protocol
+ * issues) when it is known that the times are less than 68 years apart.
+ */
+#define time_after32(a, b)	((s32)((u32)(b) - (u32)(a)) < 0)
+#define time_before32(b, a)	time_after32(a, b)
 #endif
-- 
1.8.0
