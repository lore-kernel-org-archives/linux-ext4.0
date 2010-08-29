From: Andreas Rid <andreas@rid-net.de>
Subject: [patch] ext4 defrag executables
Date: Sun, 29 Aug 2010 21:47:47 +0200
Message-ID: <4C7AB963.6030401@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:58481 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0H2Trk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Aug 2010 15:47:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

since ioctl EXT4_IOC_MOVE_EXT checks the original file descriptor for write access it's no longer possible to defrag executable files which are currently in use. This is because you can only open() those files readonly.
This patch solves it without adding a security hole. 
What do you think about it?

 Andreas


diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 352cb35..ae45380 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -242,8 +242,8 @@ setversion_out:
 		struct file *donor_filp;
 		int err;
 
-		if (!(filp->f_mode & FMODE_READ) ||
-		    !(filp->f_mode & FMODE_WRITE))
+		if (generic_permission(filp->f_dentry->d_inode,
+			MAY_READ | MAY_WRITE, NULL))
 			return -EBADF;
 
 		if (copy_from_user(&me,
