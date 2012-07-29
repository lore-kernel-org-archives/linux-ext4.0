From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: add error handling when discard cmd is fail in FITRIM
Date: Sun, 29 Jul 2012 07:31:54 -0400
Message-ID: <1343561514-8380-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Although free extents is proper not trimmed(mmc driver return error code
while sending trim command), currently FITRIM ioctl return success.
Add exception routine to inform user error code.

#> ./fitrim_test
end_request: I/O error, dev mmcblk0, sector 27232
EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857:
Discard command returned error -5
#>

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8eae947..07569b6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4852,10 +4852,11 @@ error_return:
  * one will allocate those blocks, mark it as used in buddy bitmap. This must
  * be called with under the group lock.
  */
-static void ext4_trim_extent(struct super_block *sb, int start, int count,
+static int ext4_trim_extent(struct super_block *sb, int start, int count,
 			     ext4_group_t group, struct ext4_buddy *e4b)
 {
 	struct ext4_free_extent ex;
+	int err;
 
 	trace_ext4_trim_extent(sb, group, start, count);
 
@@ -4871,9 +4872,10 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
 	 */
 	mb_mark_used(e4b, &ex);
 	ext4_unlock_group(sb, group);
-	ext4_issue_discard(sb, group, start, count);
+	err = ext4_issue_discard(sb, group, start, count);
 	ext4_lock_group(sb, group);
 	mb_free_blocks(NULL, e4b, start, ex.fe_len);
+	return err;
 }
 
 /**
@@ -4902,7 +4904,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 	void *bitmap;
 	ext4_grpblk_t next, count = 0, free_count = 0;
 	struct ext4_buddy e4b;
-	int ret;
+	int ret = 0;
 
 	trace_ext4_trim_all_free(sb, group, start, max);
 
@@ -4929,15 +4931,22 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		next = mb_find_next_bit(bitmap, max + 1, start);
 
 		if ((next - start) >= minblocks) {
-			ext4_trim_extent(sb, start,
-					 next - start, group, &e4b);
-			count += next - start;
+			ret = ext4_trim_extent(sb, start,
+						next - start, group, &e4b);
+			if (ret < 0) {
+				if (ret != -EOPNOTSUPP)
+					ext4_warning(sb,
+						"Discard command returned error %d\n",
+						ret);
+					break;
+			} else
+				count += next - start;
 		}
 		free_count += next - start;
 		start = next + 1;
 
 		if (fatal_signal_pending(current)) {
-			count = -ERESTARTSYS;
+			ret = -ERESTARTSYS;
 			break;
 		}
 
@@ -4960,7 +4969,7 @@ out:
 	ext4_debug("trimmed %d blocks in the group %d\n",
 		count, group);
 
-	return count;
+	return (ret < 0) ? ret : count;
 }
 
 /**
-- 
1.7.9.5
