From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] mke2fs: do not change root dir ownership
Date: Mon,  6 May 2013 17:21:56 -0400
Message-ID: <1367875316-3089-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48154 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab3EFVV4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 May 2013 17:21:56 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 0EFA333C1EE
	for <linux-ext4@vger.kernel.org>; Mon,  6 May 2013 21:21:55 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you use `mke2fs` on a file, the code will automatically chown the root
dir to the active uid/gid.  It doesn't do this to any other files though.

I can't see where this would really be desirable: you still need root in
order to mount, and the lost+found dir is owned by root.  It means if you
want to generate a rootfs as a non-root user, you first have to run it
through sudo or manually run `chown 0:0` after you've mounted it.

I'm not aware of other tools that do this (in fact, tools tend to do the
opposite thing -- squash the uid/gid to 0/0 so that you can generate the
fs as no-root), so punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
not sure this is worth writing a command line flag for ...

 misc/mke2fs.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ff759d..30767d8 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -383,36 +383,12 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 static void create_root_dir(ext2_filsys fs)
 {
 	errcode_t		retval;
-	struct ext2_inode	inode;
-	__u32			uid, gid;
 
 	retval = ext2fs_mkdir(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, 0);
 	if (retval) {
 		com_err("ext2fs_mkdir", retval, _("while creating root dir"));
 		exit(1);
 	}
-	if (geteuid()) {
-		retval = ext2fs_read_inode(fs, EXT2_ROOT_INO, &inode);
-		if (retval) {
-			com_err("ext2fs_read_inode", retval,
-				_("while reading root inode"));
-			exit(1);
-		}
-		uid = getuid();
-		inode.i_uid = uid;
-		ext2fs_set_i_uid_high(inode, uid >> 16);
-		if (uid) {
-			gid = getgid();
-			inode.i_gid = gid;
-			ext2fs_set_i_gid_high(inode, gid >> 16);
-		}
-		retval = ext2fs_write_new_inode(fs, EXT2_ROOT_INO, &inode);
-		if (retval) {
-			com_err("ext2fs_write_inode", retval,
-				_("while setting root inode ownership"));
-			exit(1);
-		}
-	}
 }
 
 static void create_lost_and_found(ext2_filsys fs)
-- 
1.8.2.1

