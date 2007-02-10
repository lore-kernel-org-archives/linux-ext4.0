From: akpm@linux-foundation.org
Subject: [patch 208/241] return ENOENT from ext3_link when racing with unlink
Date: Sat, 10 Feb 2007 01:46:16 -0800
Message-ID: <200702100946.l1A9kGuT009329@shell0.pdx.osdl.net>
Cc: akpm@linux-foundation.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbXBJJqY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Feb 2007 04:46:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Return -ENOENT from ext[34]_link if we've raced with unlink and i_nlink is
0.  Doing otherwise has the potential to corrupt the orphan inode list,
because we'd wind up with an inode with a non-zero link count on the list,
and it will never get properly cleaned up & removed from the orphan list
before it is freed.

[akpm@osdl.org: build fix]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    6 ++++++
 fs/ext4/namei.c |    6 ++++++
 2 files changed, 12 insertions(+)

diff -puN fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink fs/ext3/namei.c
--- a/fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink
+++ a/fs/ext3/namei.c
@@ -2191,6 +2191,12 @@ static int ext3_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT3_LINK_MAX)
 		return -EMLINK;
+	/*
+	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
+	 * otherwise has the potential to corrupt the orphan inode list.
+	 */
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
diff -puN fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink fs/ext4/namei.c
--- a/fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink
+++ a/fs/ext4/namei.c
@@ -2189,6 +2189,12 @@ static int ext4_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
+	/*
+	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
+	 * otherwise has the potential to corrupt the orphan inode list.
+	 */
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
_
