From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] ext4: check ext4_journal_get_write_access() errors
Date: Sun, 17 Feb 2008 15:15:20 +0900
Message-ID: <20080217061519.GK3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:21727 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbYBQGVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:21:38 -0500
Received: by rv-out-0910.google.com with SMTP id k20so923429rvb.1
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:21:37 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check ext4_journal_get_write_access() errors.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/namei.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: 2.6-rc/fs/ext4/namei.c
===================================================================
--- 2.6-rc.orig/fs/ext4/namei.c
+++ 2.6-rc/fs/ext4/namei.c
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
