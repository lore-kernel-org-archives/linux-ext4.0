From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] ext3: check ext3_journal_get_write_access() errors
Date: Sun, 17 Feb 2008 15:06:40 +0900
Message-ID: <20080217060639.GG3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:54935 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYBQGM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:12:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2076288wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:12:57 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check ext3_journal_get_write_access() errors.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext3/namei.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: 2.6-rc/fs/ext3/namei.c
===================================================================
--- 2.6-rc.orig/fs/ext3/namei.c
+++ 2.6-rc/fs/ext3/namei.c
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
