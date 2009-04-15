From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] vfs: call file_ioctl call for directories.
Date: Wed, 15 Apr 2009 20:09:02 +0530
Message-ID: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40108 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZDOOjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 10:39:23 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3G1b4Jx030499
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 11:37:04 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3FEdJTF1261702
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 00:39:19 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3FEdJfi004679
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 00:39:19 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most of the ioctl callback in file_ioctl should be done even
for directories. For ext4 fiemap should work even for directories.
Similarly FIGETBSZ  should work for directories. For bmap filefrag command
doesn't do the ioctl if the type is not a regular file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index ac2d47e..328b533 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -523,7 +523,8 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	default:
-		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
+		if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode) ||
+		    S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
 		else
 			error = vfs_ioctl(filp, cmd, arg);
-- 
tg: (0882e8d..) dir_fiemap (depends on: master)
