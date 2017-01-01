From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 1/2 linux-next] ext4: check inode permissions in ext4_ioctl()
Date: Sun,  1 Jan 2017 12:04:28 +0100
Message-ID: <1483268668-32246-1-git-send-email-fabf@skynet.be>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabf@skynet.be
To: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

According to other FS like UDF, ioctl has to check if inode
is readable before proceeding otherwise permissions updated between
file opening and ioctl are ignored.

Set operations were already protected but nothing around
get like EXT4_IOC_GETVERSION

This patch applies the same test than udf_ioctl() but returns
-EACCES "permission denied" like the rest of ext4_ioctl()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: check readability in get operations only.

 fs/ext4/ioctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 49fd137..f665c02 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -453,6 +453,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case EXT4_IOC_GETFLAGS:
+		if (inode_permission(inode, MAY_READ) != 0)
+			return -EACCES;
+
 		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
@@ -489,6 +492,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	}
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
+		if (inode_permission(inode, MAY_READ) != 0)
+			return -EACCES;
+
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT4_IOC_SETVERSION:
 	case EXT4_IOC_SETVERSION_OLD: {
@@ -834,12 +840,18 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #endif
 	}
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+		if (inode_permission(inode, MAY_READ) != 0)
+			return -EACCES;
+
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
 
+		if (inode_permission(inode, MAY_READ) != 0)
+			return -EACCES;
+
 		memset(&fa, 0, sizeof(struct fsxattr));
 		ext4_get_inode_flags(ei);
 		fa.fsx_xflags = ext4_iflags_to_xflags(ei->i_flags & EXT4_FL_USER_VISIBLE);
-- 
2.7.4
