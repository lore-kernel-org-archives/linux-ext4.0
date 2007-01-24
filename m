From: akpm@osdl.org
Subject: + return-enoent-from-ext3_link-when-racing-with-unlink.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:50:40 -0800
Message-ID: <200701240350.l0O3oeXk007673@shell0.pdx.osdl.net>
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXAXDus (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jan 2007 22:50:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     return ENOENT from ext3_link when racing with unlink
has been added to the -mm tree.  Its filename is
     return-enoent-from-ext3_link-when-racing-with-unlink.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: return ENOENT from ext3_link when racing with unlink
From: Eric Sandeen <sandeen@redhat.com>

Return -ENOENT from ext[34]_link if we've raced with unlink and i_nlink is
0.  Doing otherwise has the potential to corrupt the orphan inode list,
because we'd wind up with an inode with a non-zero link count on the list,
and it will never get properly cleaned up & removed from the orphan list
before it is freed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/namei.c |    2 ++
 fs/ext4/namei.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink fs/ext3/namei.c
--- a/fs/ext3/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink
+++ a/fs/ext3/namei.c
@@ -2191,6 +2191,8 @@ static int ext3_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT3_LINK_MAX)
 		return -EMLINK;
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
diff -puN fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink fs/ext4/namei.c
--- a/fs/ext4/namei.c~return-enoent-from-ext3_link-when-racing-with-unlink
+++ a/fs/ext4/namei.c
@@ -2189,6 +2189,8 @@ static int ext4_link (struct dentry * ol
 
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
+	if (inode->i_nlink == 0)
+		return -ENOENT;
 
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
_

Patches currently in -mm which might be from sandeen@redhat.com are

ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
return-enoent-from-ext3_link-when-racing-with-unlink.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
