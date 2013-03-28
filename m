From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC V2] ext4: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Thu, 28 Mar 2013 15:39:16 -0500
Message-ID: <5154AA74.90501@redhat.com>
References: <51546C4E.9010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Anand Avati <avati@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3C1UjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 16:39:17 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2SKdHp4022086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 16:39:17 -0400
In-Reply-To: <51546C4E.9010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a new ioctl, EXT4_IOC_32BITHASH, which allows a
userspace application to request 32-bit rather than 64-bit
hashes from readdir on an indexed / dx / htree directory.

Gluster had been relying on the top bits of the d_off being
free; there are some reports that filling all 64 bits breaks
Samba as well.  The infrastructure to return 32-bit hashes
already exists; NFS can turn it on, and it's turned on for
32-bit processes as well.  So it's just a matter of flipping
on the f_mode flag before readdir starts.

Care needs to be taken that we don't change the FMODE flag
after readdir has been started, so we make sure that
filp->private_data has not yet been set before we set the flag.
(Thanks Zach!).

Pre-submission-fixes-by: Zach Brown <zab@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2:
fix "readir" typo
rename goto target to *_out like others
remove parameter; we can't really ever turn this back off once it's used.
closing and reopening is the only way to get back to 64 bit hashes.

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d8cd1f0..5e3a316 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -39,7 +39,7 @@ static int ext4_dx_readdir(struct file *filp,
  *
  * Return 1 if it is a dx dir, 0 if not
  */
-static int is_dx_dir(struct inode *inode)
+int is_dx_dir(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3b83cd6..44a9b52 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -614,6 +614,7 @@ enum {
  /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
+#define EXT4_IOC_32BITHASH		_IO('f', 13)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 
@@ -1953,6 +1954,7 @@ extern unsigned ext4_num_overhead_clusters(struct super_block *sb,
 ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 
 /* dir.c */
+extern int is_dx_dir(struct inode *inode);
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 				  struct file *,
 				  struct ext4_dir_entry_2 *,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 721f4d3..1d1f7f1 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -356,7 +356,34 @@ group_add_out:
 		mnt_drop_write_file(filp);
 		return err;
 	}
+	case EXT4_IOC_32BITHASH: {
+		int err = 0;
 
+		/* Serialize with readdir */
+		if ((err = mutex_lock_killable(&inode->i_mutex)))
+			return err;
+
+		/* protect f_mode */
+		spin_lock(&filp->f_lock);
+
+		/* Only valid for htree directories */
+		if (!S_ISDIR(inode->i_mode) || !is_dx_dir(inode)) {
+			err = -EINVAL;
+			goto hash32bits_out;
+		}
+
+		/* Have we already started readdir on this dx dir? */
+		if (filp->private_data) {
+			err = -EINVAL;
+			goto hash32bits_out;
+		}
+
+		filp->f_mode |= FMODE_32BITHASH;
+hash32bits_out:
+		spin_unlock(&filp->f_lock);
+		mutex_unlock(&inode->i_mutex);
+		return err;
+	}
 	case EXT4_IOC_RESIZE_FS: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;

