From: akpm@linux-foundation.org
Subject: - ext4-copy-i_flags-to-inode-flags-on-write.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:44 -0700
Message-ID: <200705291856.l4TIuhAR008664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: copy i_flags to inode flags on write
has been removed from the -mm tree.  Its filename was
     ext4-copy-i_flags-to-inode-flags-on-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: copy i_flags to inode flags on write
From: Jan Kara <jack@suse.cz>

Propagate flags such as S_APPEND, S_IMMUTABLE, etc.  from i_flags into
ext4-specific i_flags.  Hence, when someone sets these flags via a
different interface than ioctl, they are stored correctly.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c         |   20 ++++++++++++++++++++
 fs/ext4/ioctl.c         |    1 +
 include/linux/ext4_fs.h |    1 +
 3 files changed, 22 insertions(+)

diff -puN fs/ext4/inode.c~ext4-copy-i_flags-to-inode-flags-on-write fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-copy-i_flags-to-inode-flags-on-write
+++ a/fs/ext4/inode.c
@@ -2613,6 +2613,25 @@ void ext4_set_inode_flags(struct inode *
 		inode->i_flags |= S_DIRSYNC;
 }
 
+/* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
+void ext4_get_inode_flags(struct ext4_inode_info *ei)
+{
+	unsigned int flags = ei->vfs_inode.i_flags;
+
+	ei->i_flags &= ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
+			EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|EXT4_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		ei->i_flags |= EXT4_SYNC_FL;
+	if (flags & S_APPEND)
+		ei->i_flags |= EXT4_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ei->i_flags |= EXT4_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ei->i_flags |= EXT4_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		ei->i_flags |= EXT4_DIRSYNC_FL;
+}
+
 void ext4_read_inode(struct inode * inode)
 {
 	struct ext4_iloc iloc;
@@ -2773,6 +2792,7 @@ static int ext4_do_update_inode(handle_t
 	if (ei->i_state & EXT4_STATE_NEW)
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
+	ext4_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
diff -puN fs/ext4/ioctl.c~ext4-copy-i_flags-to-inode-flags-on-write fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~ext4-copy-i_flags-to-inode-flags-on-write
+++ a/fs/ext4/ioctl.c
@@ -29,6 +29,7 @@ int ext4_ioctl (struct inode * inode, st
 
 	switch (cmd) {
 	case EXT4_IOC_GETFLAGS:
+ 		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
diff -puN include/linux/ext4_fs.h~ext4-copy-i_flags-to-inode-flags-on-write include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~ext4-copy-i_flags-to-inode-flags-on-write
+++ a/include/linux/ext4_fs.h
@@ -948,6 +948,7 @@ extern int ext4_change_inode_journal_fla
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern void ext4_truncate (struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
+extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
_

Patches currently in -mm which might be from jack@suse.cz are
