From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] ext4: Allow indirect-block file to grow the file size to
 max file size
Date: Fri, 24 Dec 2010 15:17:49 +0900
Message-ID: <4D143B0D.2030302@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49011 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0LXGTj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Dec 2010 01:19:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We can create 4402345721856 byte file with indirect block mapping.
However, if we grow an indirect-block file to the size with ftruncate(),
we can see the ext4 warning. The following patch fixes this problem.

How to reproduce:
# dd if=/dev/zero of=/mnt/mp1/hoge bs=1 count=0 seek=4402345721856
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000221428 s, 0.0 kB/s
# tail -n 1 /var/log/messages
Nov 25 15:10:27 test kernel: EXT4-fs warning (device sda8): ext4_block_to_path:345: block 1074791436 > max in inode 12

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/inode.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 05a0790..c429753 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4677,8 +4677,8 @@ void ext4_truncate(struct inode *inode)
 	Indirect chain[4];
 	Indirect *partial;
 	__le32 nr = 0;
-	int n;
-	ext4_lblk_t last_block;
+	int n = 0;
+	ext4_lblk_t last_block, max_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 
 	if (!ext4_can_truncate(inode))
@@ -4700,14 +4700,18 @@ void ext4_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + blocksize-1)
 					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
+	max_block = (EXT4_SB(inode->i_sb)->s_bitmap_maxbytes + blocksize-1)
+					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
 
 	if (inode->i_size & (blocksize - 1))
 		if (ext4_block_truncate_page(handle, mapping, inode->i_size))
 			goto out_stop;
 
-	n = ext4_block_to_path(inode, last_block, offsets, NULL);
-	if (n == 0)
-		goto out_stop;	/* error */
+	if (last_block != max_block) {
+		n = ext4_block_to_path(inode, last_block, offsets, NULL);
+		if (n == 0)
+			goto out_stop;	/* error */
+	}
 
 	/*
 	 * OK.  This truncate is going to happen.  We add the inode to the
@@ -4738,7 +4742,13 @@ void ext4_truncate(struct inode *inode)
 	 */
 	ei->i_disksize = inode->i_size;
 
-	if (n == 1) {		/* direct blocks */
+	if (last_block == max_block) {
+		/*
+		 * It is unnecessary to free any data blocks if last_block is
+		 * equal to the indirect block limit.
+		 */
+		goto out_unlock;
+	} else if (n == 1) {		/* direct blocks */
 		ext4_free_data(handle, inode, NULL, i_data+offsets[0],
 			       i_data + EXT4_NDIR_BLOCKS);
 		goto do_indirects;
@@ -4798,6 +4808,7 @@ do_indirects:
 		;
 	}
 
+out_unlock:
 	up_write(&ei->i_data_sem);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
