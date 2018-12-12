Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbeLLJwH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 04:52:07 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBC9nL0N016836
        for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2018 04:52:05 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2pay29u4qh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 12 Dec 2018 04:52:05 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Dec 2018 09:52:03 -0000
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
        adrian.hunter@intel.com, viro@zeniv.linux.org.uk,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH V5 8/9] fsverity: Move verity status check to fsverity_file_open
Date: Wed, 12 Dec 2018 15:20:17 +0530
In-Reply-To: <20181212095018.12648-1-chandan@linux.vnet.ibm.com>
References: <20181212095018.12648-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181212095018.12648-9-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of conditionally checking for verity status of an inode before
invoking fsverity_file_open(), this commit moves the check inside the
definition of fsverity_file_open().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
(EB: fix the !CONFIG_FS_VERITY case and inline the IS_VERITY() check)
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/file.c           |  8 +++-----
 fs/f2fs/file.c           |  8 +++-----
 fs/verity/setup.c        | 18 ++----------------
 include/linux/fsverity.h | 25 +++++++++++++++++++++++--
 4 files changed, 31 insertions(+), 28 deletions(-)

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
index 08b609127531..4ecaeb89166b 100644
--- a/fs/verity/setup.c
+++ b/fs/verity/setup.c
@@ -755,21 +755,7 @@ static int setup_fsverity_info(struct inode *inode)
 	return 0;
 }
 
-/**
- * fsverity_file_open - prepare to open a verity file
- * @inode: the inode being opened
- * @filp: the struct file being set up
- *
- * When opening a verity file, deny the open if it is for writing.  Otherwise,
- * set up the inode's ->i_verity_info (if not already done) by parsing the
- * verity metadata at the end of the file.
- *
- * When combined with fscrypt, this must be called after fscrypt_file_open().
- * Otherwise, we won't have the key set up to decrypt the verity metadata.
- *
- * Return: 0 on success, -errno on failure
- */
-int fsverity_file_open(struct inode *inode, struct file *filp)
+int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE) {
 		pr_debug("Denying opening verity file (ino %lu) for write\n",
@@ -779,7 +765,7 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
 
 	return setup_fsverity_info(inode);
 }
-EXPORT_SYMBOL_GPL(fsverity_file_open);
+EXPORT_SYMBOL_GPL(__fsverity_file_open);
 
 /**
  * fsverity_prepare_setattr - prepare to change a verity inode's attributes
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index ea8c418bd7d5..0ce170c2c167 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -25,7 +25,7 @@ extern int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
 extern int fsverity_ioctl_measure(struct file *filp, void __user *arg);
 
 /* setup.c */
-extern int fsverity_file_open(struct inode *inode, struct file *filp);
+extern int __fsverity_file_open(struct inode *inode, struct file *filp);
 extern int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 extern int fsverity_prepare_getattr(struct inode *inode);
 extern void fsverity_cleanup_inode(struct inode *inode);
@@ -58,7 +58,7 @@ static inline int fsverity_ioctl_measure(struct file *filp, void __user *arg)
 
 /* setup.c */
 
-static inline int fsverity_file_open(struct inode *inode, struct file *filp)
+static inline int __fsverity_file_open(struct inode *inode, struct file *filp)
 {
 	return -EOPNOTSUPP;
 }
@@ -108,4 +108,25 @@ static inline bool fsverity_check_hole(struct inode *inode, struct page *page)
 
 #endif	/* ! CONFIG_FS_VERITY */
 
+/**
+ * fsverity_file_open - prepare to open a verity file
+ * @inode: the inode being opened
+ * @filp: the struct file being set up
+ *
+ * When opening a verity file, deny the open if it is for writing.  Otherwise,
+ * set up the inode's ->i_verity_info (if not already done) by parsing the
+ * verity metadata at the end of the file.
+ *
+ * When combined with fscrypt, this must be called after fscrypt_file_open().
+ * Otherwise, we won't have the key set up to decrypt the verity metadata.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+static inline int fsverity_file_open(struct inode *inode, struct file *filp)
+{
+	if (IS_VERITY(inode))
+		return __fsverity_file_open(inode, filp);
+	return 0;
+}
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.19.1
