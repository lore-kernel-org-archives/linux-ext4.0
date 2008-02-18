From: akpm@linux-foundation.org
Subject: + ext2-use-ext2_fsblk_t-type.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:16:15 -0800
Message-ID: <200802181017.m1IAHDZG019815@imap1.linux-foundation.org>
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930AbYBRKRo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 05:17:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: use ext2_fsblk_t type
has been added to the -mm tree.  Its filename is
     ext2-use-ext2_fsblk_t-type.patch

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
Subject: ext2: use ext2_fsblk_t type
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext2_fsblk_t type for filesystem-wide blocks number

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ext2/inode.c~ext2-use-ext2_fsblk_t-type fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-use-ext2_fsblk_t-type
+++ a/fs/ext2/inode.c
@@ -254,13 +254,13 @@ no_block:
  *	Caller must make sure that @ind is valid and will stay that way.
  */
 
-static unsigned long ext2_find_near(struct inode *inode, Indirect *ind)
+static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	__le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
 	__le32 *p;
-	unsigned long bg_start;
-	unsigned long colour;
+	ext2_fsblk_t bg_start;
+	ext2_fsblk_t colour;
 
 	/* Try to find previous block */
 	for (p = ind->p - 1; p >= start; p--)
@@ -290,8 +290,8 @@ static unsigned long ext2_find_near(stru
  *	Returns preferred place for a block (the goal).
  */
 
-static inline int ext2_find_goal(struct inode *inode, long block,
-				 Indirect *partial)
+static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
+					  Indirect *partial)
 {
 	struct ext2_block_alloc_info *block_i;
 
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
