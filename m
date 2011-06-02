From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3] ext4: use proper little-endian bitops
Date: Fri,  3 Jun 2011 00:52:11 +0900
Message-ID: <1307029931-17236-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46147 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1FBPvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 11:51:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le()
for ext4.  Only two ext4_{set,clear}_bit() calls check the return
value. The rest of calls ignore the return value and they can be
replaced with __{set,clear}_bit_le().

This changes ext4_{set,clear}_bit() from __test_and_{set,clear}_bit_le()
to __{set,clear}_bit_le() and introduces ext4_test_and_{set,clear}_bit()
for the two places where old bit needs to be returned.

This ext4_{set,clear}_bit() change is considered safe, because if someone
uses these macros without noticing the change, new ext4_{set,clear}_bit
don't have return value and causes compiler errors where the return
value is used.

This also removes unused ext4_find_first_zero_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
v3: squash into a single patch and do not remove ext4_*_bit_atomic() macros
v2: rewritten to keep ext4_*_bit() macros

 fs/ext4/ext4.h   |    7 ++++---
 fs/ext4/ialloc.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..cb65177 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -930,12 +930,13 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			__test_and_set_bit_le
+#define ext4_test_and_set_bit		__test_and_set_bit_le
+#define ext4_set_bit			__set_bit_le
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			__test_and_clear_bit_le
+#define ext4_test_and_clear_bit		__test_and_clear_bit_le
+#define ext4_clear_bit			__clear_bit_le
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
 #define ext4_test_bit			test_bit_le
-#define ext4_find_first_zero_bit	find_first_zero_bit_le
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..e3de479 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		fatal = ext4_journal_get_write_access(handle, bh2);
 	}
 	ext4_lock_group(sb, block_group);
-	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
 	if (fatal || !cleared) {
 		ext4_unlock_group(sb, block_group);
 		goto out;
@@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	 */
 	down_read(&grp->alloc_sem);
 	ext4_lock_group(sb, group);
-	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
+	if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
 		retval = 1;
 		goto err_ret;
-- 
1.7.4.4

