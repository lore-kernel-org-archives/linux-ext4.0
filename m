From: akpm@linux-foundation.org
Subject: [patch 273/307] ext3: check ext3_journal_get_write_access() errors
Date: Mon, 28 Apr 2008 02:16:08 -0700
Message-ID: <200804280916.m3S9G8of019145@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759006AbYD1JUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
