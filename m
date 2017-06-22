From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 25/32] ext4: add ext4_is_quota_file()
Date: Wed, 21 Jun 2017 18:49:32 -0700
Message-ID: <20170622014939.3592-2-tahsin@google.com>
References: <20170622014939.3592-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33138 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdFVBtv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 21:49:51 -0400
Received: by mail-pg0-f53.google.com with SMTP id f127so1454351pgc.0
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 18:49:51 -0700 (PDT)
In-Reply-To: <20170622014939.3592-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IS_NOQUOTA() indicates whether quota is disabled for an inode. Ext4
also uses it to check whether an inode is for a quota file. The
distinction currently doesn't matter because quota is disabled only
for the quota files. When we start disabling quota for other inodes
in the future, we will want to make the distinction clear.

Replace IS_NOQUOTA() call with ext4_is_quota_file() at places where
we are checking for quota files.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/ext4.h        | 2 ++
 fs/ext4/inode.c       | 2 +-
 fs/ext4/ioctl.c       | 4 ++--
 fs/ext4/mballoc.c     | 2 +-
 fs/ext4/move_extent.c | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e4a75c643731..3b02bd897b61 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2099,6 +2099,8 @@ static inline struct ext4_inode *ext4_raw_inode(struct ext4_iloc *iloc)
 	return (struct ext4_inode *) (iloc->bh->b_data + iloc->offset);
 }
 
+#define ext4_is_quota_file(inode) IS_NOQUOTA(inode)
+
 /*
  * This structure is stuffed into the struct file's private_data field
  * for directories.  It is where we put information so that we can do
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8ee20b586567..cf91532765a4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -739,7 +739,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		if (map->m_flags & EXT4_MAP_NEW &&
 		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
 		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
-		    !IS_NOQUOTA(inode) &&
+		    !ext4_is_quota_file(inode) &&
 		    ext4_should_order_data(inode)) {
 			if (flags & EXT4_GET_BLOCKS_IO_SUBMIT)
 				ret = ext4_jbd2_inode_add_wait(handle, inode);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0c21e22acd74..dde8deb11e59 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -218,7 +218,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	unsigned int jflag;
 
 	/* Is it quota file? Do not allow user to mess with it */
-	if (IS_NOQUOTA(inode))
+	if (ext4_is_quota_file(inode))
 		goto flags_out;
 
 	oldflags = ei->i_flags;
@@ -342,7 +342,7 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 	err = -EPERM;
 	inode_lock(inode);
 	/* Is it quota file? Do not allow user to mess with it */
-	if (IS_NOQUOTA(inode))
+	if (ext4_is_quota_file(inode))
 		goto out_unlock;
 
 	err = ext4_get_inode_loc(inode, &iloc);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b7928cddd539..d109a2a2fea0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4464,7 +4464,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	trace_ext4_request_blocks(ar);
 
 	/* Allow to use superuser reservation for quota file */
-	if (IS_NOQUOTA(ar->inode))
+	if (ext4_is_quota_file(ar->inode))
 		ar->flags |= EXT4_MB_USE_ROOT_BLOCKS;
 
 	if ((ar->flags & EXT4_MB_DELALLOC_RESERVED) == 0) {
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c992ef2c2f94..9bb36909ec92 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -484,7 +484,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -EBUSY;
 	}
 
-	if (IS_NOQUOTA(orig_inode) || IS_NOQUOTA(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should "
 			"not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
-- 
2.13.1.611.g7e3b11ae1-goog
