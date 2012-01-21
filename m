From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: add error handling when discarding is fail in FITRIM ioctl
Date: Sat, 21 Jan 2012 02:56:12 -0500
Message-ID: <1327132572-11841-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60275 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2AUH5N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jan 2012 02:57:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Although free extents is proper not trimmed(mmc driver return error code while sending trim command), currently FITRIM ioctl return success.
I tried to add exception routine to inform user error code.

#> ./fitrim_test 
end_request: I/O error, dev mmcblk0, sector 27232
EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857: Discard command returned error -5
#>

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/ext4/mballoc.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb990b2..09cc09a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4901,10 +4901,11 @@ error_return:
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
 
@@ -4920,9 +4921,10 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
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
@@ -4978,15 +4980,21 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		next = mb_find_next_bit(bitmap, max, start);
 
 		if ((next - start) >= minblocks) {
-			ext4_trim_extent(sb, start,
-					 next - start, group, &e4b);
-			count += next - start;
+			ret = ext4_trim_extent(sb, start,
+						next - start, group, &e4b);
+			if (ret < 0) {
+				if (ret != -EOPNOTSUPP)
+					ext4_warning(sb, "Discard command "
+						 "returned error %d\n", ret);
+				break;
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
 
@@ -5009,7 +5017,7 @@ out:
 	ext4_debug("trimmed %d blocks in the group %d\n",
 		count, group);
 
-	return count;
+	return (ret < 0) ? ret : count;
 }
 
 /**
-- 
1.7.5.4

