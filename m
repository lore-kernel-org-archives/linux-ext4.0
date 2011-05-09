From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 11/30] ext4: snapshot file - permissions
Date: Mon,  9 May 2011 19:41:29 +0300
Message-ID: <1304959308-11122-12-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1EIQno (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:44 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:43 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Enforce snapshot file permissions.
Write, truncate and unlink of snapshot inodes is not allowed.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/file.c  |    7 +++++++
 fs/ext4/inode.c |    7 +++++++
 fs/ext4/namei.c |    8 ++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 60b3b19..f31e58e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -168,6 +168,13 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	struct path path;
 	char buf[64], *cp;
 
+	if (ext4_snapshot_file(inode) &&
+		(filp->f_flags & O_ACCMODE) != O_RDONLY)
+		/*
+		 * allow only read-only access to snapshot files
+		 */
+		return -EPERM;
+
 	if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
 		     !(sb->s_flags & MS_RDONLY))) {
 		sbi->s_mount_flags |= EXT4_MF_MNTDIR_SAMPLED;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3acdbe5..c3af773 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4748,6 +4748,13 @@ void ext4_truncate(struct inode *inode)
 	ext4_lblk_t last_block, max_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 
+	/* prevent truncate of files on snapshot list */
+	if (ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "snapshot (%u) cannot be truncated!\n",
+				inode->i_generation);
+		return;
+	}
+
 	if (!ext4_can_truncate(inode))
 		return;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b70fa13..02ba825 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2213,6 +2213,14 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 			     inode->i_ino, inode->i_nlink);
 		inode->i_nlink = 1;
 	}
+	/* prevent unlink of files on snapshot list */
+	if (inode->i_nlink == 1 &&
+		ext4_snapshot_list(inode)) {
+		snapshot_debug(1, "snapshot (%u) cannot be unlinked!\n",
+				inode->i_generation);
+		retval = -EPERM;
+		goto end_unlink;
+	}
 	retval = ext4_delete_entry(handle, dir, de, bh);
 	if (retval)
 		goto end_unlink;
-- 
1.7.0.4

