From: Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: [PATCH] ext4: ext4_free_blocks() fix
Date: Fri, 10 Jun 2011 14:07:54 +0400
Message-ID: <1307700474-25743-1-git-send-email-maxim.patlasov@gmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:35693 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab1FJKIF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jun 2011 06:08:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Existent implementation of ext4_free_blocks() always calls vfs_dq_free_block
This looks quite sensible in the most cases: blocks to be freed are associated
with inode and were accounted in quota and i_blocks some time ago.

However, there is a case when blocks to free were not accounted by the time
calling ext4_free_blocks() yet:

1. delalloc is on, write_begin pre-allocated some space in quota
2. write-back happens, ext4 allocates some blocks in ext4_ext_get_blocks()
3. then ext4_ext_get_blocks() gets an error (e.g.  ENOSPC) from
   ext4_ext_insert_extent() and calls ext4_free_blocks().

In this scenario, ext4_free_blocks() calls vfs_dq_free_block() who, in turn,
decrements i_blocks for blocks which were not accounted yet (due to delalloc)
After clean umount, e2fsck reports something like:

> Inode 21, i_blocks is 5080, should be 5128.  Fix<y>?
because i_blocks was erroneously decremented as explained above.

The patch fixes the problem by passing EXT4_FREE_BLOCKS_SKIP_QUPD flag to
ext4_free_blocks(). This flag forces ext4_free_blocks() to skip
vfs_dq_free_block() call.

Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |    4 +++-
 fs/ext4/mballoc.c |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..2cff50c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -526,6 +526,7 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_METADATA	0x0001
 #define EXT4_FREE_BLOCKS_FORGET		0x0002
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
+#define EXT4_FREE_BLOCKS_SKIP_QUPD	0x0008
 
 /*
  * ioctl commands
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..4d17497 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3601,12 +3601,14 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
+		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
+			EXT4_FREE_BLOCKS_SKIP_QUPD : 0;
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
 		 * but otherwise we'd need to call it every free() */
 		ext4_discard_preallocations(inode);
 		ext4_free_blocks(handle, inode, NULL, ext4_ext_pblock(&newex),
-				 ext4_ext_get_actual_len(&newex), 0);
+				 ext4_ext_get_actual_len(&newex), fb_flags);
 		goto out2;
 	}
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 859f2ae..ba391c6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4637,7 +4637,7 @@ do_more:
 	}
 	ext4_mark_super_dirty(sb);
 error_return:
-	if (freed)
+	if (freed && !(flags & EXT4_FREE_BLOCKS_SKIP_QUPD))
 		dquot_free_block(inode, freed);
 	brelse(bitmap_bh);
 	ext4_std_error(sb, err);
-- 
1.7.4.4

