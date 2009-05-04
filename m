From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2] vfs: Enable FS_IOC_FIEMAP and FIGETBSZ for all filetypes
Date: Mon,  4 May 2009 14:32:22 +0530
Message-ID: <1241427742-13049-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090503203037.GA17044@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52237 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZEDJCh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 05:02:37 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4492XK6020994
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 14:32:33 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4492XTq2293878
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 14:32:33 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4492X96013504
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:02:33 +1000
In-Reply-To: <20090503203037.GA17044@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fiemap and get_blk_size ioctl should be enabled even for directories.
So move it outisde file_ioctl. Enabling file_ioctl for both
directories and files cause udev to hang when using FIONREAD. I guess
some of the user space may depend on these ioctls cmd failing on
directories.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ioctl.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index ac2d47e..5362398 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -379,10 +379,6 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 	switch (cmd) {
 	case FIBMAP:
 		return ioctl_fibmap(filp, p);
-	case FS_IOC_FIEMAP:
-		return ioctl_fiemap(filp, arg);
-	case FIGETBSZ:
-		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	}
@@ -522,6 +518,16 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		error = ioctl_fsthaw(filp);
 		break;
 
+	case FS_IOC_FIEMAP:
+		return ioctl_fiemap(filp, arg);
+
+	case FIGETBSZ:
+	{
+		struct inode *inode = filp->f_path.dentry->d_inode;
+		int __user *p = (int __user *)arg;
+		return put_user(inode->i_sb->s_blocksize, p);
+	}
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
-- 
1.6.3.rc4

