Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbeLLEJE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 23:09:04 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBC43urm137677
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 23:09:04 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2parc1deg3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 11 Dec 2018 23:09:04 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Dec 2018 04:09:02 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com, corbet@lwn.net, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, green.hu@gmail.com,
        deanbo422@gmail.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, richard@nod.at, dedekind1@gmail.com,
        adrian.hunter@intel.com, viro@zeniv.linux.org.uk
Subject: [PATCH V4 8/9] fsverity: Move verity status check to fsverity_file_open
Date: Wed, 12 Dec 2018 09:37:35 +0530
In-Reply-To: <20181212040736.2849-1-chandan@linux.vnet.ibm.com>
References: <20181212040736.2849-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181212040736.2849-9-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of conditionally checking for verity status of an inode before
invoking fsverity_file_open(), this commit moves the check inside the
definition of fsverity_file_open().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/file.c           | 8 +++-----
 fs/f2fs/file.c           | 8 +++-----
 fs/verity/setup.c        | 3 +++
 include/linux/fsverity.h | 5 ++++-
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 30fbd663354f..b404a857cd48 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -444,11 +444,9 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	if (ret)
 		return ret;
 
-	if (IS_VERITY(inode)) {
-		ret = fsverity_file_open(inode, filp);
-		if (ret)
-			return ret;
-	}
+	ret = fsverity_file_open(inode, filp);
+	if (ret)
+		return ret;
 
 	/*
 	 * Set up the jbd2_inode if we are opening the inode for
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2eb4821d95d1..925c0d9608da 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -491,11 +491,9 @@ static int f2fs_file_open(struct inode *inode, struct file *filp)
 	if (err)
 		return err;
 
-	if (IS_VERITY(inode)) {
-		err = fsverity_file_open(inode, filp);
-		if (err)
-			return err;
-	}
+	err = fsverity_file_open(inode, filp);
+	if (err)
+		return err;
 
 	filp->f_mode |= FMODE_NOWAIT;
 
diff --git a/fs/verity/setup.c b/fs/verity/setup.c
index 08b609127531..bc463dc601b1 100644
--- a/fs/verity/setup.c
+++ b/fs/verity/setup.c
@@ -771,6 +771,9 @@ static int setup_fsverity_info(struct inode *inode)
  */
 int fsverity_file_open(struct inode *inode, struct file *filp)
 {
+	if (!IS_VERITY(inode))
+		return 0;
+
 	if (filp->f_mode & FMODE_WRITE) {
 		pr_debug("Denying opening verity file (ino %lu) for write\n",
 			 inode->i_ino);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index ea8c418bd7d5..c770025606e1 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -60,7 +60,10 @@ static inline int fsverity_ioctl_measure(struct file *filp, void __user *arg)
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
 {
-	return -EOPNOTSUPP;
+	if (IS_VERITY(inode))
+		return -EOPNOTSUPP;
+
+	return 0;
 }
 
 static inline int fsverity_prepare_setattr(struct dentry *dentry,
-- 
2.19.1
