From: akpm@linux-foundation.org
Subject: - ext4-check-ext4_journal_get_write_access-errors.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:18 -0800
Message-ID: <200802272217.m1RMHI2I000803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: check ext4_journal_get_write_access() errors
has been removed from the -mm tree.  Its filename was
     ext4-check-ext4_journal_get_write_access-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: check ext4_journal_get_write_access() errors
From: Akinobu Mita <akinobu.mita@gmail.com>

Check ext4_journal_get_write_access() errors.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/namei.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/ext4/namei.c~ext4-check-ext4_journal_get_write_access-errors fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-check-ext4_journal_get_write_access-errors
+++ a/fs/ext4/namei.c
@@ -57,10 +57,15 @@ static struct buffer_head *ext4_append(h
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
-	if ((bh = ext4_bread(handle, inode, *block, 1, err))) {
+	bh = ext4_bread(handle, inode, *block, 1, err);
+	if (bh) {
 		inode->i_size += inode->i_sb->s_blocksize;
 		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_journal_get_write_access(handle,bh);
+		*err = ext4_journal_get_write_access(handle, bh);
+		if (*err) {
+			brelse(bh);
+			bh = NULL;
+		}
 	}
 	return bh;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
