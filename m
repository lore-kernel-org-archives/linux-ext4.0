From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Create helper function for EXT4_IO_END_UNWRITTEN and i_aiodio_unwritten.
Date: Tue, 16 Aug 2011 15:06:03 +0800
Message-ID: <1313478363-5330-1-git-send-email-tm@tao.ma>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47257 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750869Ab1HPHI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 03:08:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten should
be done simultaneously since ext4_end_io_nolock always clear the flag and
decrease the counter in the same time.

We have found some bugs that the flag is set while leaving i_aiodio_unwritten
unchanged. So this patch just tries to creat a helper function to wrap them
to avoid any future bug. The idea is inspired by Eric.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
Ted,
	This patch is based on the patch with subject "ext4: Resolve the hang
of direct i/o read in handling EXT4_IO_END_UNWRITTEN.". I meant it for the next
merge window, but if you think it is also ok for 3.1, go ahead.

 fs/ext4/ext4.h    |   11 +++++++++++
 fs/ext4/extents.c |   10 ++--------
 fs/ext4/inode.c   |    5 +----
 fs/ext4/page-io.c |    6 ++----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..514f670 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1247,6 +1247,17 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
 
+static inline int ext4_set_io_unwritten_flag(struct inode *inode,
+					     struct ext4_io_end *io_end)
+{
+	if (io_end && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+		return 1;
+	}
+
+	return 0;
+}
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..c0f8655 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3190,10 +3190,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 		 * that this IO needs to conversion to written when IO is
 		 * completed
 		 */
-		if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
-			io->flag = EXT4_IO_END_UNWRITTEN;
-			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
-		} else
+		if (!ext4_set_io_unwritten_flag(inode, io))
 			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		if (ext4_should_dioread_nolock(inode))
 			map->m_flags |= EXT4_MAP_UNINIT;
@@ -3572,10 +3569,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		 * that we need to perform conversion when IO is done.
 		 */
 		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
-			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
-				io->flag = EXT4_IO_END_UNWRITTEN;
-				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
-			} else
+			if (!ext4_set_io_unwritten_flag(inode, io))
 				ext4_set_inode_state(inode,
 						     EXT4_STATE_DIO_UNWRITTEN);
 		}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 40c0b10..128493b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2673,10 +2673,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 	 * but being more careful is always safe for the future change.
 	 */
 	inode = io_end->inode;
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		io_end->flag |= EXT4_IO_END_UNWRITTEN;
-		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
-	}
+	ext4_set_io_unwritten_flag(inode, io_end);
 
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 78839af..edd2f7b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -334,10 +334,8 @@ submit_and_retry:
 	if ((io_end->num_io_pages >= MAX_IO_PAGES) &&
 	    (io_end->pages[io_end->num_io_pages-1] != io_page))
 		goto submit_and_retry;
-	if (buffer_uninit(bh) && !(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		io_end->flag |= EXT4_IO_END_UNWRITTEN;
-		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
-	}
+	if (buffer_uninit(bh))
+		ext4_set_io_unwritten_flag(inode, io_end);
 	io->io_end->size += bh->b_size;
 	io->io_next_block++;
 	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
-- 
1.7.0.4

