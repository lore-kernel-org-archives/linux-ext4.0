From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/11] reiserfs: Remove i_attrs_to_sd_attrs()
Date: Wed, 12 Apr 2017 09:26:10 +0200
Message-ID: <20170412072611.29017-11-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that all places setting inode->i_flags that should be reflected in
on-disk flags are gone, we can remove i_attrs_to_sd_attrs() call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/inode.c    | 27 +--------------------------
 fs/reiserfs/ioctl.c    |  1 -
 fs/reiserfs/reiserfs.h |  1 -
 3 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index aeca1a0b7b5a..873fc04e9403 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1375,7 +1375,6 @@ static void init_inode(struct inode *inode, struct treepath *path)
 static void inode2sd(void *sd, struct inode *inode, loff_t size)
 {
 	struct stat_data *sd_v2 = (struct stat_data *)sd;
-	__u16 flags;
 
 	set_sd_v2_mode(sd_v2, inode->i_mode);
 	set_sd_v2_nlink(sd_v2, inode->i_nlink);
@@ -1390,9 +1389,7 @@ static void inode2sd(void *sd, struct inode *inode, loff_t size)
 		set_sd_v2_rdev(sd_v2, new_encode_dev(inode->i_rdev));
 	else
 		set_sd_v2_generation(sd_v2, inode->i_generation);
-	flags = REISERFS_I(inode)->i_attrs;
-	i_attrs_to_sd_attrs(inode, &flags);
-	set_sd_v2_attrs(sd_v2, flags);
+	set_sd_v2_attrs(sd_v2, REISERFS_I(inode)->i_attrs);
 }
 
 /* used to copy inode's fields to old stat data */
@@ -3091,28 +3088,6 @@ void sd_attrs_to_i_attrs(__u16 sd_attrs, struct inode *inode)
 	}
 }
 
-void i_attrs_to_sd_attrs(struct inode *inode, __u16 * sd_attrs)
-{
-	if (reiserfs_attrs(inode->i_sb)) {
-		if (inode->i_flags & S_IMMUTABLE)
-			*sd_attrs |= REISERFS_IMMUTABLE_FL;
-		else
-			*sd_attrs &= ~REISERFS_IMMUTABLE_FL;
-		if (inode->i_flags & S_SYNC)
-			*sd_attrs |= REISERFS_SYNC_FL;
-		else
-			*sd_attrs &= ~REISERFS_SYNC_FL;
-		if (inode->i_flags & S_NOATIME)
-			*sd_attrs |= REISERFS_NOATIME_FL;
-		else
-			*sd_attrs &= ~REISERFS_NOATIME_FL;
-		if (REISERFS_I(inode)->i_flags & i_nopack_mask)
-			*sd_attrs |= REISERFS_NOTAIL_FL;
-		else
-			*sd_attrs &= ~REISERFS_NOTAIL_FL;
-	}
-}
-
 /*
  * decide if this buffer needs to stay around for data logging or ordered
  * write purposes
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 1f4692a505a0..acbbaf7a0bb2 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -47,7 +47,6 @@ long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 
 		flags = REISERFS_I(inode)->i_attrs;
-		i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
 		err = put_user(flags, (int __user *)arg);
 		break;
 	case REISERFS_IOC_SETFLAGS:{
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 2adcde137c3f..784b32568497 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -3099,7 +3099,6 @@ static inline void reiserfs_update_sd(struct reiserfs_transaction_handle *th,
 }
 
 void sd_attrs_to_i_attrs(__u16 sd_attrs, struct inode *inode);
-void i_attrs_to_sd_attrs(struct inode *inode, __u16 * sd_attrs);
 int reiserfs_setattr(struct dentry *dentry, struct iattr *attr);
 
 int __reiserfs_write_begin(struct page *page, unsigned from, unsigned len);
-- 
2.12.0
