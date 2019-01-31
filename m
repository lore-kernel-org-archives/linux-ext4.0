Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CEDC282D7
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 01:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6FEE2184D
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 01:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7oWo6Tn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfAaBr2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 20:47:28 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34715 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfAaBr2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2019 20:47:28 -0500
Received: by mail-pl1-f194.google.com with SMTP id w4so723644plz.1;
        Wed, 30 Jan 2019 17:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gR1uNZiovdqTrtm9scka0by81Qos9fKWDe91jVB7UcQ=;
        b=E7oWo6Tnlh8HQ2YqGTzEZryePZ8UeT8wrkPJuqRIvzVtY330Szbx0C/6DcJc+IXd3v
         DL5oDQUSkVN4A0xQ88e/1Cj4qe6vTaNL3pnZM5jNdI32vc6N8t8Uw9qs31WxgMbRJMsN
         2LpIp853vk4rv+OZu2Zfv927qJPFmmGa8u2nem007RjeDuGOg5IW/oNEsTm69XdsDTWv
         Pv+Nh1RWlaF1m8qTLHDjPUnGa7dvPc9kJZVWRA0tbH+OfGRc1PDp4TcpNsJhxT4aLSYP
         UC1WMDq88ToOqj81OYJJqU9SAyisoJ83S37zzjUSo9tET13UGh/XjRPyK9PtZcDb0CZ/
         ooTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gR1uNZiovdqTrtm9scka0by81Qos9fKWDe91jVB7UcQ=;
        b=M5anmPW8nuulVZMWRBVFxCE9J3Bk4VTihFXDikDrXsabGysY78oFqKwEhlMEDZLhwg
         dyDdnEOI4cjKSK4xQfUJHvdwlJCeYUpIffExCrjPe7kibfXyUKDgNWZBq0NYKLMOXqUm
         ood35Llj29QXQx+mLaaOOb1nx4AB5xRTtGQYYj3ZTBNCRy5JfUVu5Rscws2AeQ+mB3OG
         OLuakML24VaWN0InnNfWx96JdAAwiBLiq7TcVFwZiFVhe0B0YnuhGTZY99AhT3psItXP
         ghWCaTnAC1rC6voPShAqf9Bj7KDXZ2X0dP4/kbIyfUqb7+2cVhJ/oO6cDxOhd5bhHecr
         W4BQ==
X-Gm-Message-State: AJcUukcsDPLB4CkxDLj0jIbGs7CwqI4csU72WBCQ5j5zL7MmD9CoQC4K
        vqvPi6cKX+n/dpumr99YIHDP/O/8
X-Google-Smtp-Source: ALg8bN7Ng/OOlIWzlY3u02U4tCBDI7xoV80pQWAwoIC2WNxS75DYDQHKf2IIXQUeW0L19iO6Fo66Vw==
X-Received: by 2002:a17:902:4624:: with SMTP id o33mr32204080pld.289.1548899247279;
        Wed, 30 Jan 2019 17:47:27 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id x3sm7836806pgt.45.2019.01.30.17.47.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 17:47:26 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Date:   Thu, 31 Jan 2019 10:47:12 +0900
Message-Id: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

Currently there is no way to change project ID of
symlink file itself, this is important to implement
Directory quota for an existed directory.

For example, for a newly created dir, we could just
set project <ID> and inherit attribute, newly created
symlink file will inherit it automatically.

We implment project changes by GET/SETXATTR ioctl,the
hook function only works for file or dir. To support
symlink file we could do by some ways that i could think of:

1) Add unlocked_ioctl for sys link files.
2) Add FS_IOC_FS[GET|SET]TXATTR_CHILD ioctl which
get/set the xattr of an inode by giving its parent
directory and its dentry name.

This patch try to use the second way to address this problem.
Child share parent @filep for mnt_want_write_file() for
security check which actually try to use sb, and use
for filesystem freeze purpose.

Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/ext4.h                |   2 +
 fs/ext4/ioctl.c               | 148 +++++++++++++++++++++++++---------
 include/uapi/linux/fs.h       |  10 +++
 tools/include/uapi/linux/fs.h |  10 +++
 4 files changed, 132 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 185a05d3257e..2468c64bb987 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -648,6 +648,8 @@ enum {
 
 #define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
 #define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
+#define EXT4_IOC_FSGETXATTR_CHILD	FS_IOC_FSGETXATTR_CHILD
+#define EXT4_IOC_FSSETXATTR_CHILD	FS_IOC_FSSETXATTR_CHILD
 
 #define EXT4_IOC_SHUTDOWN _IOR ('X', 125, __u32)
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d37dafa1d133..0a75cda2dba1 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -20,6 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/iversion.h>
+#include <linux/namei.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include <linux/fsmap.h>
@@ -333,9 +334,8 @@ static int ext4_ioctl_setflags(struct inode *inode,
 }
 
 #ifdef CONFIG_QUOTA
-static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
+static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 {
-	struct inode *inode = file_inode(filp);
 	struct super_block *sb = inode->i_sb;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	int err, rc;
@@ -419,7 +419,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	return err;
 }
 #else
-static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
+static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 {
 	if (projid != EXT4_DEF_PROJID)
 		return -EOPNOTSUPP;
@@ -663,6 +663,59 @@ static int ext4_ioctl_check_project(struct inode *inode, struct fsxattr *fa)
 	return 0;
 }
 
+static void ext4_ioctl_fsgetxattr(struct inode *inode, struct fsxattr *fa,
+				  unsigned long arg)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	memset(fa, 0, sizeof(struct fsxattr));
+	fa->fsx_xflags = ext4_iflags_to_xflags(ei->i_flags &
+					       EXT4_FL_USER_VISIBLE);
+
+	if (ext4_has_feature_project(inode->i_sb))
+		fa->fsx_projid = (__u32)from_kprojid(&init_user_ns,
+						     ei->i_projid);
+}
+
+static int ext4_ioctl_fssetxattr(struct file *filp, struct inode *cinode,
+				 struct fsxattr *fa)
+{
+	int err;
+	unsigned int flags;
+	struct ext4_inode_info *ei = EXT4_I(cinode);
+
+	/* Make sure caller has proper permission */
+	if (!inode_owner_or_capable(cinode))
+		return -EACCES;
+
+	if (fa->fsx_xflags & ~EXT4_SUPPORTED_FS_XFLAGS)
+		return -EOPNOTSUPP;
+
+	flags = ext4_xflags_to_iflags(fa->fsx_xflags);
+	if (ext4_mask_flags(cinode->i_mode, flags) != flags)
+		return -EOPNOTSUPP;
+
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
+
+	inode_lock(cinode);
+	err = ext4_ioctl_check_project(cinode, fa);
+	if (err)
+		goto out;
+	flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
+		 (flags & EXT4_FL_XFLAG_VISIBLE);
+	err = ext4_ioctl_setflags(cinode, flags);
+	if (err)
+		goto out;
+	err = ext4_ioctl_setproject(cinode, fa->fsx_projid);
+out:
+	inode_unlock(cinode);
+	mnt_drop_write_file(filp);
+
+	return err;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1024,56 +1077,75 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	{
 		struct fsxattr fa;
 
-		memset(&fa, 0, sizeof(struct fsxattr));
-		fa.fsx_xflags = ext4_iflags_to_xflags(ei->i_flags & EXT4_FL_USER_VISIBLE);
+		ext4_ioctl_fsgetxattr(inode, &fa, arg);
 
-		if (ext4_has_feature_project(inode->i_sb)) {
-			fa.fsx_projid = (__u32)from_kprojid(&init_user_ns,
-				EXT4_I(inode)->i_projid);
-		}
+		if (copy_to_user((struct fsxattr __user *)arg, &fa,
+				 sizeof(fa)))
+			return -EFAULT;
+	}
+	case EXT4_IOC_FSGETXATTR_CHILD:
+	{
+		struct fsxattr_child fa;
+		struct dentry *dentry;
 
-		if (copy_to_user((struct fsxattr __user *)arg,
-				 &fa, sizeof(fa)))
+		if (copy_from_user(&fa, (struct fsxattr_child __user *)arg,
+				   sizeof(fa)))
+			return -EFAULT;
+
+		fa.fsxc_name[NAME_MAX] = '\0';
+		inode_lock(file_inode(filp));
+		dentry = lookup_one_len(fa.fsxc_name, file_dentry(filp),
+					strlen(fa.fsxc_name));
+		inode_unlock(file_inode(filp));
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+
+		ext4_ioctl_fsgetxattr(d_inode(dentry), &fa.fsxc_fsx, arg);
+		dput(dentry);
+
+		if (copy_to_user((struct fsxattr_child __user *)arg, &fa,
+				 sizeof(fa)))
 			return -EFAULT;
-		return 0;
 	}
 	case EXT4_IOC_FSSETXATTR:
 	{
 		struct fsxattr fa;
-		int err;
 
 		if (copy_from_user(&fa, (struct fsxattr __user *)arg,
 				   sizeof(fa)))
 			return -EFAULT;
 
-		/* Make sure caller has proper permission */
-		if (!inode_owner_or_capable(inode))
-			return -EACCES;
-
-		if (fa.fsx_xflags & ~EXT4_SUPPORTED_FS_XFLAGS)
-			return -EOPNOTSUPP;
+		return ext4_ioctl_fssetxattr(filp, inode, &fa);
+	}
+	case EXT4_IOC_FSSETXATTR_CHILD:
+	{
+		struct fsxattr_child fa;
+		struct dentry *dentry;
+		int err;
 
-		flags = ext4_xflags_to_iflags(fa.fsx_xflags);
-		if (ext4_mask_flags(inode->i_mode, flags) != flags)
-			return -EOPNOTSUPP;
+		if (copy_from_user(&fa, (struct fsxattr_child __user *)arg,
+				   sizeof(fa)))
+			return -EFAULT;
 
-		err = mnt_want_write_file(filp);
-		if (err)
-			return err;
+		fa.fsxc_name[NAME_MAX] = '\0';
+		inode_lock(file_inode(filp));
+		dentry = lookup_one_len(fa.fsxc_name, file_dentry(filp),
+					strlen(fa.fsxc_name));
+		inode_unlock(file_inode(filp));
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+		/* this didn't work since child will share
+		 * parent @filp to use mnt_want_write_file()
+		 */
+		if (file_inode(filp)->i_sb != d_inode(dentry)->i_sb) {
+			err = -EXDEV;
+			goto errout;
+		}
 
-		inode_lock(inode);
-		err = ext4_ioctl_check_project(inode, &fa);
-		if (err)
-			goto out;
-		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
-			 (flags & EXT4_FL_XFLAG_VISIBLE);
-		err = ext4_ioctl_setflags(inode, flags);
-		if (err)
-			goto out;
-		err = ext4_ioctl_setproject(filp, fa.fsx_projid);
-out:
-		inode_unlock(inode);
-		mnt_drop_write_file(filp);
+		err = ext4_ioctl_fssetxattr(filp, d_inode(dentry),
+					    &fa.fsxc_fsx);
+errout:
+		dput(dentry);
 		return err;
 	}
 	case EXT4_IOC_SHUTDOWN:
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 121e82ce296b..e8f54126da2e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -118,6 +118,14 @@ struct fsxattr {
 	unsigned char	fsx_pad[8];
 };
 
+/*
+ * Structure for FS_IOC_FSGETXATTR_CHILD and FS_IOC_FSSETXATTR_CHILD.
+ */
+struct fsxattr_child {
+	struct fsxattr	fsxc_fsx;
+	unsigned char	fsxc_name[NAME_MAX + 1]; /* child filename */
+};
+
 /*
  * Flags for the fsx_xflags field
  */
@@ -209,6 +217,8 @@ struct fsxattr {
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
 #define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
 #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTR_CHILD		_IOR('X', 33, struct fsxattr_child)
+#define FS_IOC_FSSETXATTR_CHILD		_IOW('X', 34, struct fsxattr_child)
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
diff --git a/tools/include/uapi/linux/fs.h b/tools/include/uapi/linux/fs.h
index 121e82ce296b..e8f54126da2e 100644
--- a/tools/include/uapi/linux/fs.h
+++ b/tools/include/uapi/linux/fs.h
@@ -118,6 +118,14 @@ struct fsxattr {
 	unsigned char	fsx_pad[8];
 };
 
+/*
+ * Structure for FS_IOC_FSGETXATTR_CHILD and FS_IOC_FSSETXATTR_CHILD.
+ */
+struct fsxattr_child {
+	struct fsxattr	fsxc_fsx;
+	unsigned char	fsxc_name[NAME_MAX + 1]; /* child filename */
+};
+
 /*
  * Flags for the fsx_xflags field
  */
@@ -209,6 +217,8 @@ struct fsxattr {
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
 #define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
 #define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTR_CHILD		_IOR('X', 33, struct fsxattr_child)
+#define FS_IOC_FSSETXATTR_CHILD		_IOW('X', 34, struct fsxattr_child)
 #define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
 #define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
-- 
2.20.1

