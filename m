From: akpm@linux-foundation.org
Subject: - return-enoent-from-ext3_link-when-racing-with-unlink.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:25 -0800
Message-ID: <200702112254.l1BMsPPk016222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     return ENOENT from ext3_link when racing with unlink
has been removed from the -mm tree.  Its filename was
     return-enoent-from-ext3_link-when-racing-with-unlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: return ENOENT from ext3_link when racing with unlink
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

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
