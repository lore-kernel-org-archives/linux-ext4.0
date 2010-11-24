From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Add FITRIM handling
Date: Wed, 24 Nov 2010 14:06:31 +0100
Message-ID: <1290603991-6151-3-git-send-email-jack@suse.cz>
References: <1290603991-6151-1-git-send-email-jack@suse.cz>
Cc: lczerner@redhat.com, greg.freemyer@gmail.com,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1290603991-6151-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

The ioctl takes fstrim_range structure (defined in include/linux/fs.h) as an
argument specifying a range of filesystem to trim and the minimum size of an
continguous extent to trim. After the FITRIM is done, the number of bytes
passed from the filesystem down the block stack to the device for potential
discard is stored in fstrim_range.len.  This number is a maximum discard amount
from the storage device's perspective, because FITRIM called repeatedly will
keep sending the same sectors for discard.  fstrim_range.len will report the
same potential discard bytes each time, but only sectors which had been written
to between the discards would actually be discarded by the storage device.
Further, the kernel block layer reserves the right to adjust the discard ranges
to fit raid stripe geometry, non-trim capable devices in a LVM setup, etc.
These reductions would not be reflected in fstrim_range.len.

Thus fstrim_range.len can give the user better insight on how much storage
space has potentially been released for wear-leveling, but it needs to be one
of only one criteria the userspace tools take into account when trying to
optimize calls to FITRIM.

Thanks to Greg Freemyer <greg.freemyer@gmail.com> for better commit message.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ioctl.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 8897481..fc080dd 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -276,7 +276,29 @@ group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
+	case FITRIM: {
 
+		struct super_block *sb = inode->i_sb;
+		struct fstrim_range range;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&range, (struct fstrim_range *)arg,
+				   sizeof(range)))
+			return -EFAULT;
+
+		ret = ext3_trim_fs(sb, &range);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user((struct fstrim_range *)arg, &range,
+				 sizeof(range)))
+			return -EFAULT;
+
+		return 0;
+	}
 
 	default:
 		return -ENOTTY;
-- 
1.7.1

