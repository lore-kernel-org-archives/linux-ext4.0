From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 22/22] ext4 crypto: add password salt support
Date: Thu,  2 Apr 2015 18:10:59 -0400
Message-ID: <1428012659-12709-23-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48009 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbbDBWNE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:13:04 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The goal of the salt is to prevent rainbow table attacks on users'
passphrases.  The salt is fetched by e4crypto using an ioctl
interface; if the salt field in the superblock is not yet set, the
ioctl will generate a random UUID and use that as the salt for the
file system.

Change-Id: Icb8c901fb842eecd730f1bb3ef112e6607d77889
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h  |  4 +++-
 fs/ext4/ioctl.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index de3b1e4..0b281aa 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -612,6 +612,7 @@ enum {
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
 #define EXT4_IOC_ENCRYPTION_POLICY	_IOW('f', 19, struct ext4_encryption_policy)
+#define EXT4_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -1172,7 +1173,8 @@ struct ext4_super_block {
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
-	__le32	s_reserved[105];	/* Padding to the end of the block */
+	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
+	__le32	s_reserved[101];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e4ae8f9..f5d8ec0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/random.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -196,6 +197,16 @@ journal_err_out:
 	return err;
 }
 
+static int uuid_is_zero(__u8 u[16])
+{
+	int	i;
+
+	for (i=0; i < 16; i++)
+		if (u[i])
+			return 0;
+	return 1;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -635,6 +646,43 @@ encryption_policy_out:
 #else
 		return -EOPNOTSUPP;
 #endif
+	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
+	{
+		int err, err2;
+		struct ext4_sb_info *sbi = EXT4_SB(sb);
+		handle_t *handle;
+
+		if (!ext4_sb_has_crypto(sb))
+			return -EOPNOTSUPP;
+		if (uuid_is_zero(sbi->s_es->s_encrypt_pw_salt)) {
+			err = mnt_want_write_file(filp);
+			if (err)
+				return err;
+			handle = ext4_journal_start_sb(sb, EXT4_HT_MISC, 1);
+			if (IS_ERR(handle)) {
+				err = PTR_ERR(handle);
+				goto pwsalt_err_exit;
+			}
+			err = ext4_journal_get_write_access(handle, sbi->s_sbh);
+			if (err)
+				goto pwsalt_err_journal;
+			generate_random_uuid(sbi->s_es->s_encrypt_pw_salt);
+			err = ext4_handle_dirty_metadata(handle, NULL,
+							 sbi->s_sbh);
+		pwsalt_err_journal:
+			err2 = ext4_journal_stop(handle);
+			if (err2 && !err)
+				err = err2;
+		pwsalt_err_exit:
+			mnt_drop_write_file(filp);
+			if (err)
+				return err;
+		}
+		if (copy_to_user((void *) arg, sbi->s_es->s_encrypt_pw_salt,
+				 16))
+			return -EFAULT;
+		return 0;
+	}
 	default:
 		return -ENOTTY;
 	}
@@ -700,6 +748,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_RESIZE_FS:
 	case EXT4_IOC_PRECACHE_EXTENTS:
 	case EXT4_IOC_ENCRYPTION_POLICY:
+	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.3.0

