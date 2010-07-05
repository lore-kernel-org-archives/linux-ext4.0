From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Mon, 05 Jul 2010 16:43:19 +0100
Message-ID: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Howells <dhowells@redhat.com>
To: viro@ZenIV.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0GEPnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 11:43:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rearrange the constituent bits of i_flags to be consistent with the flag values
returned by the FS_IOC_GETFLAGS ioctl where flags with common meanings occur.
Otherwise pack the bits of i_flags as low as possible so that RISC CPUs can
use small instructions.

This allows those filesystems that use i_flags (Ext2/3/4) to simplify their
get/set flags routines.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext2/inode.c    |   33 ++++++---------------------------
 fs/ext3/inode.c    |   31 +++++--------------------------
 fs/ext4/inode.c    |   32 +++++---------------------------
 include/linux/fs.h |   30 ++++++++++++++++++------------
 4 files changed, 34 insertions(+), 92 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 3675088..da5fd2d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1259,38 +1259,17 @@ Egdp:
 
 void ext2_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT2_I(inode)->i_flags;
-
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (flags & EXT2_SYNC_FL)
-		inode->i_flags |= S_SYNC;
-	if (flags & EXT2_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	if (flags & EXT2_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	if (flags & EXT2_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
-	if (flags & EXT2_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+	unsigned int flags = EXT2_I(inode)->i_flags & S_FS_IOC_FLAGS;
+
+	inode->i_flags = (inode->i_flags & ~S_FS_IOC_FLAGS) | flags;
 }
 
 /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
 void ext2_get_inode_flags(struct ext2_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
-
-	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
-			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT2_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT2_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT2_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT2_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT2_DIRSYNC_FL;
+	unsigned int flags = ei->vfs_inode.i_flags & S_FS_IOC_FLAGS;
+
+	ei->i_flags = (ei->i_flags & ~S_FS_IOC_FLAGS) | flags;
 }
 
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 735f019..4a1e45e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2737,38 +2737,17 @@ int ext3_get_inode_loc(struct inode *inode, struct ext3_iloc *iloc)
 
 void ext3_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT3_I(inode)->i_flags;
+	unsigned int flags = EXT3_I(inode)->i_flags & S_FS_IOC_FLAGS;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (flags & EXT3_SYNC_FL)
-		inode->i_flags |= S_SYNC;
-	if (flags & EXT3_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	if (flags & EXT3_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	if (flags & EXT3_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
-	if (flags & EXT3_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+	inode->i_flags = (inode->i_flags & ~S_FS_IOC_FLAGS) | flags;
 }
 
 /* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
 void ext3_get_inode_flags(struct ext3_inode_info *ei)
 {
-	unsigned int flags = ei->vfs_inode.i_flags;
-
-	ei->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
-			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT3_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT3_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT3_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT3_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT3_DIRSYNC_FL;
+	unsigned int flags = ei->vfs_inode.i_flags & S_FS_IOC_FLAGS;
+
+	ei->i_flags = (ei->i_flags & ~S_FS_IOC_FLAGS) | flags;
 }
 
 struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index efa17d6..63a5da7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4924,19 +4924,9 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 
 void ext4_set_inode_flags(struct inode *inode)
 {
-	unsigned int flags = EXT4_I(inode)->i_flags;
-
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
-	if (flags & EXT4_SYNC_FL)
-		inode->i_flags |= S_SYNC;
-	if (flags & EXT4_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	if (flags & EXT4_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	if (flags & EXT4_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
-	if (flags & EXT4_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+	unsigned int flags = EXT4_I(inode)->i_flags & S_FS_IOC_FLAGS;
+
+	inode->i_flags = (inode->i_flags & ~S_FS_IOC_FLAGS) | flags;
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
@@ -4946,21 +4936,9 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
 	unsigned long old_fl, new_fl;
 
 	do {
-		vfs_fl = ei->vfs_inode.i_flags;
+		vfs_fl = ei->vfs_inode.i_flags & S_FS_IOC_FLAGS;
 		old_fl = ei->i_flags;
-		new_fl = old_fl & ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-				EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|
-				EXT4_DIRSYNC_FL);
-		if (vfs_fl & S_SYNC)
-			new_fl |= EXT4_SYNC_FL;
-		if (vfs_fl & S_APPEND)
-			new_fl |= EXT4_APPEND_FL;
-		if (vfs_fl & S_IMMUTABLE)
-			new_fl |= EXT4_IMMUTABLE_FL;
-		if (vfs_fl & S_NOATIME)
-			new_fl |= EXT4_NOATIME_FL;
-		if (vfs_fl & S_DIRSYNC)
-			new_fl |= EXT4_DIRSYNC_FL;
+		new_fl = (old_fl & ~S_FS_IOC_FLAGS) | vfs_fl;
 	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48616db..5808b9b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -223,18 +223,24 @@ struct inodes_stat_t {
 #define MS_MGC_VAL 0xC0ED0000
 #define MS_MGC_MSK 0xffff0000
 
-/* Inode flags - they have nothing to superblock flags now */
-
-#define S_SYNC		1	/* Writes are synced at once */
-#define S_NOATIME	2	/* Do not update access times */
-#define S_APPEND	4	/* Append-only file */
-#define S_IMMUTABLE	8	/* Immutable file */
-#define S_DEAD		16	/* removed, but still open directory */
-#define S_NOQUOTA	32	/* Inode is not counted to quota */
-#define S_DIRSYNC	64	/* Directory modifications are synchronous */
-#define S_NOCMTIME	128	/* Do not update file c/mtime */
-#define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
-#define S_PRIVATE	512	/* Inode is fs-internal */
+/*
+ * Inode flags - they have no relation to superblock flags now
+ *
+ * Where applicable, flags that are also in FS_IOC_GETFLAGS have the same bit
+ * position
+ */
+#define S_DEAD		0x00000001	/* removed, but still open directory */
+#define S_NOQUOTA	0x00000002	/* Inode is not counted to quota */
+#define S_NOCMTIME	0x00000004	/* Do not update file c/mtime */
+#define S_SYNC		0x00000008	/* [FS_SYNC_FL] Writes are synced at once */
+#define S_IMMUTABLE	0x00000010	/* [FS_IMMUTABLE_FL] Immutable file */
+#define S_APPEND	0x00000020	/* [FS_APPEND_FL] Append-only file */
+#define S_SWAPFILE	0x00000040	/* Do not truncate: swapon got its bmaps */
+#define S_NOATIME	0x00000080	/* [FS_NOATIME_FL] Do not update access times */
+#define S_PRIVATE	0x00000100	/* Inode is fs-internal */
+#define S_DIRSYNC	0x00010000	/* [FS_DIRSYNC_FL] Directory mods are synchronous */
+
+#define S_FS_IOC_FLAGS	0x000100B8	/* the S_xxx flags that are also FS_xxx_FL flags */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system

