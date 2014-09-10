From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH v3 4/4] quota: add project quota support
Date: Wed, 10 Sep 2014 11:54:54 +0800
Message-ID: <CAPTn0cBRXu_aHS19Mpn-Mjn6pfghE3aKB6+N86e5pU28+AWByQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:54426 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaIJDyz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 23:54:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds ioctl interface support for ext4 project

This patch adds ioctl interface for setting/getting project of ext4.

Signed-off-by: Li Xi <lixi <at> ddn.com>
---
Index: linux.git/fs/ext4/ext4.h
===================================================================
--- linux.git.orig/fs/ext4/ext4.h
+++ linux.git/fs/ext4/ext4.h
@@ -617,6 +617,8 @@ enum {
 #define EXT4_IOC_RESIZE_FS        _IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT        _IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS    _IO('f', 18)
+#define EXT4_IOC_GETPROJECT        _IOR('f', 19, long)
+#define EXT4_IOC_SETPROJECT        _IOW('f', 20, long)

 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
Index: linux.git/Documentation/filesystems/ext4.txt
===================================================================
--- linux.git.orig/Documentation/filesystems/ext4.txt
+++ linux.git/Documentation/filesystems/ext4.txt
@@ -609,6 +609,10 @@ EXT4_IOC_SWAP_BOOT          Swap i_blocks a
                   The data blocks of the previous boot loader
                   will be associated with the given inode.

+ EXT4_IOC_GETPROJECT          Get project ID associated with inode.
+
+ EXT4_IOC_SETPROJECT          Set Project ID associated with inode.
+
 ..............................................................................

 References
Index: linux.git/fs/ext4/ioctl.c
===================================================================
--- linux.git.orig/fs/ext4/ioctl.c
+++ linux.git/fs/ext4/ioctl.c
@@ -14,6 +14,8 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/quotaops.h>
+#include <linux/quota.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -611,6 +613,104 @@ resizefs_out:
     case EXT4_IOC_PRECACHE_EXTENTS:
         return ext4_ext_precache(inode);

+    case EXT4_IOC_GETPROJECT:
+    {
+#ifdef CONFIG_QUOTA_PROJECT
+        __u32 projid;
+
+        if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+            ext4_msg(sb, KERN_ERR,
+                 "get project not supported without "
+                 "project feature");
+            return -ENOTSUPP;
+        }
+
+        projid = (__u32)from_kprojid(&init_user_ns,
+                         EXT4_I(inode)->i_projid);
+        return put_user(projid, (__u32 __user *) arg);
+#else
+        ext4_msg(sb, KERN_ERR,
+             "get project not supported without "
+             "CONFIG_QUOTA_PROJECT");
+        return -ENOTSUPP;
+#endif
+    }
+    case EXT4_IOC_SETPROJECT:
+    {
+#ifdef CONFIG_QUOTA_PROJECT
+        __u32 projid;
+        int err;
+        handle_t *handle;
+        kprojid_t kprojid;
+
+        struct dquot *transfer_to[MAXQUOTAS] = { };
+
+        if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+            ext4_msg(sb, KERN_ERR,
+                 "set project not supported without "
+                 "project feature");
+            return -ENOTSUPP;
+        }
+
+        /* Make sure caller can change project. */
+        if (!capable(CAP_SYS_ADMIN))
+            return -EACCES;
+
+        if (get_user(projid, (__u32 __user *) arg))
+            return -EFAULT;
+
+        kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
+
+        if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
+            return 0;
+
+        err = mnt_want_write_file(filp);
+        if (err)
+            return err;
+
+        err = -EPERM;
+        mutex_lock(&inode->i_mutex);
+        /* Is it quota file? Do not allow user to mess with it */
+        if (IS_NOQUOTA(inode))
+            goto project_out;
+
+        dquot_initialize(inode);
+
+        handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
+            EXT4_QUOTA_INIT_BLOCKS(sb) +
+            EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
+        if (IS_ERR(handle)) {
+            err = PTR_ERR(handle);
+            goto project_out;
+        }
+
+        transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
+        if (!transfer_to[PRJQUOTA]) {
+            err = -ESRCH;
+            goto project_stop;
+        }
+        err = __dquot_transfer(inode, transfer_to);
+        dqput(transfer_to[PRJQUOTA]);
+        if (err)
+            goto project_stop;
+
+        EXT4_I(inode)->i_projid = kprojid;
+        err = ext4_mark_inode_dirty(handle, inode);
+project_stop:
+        ext4_journal_stop(handle);
+project_out:
+        mutex_unlock(&inode->i_mutex);
+        mnt_drop_write_file(filp);
+        return err;
+#else
+        ext4_msg(sb, KERN_ERR,
+             "set project not supported without "
+             "CONFIG_QUOTA_PROJECT");
+        return -ENOTSUPP;
+#endif
+    }
     default:
         return -ENOTTY;
     }
