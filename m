From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] ext3: add ioctl to force 32-bit hashes from indexed
 dirs
Date: Thu, 28 Mar 2013 11:25:17 -0500
Message-ID: <51546EED.8030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Anand Avati <avati@redhat.com>, Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab3C1Q0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 12:26:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This adds a new ioctl, EXT3_IOC_32BITHASH, which allows a
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
filp->private_data has not yet been set before we set the flag
(Thanks Zach!).

Pre-submission-fixes-by: Zach Brown <zab@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 87eccbb..83df29f 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -47,7 +47,7 @@ static unsigned char get_dtype(struct super_block *sb, int filetype)
  *
  * Return 1 if it is a dx dir, 0 if not
  */
-static int is_dx_dir(struct inode *inode)
+int is_dx_dir(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index e85ff15..b88cf19 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -220,6 +220,7 @@ struct ext3_new_group_data {
 #endif
 #define EXT3_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT3_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT3_IOC_32BITHASH		_IOW('f', 13, long)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -1010,6 +1011,7 @@ extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_wind
 extern int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range);
 
 /* dir.c */
+extern int is_dx_dir(struct inode *inode);
 extern int ext3_check_dir_entry(const char *, struct inode *,
 				struct ext3_dir_entry_2 *,
 				struct buffer_head *, unsigned long);
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 4d96e9a..aab217d 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -251,6 +251,41 @@ group_add_out:
 		mnt_drop_write_file(filp);
 		return err;
 	}
+	case EXT3_IOC_32BITHASH: {
+		__u32 hash32bits;
+		int err = 0;
+
+		if (get_user(hash32bits, (int __user *) arg))
+			return -EFAULT;
+
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
+			goto out_32bithash;
+		}
+
+		/* Have we already started readir on this dx dir? */
+		if (filp->private_data) {
+			err = -EINVAL;
+			goto out_32bithash;
+		}
+
+		if (hash32bits)
+			filp->f_mode |= FMODE_32BITHASH;
+		else
+			filp->f_mode &= ~FMODE_32BITHASH;
+out_32bithash:
+		spin_unlock(&filp->f_lock);
+		mutex_unlock(&inode->i_mutex);
+		return err;
+	}
 	case FITRIM: {
 
 		struct super_block *sb = inode->i_sb;

