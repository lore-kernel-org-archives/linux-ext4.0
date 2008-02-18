From: akpm@linux-foundation.org
Subject: + ext3-check-ext3_journal_get_write_access-errors.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:16:53 -0800
Message-ID: <200802181017.m1IAHpiG019847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: check ext3_journal_get_write_access() errors
has been added to the -mm tree.  Its filename is
     ext3-check-ext3_journal_get_write_access-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: check ext3_journal_get_write_access() errors
From: Akinobu Mita <akinobu.mita@gmail.com>

Check ext3_journal_get_write_access() errors.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/ext3/namei.c~ext3-check-ext3_journal_get_write_access-errors fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-check-ext3_journal_get_write_access-errors
+++ a/fs/ext3/namei.c
@@ -57,10 +57,15 @@ static struct buffer_head *ext3_append(h
 
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
-	if ((bh = ext3_bread(handle, inode, *block, 1, err))) {
+	bh = ext3_bread(handle, inode, *block, 1, err);
+	if (bh) {
 		inode->i_size += inode->i_sb->s_blocksize;
 		EXT3_I(inode)->i_disksize = inode->i_size;
-		ext3_journal_get_write_access(handle,bh);
+		*err = ext3_journal_get_write_access(handle, bh);
+		if (*err) {
+			brelse(bh);
+			bh = NULL;
+		}
 	}
 	return bh;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-dvb.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
ext4-use-ext4_group_first_block_no.patch
ext4-add-missing-ext4_journal_stop.patch
ext4-use-ext4_get_group_desc.patch
ext4-check-ext4_journal_get_write_access-errors.patch
