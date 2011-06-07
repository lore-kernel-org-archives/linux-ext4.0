From: amir73il@users.sourceforge.net
Subject: [PATCH v1 11/36] ext4: snapshot file - permissions
Date: Tue,  7 Jun 2011 18:07:38 +0300
Message-ID: <1307459283-22130-12-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab1FGPJZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:25 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:24 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
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
index f44f7d3..b210b33 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4727,6 +4727,13 @@ void ext4_truncate(struct inode *inode)
 
 	trace_ext4_truncate_enter(inode);
 
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
index 93196b6..41df36f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2225,6 +2225,14 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
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
1.7.4.1

