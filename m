From: akpm@linux-foundation.org
Subject: - ext3-check-ext3_journal_get_write_access-errors.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:41 -0700
Message-ID: <200804282200.m3SM0fKS018732@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965193AbYD1WAn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: check ext3_journal_get_write_access() errors
has been removed from the -mm tree.  Its filename was
     ext3-check-ext3_journal_get_write_access-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

