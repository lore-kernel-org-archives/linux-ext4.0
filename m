From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't check io->flag when setting EXT4_STATE_DIO_UNWRITTEN inode state.
Date: Wed, 14 Sep 2011 15:16:27 +0800
Message-ID: <1315984587-5039-1-git-send-email-tm@tao.ma>
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41695 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750910Ab1INH3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 03:29:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

When we want to convert the unitialized extent in direct write,
we can either do it in ext4_end_io_nolock(AIO case) or in
 ext4_ext_direct_IO(non AIO case) and EXT4_I(inode)->cur_aio_dio
is a guard for ext4_ext_map_blocks to find the right case.
In e9e3bcecf, we mistakenly change it by:
-			if (io)
+			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
 				io->flag = EXT4_IO_END_UNWRITTEN;
-			else
+				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+			} else
 				ext4_set_inode_state(inode,
 						     EXT4_STATE_DIO_UNWRITTEN);

So now if we map 2 blocks, and the first one set the EXT_IO_END_UNWRITTEN, the
2nd mapping will set inode state because of the check for the flag. This is
wrong.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..8db6743 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3190,9 +3190,11 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 		 * that this IO needs to conversion to written when IO is
 		 * completed
 		 */
-		if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
-			io->flag = EXT4_IO_END_UNWRITTEN;
-			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+		if (io) {
+			if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
+				io->flag = EXT4_IO_END_UNWRITTEN;
+				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+			}
 		} else
 			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		if (ext4_should_dioread_nolock(inode))
@@ -3572,9 +3574,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		 * that we need to perform conversion when IO is done.
 		 */
 		if ((flags & EXT4_GET_BLOCKS_PRE_IO)) {
-			if (io && !(io->flag & EXT4_IO_END_UNWRITTEN)) {
-				io->flag = EXT4_IO_END_UNWRITTEN;
-				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+			if (io) {
+				if (!(io->flag & EXT4_IO_END_UNWRITTEN)) {
+					io->flag = EXT4_IO_END_UNWRITTEN;
+					atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+				}
 			} else
 				ext4_set_inode_state(inode,
 						     EXT4_STATE_DIO_UNWRITTEN);
-- 
1.7.4.1

