From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Add EXT4_IOC_TRIM ioctl to handle batched discard
Date: Thu, 18 Nov 2010 08:36:49 +0100
Message-ID: <1290065809-3976-2-git-send-email-lczerner@redhat.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	sandeen@redhat.com, lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0KRHhE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 02:37:04 -0500
In-Reply-To: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Filesystem independent ioctl was rejected as not common enough to be in
core vfs ioctl. Since we still need to access to this functionality this
commit adds ext4 specific ioctl EXT4_IOC_TRIM to dispatch
ext4_trim_fs().

It takes fstrim_range structure as an argument. fstrim_range is definec in
the include/linux/fs.h and its definition is as follows.

struct fstrim_range {
	__u64 start;
	__u64 len;
	__u64 minlen;
}

start	- first Byte to trim
len	- number of Bytes to trim from start
minlen	- minimum extent length to trim, free extents shorter than this
  number of Bytes will be ignored. This will be rounded up to fs
  block size.

After the FITRIM is done, the number of actually discarded Bytes is stored
in fstrim_range.len to give the user better insight on how much storage
space has been really released for wear-leveling.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/ioctl.c |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a5edea..2af5042 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -541,6 +541,7 @@ struct ext4_new_group_data {
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+#define EXT4_IOC_TRIM			FITRIM
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bf5ae88..e07944a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -331,6 +331,30 @@ mext_out:
 		return err;
 	}
 
+	case EXT4_IOC_TRIM:
+	{
+		struct super_block *sb = inode->i_sb;
+		struct fstrim_range range;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&range, (struct fstrim_range *)arg,
+		    sizeof(range)))
+			return -EFAULT;
+
+		ret = ext4_trim_fs(sb, &range);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user((struct fstrim_range *)arg, &range,
+		    sizeof(range)))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.2.3

