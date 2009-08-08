From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 2/2] ext4: Avoid group preallocation for closed files
Date: Sat,  8 Aug 2009 18:52:45 -0400
Message-ID: <1249771965-26611-2-git-send-email-tytso@mit.edu>
References: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59876 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbZHHWwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Aug 2009 18:52:47 -0400
In-Reply-To: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the group preallocation code tries to find a large (512)
free block from which to do per-cpu group allocation for small files.
The problem with this scheme is that it leaves the filesystem horribly
fragmented.  In the worst case, if the filesystem is unmounted and
remounted (after a system shutdown, for example) we forget the fact
that wee were using a particular (now-partially filled) 512 block
extent.  So the next time we try to allocate space for a small file,
we will find *another* completely free 512 block chunk to allocate
small files.  Given that there are 32,768 blocks in a block group,
after 64 iterations of "mount, write one 4k file in a directory,
unmount", the block group will have 64 files, each separated by 511
blocks, and the block group will no longer have any free 512
completely free chunks of blocks for group preallocation space.

So if we try to allocate blocks for a file that has been closed, such
that we know the final size of the file, and the filesystem is not
busy, avoid using group preallocation.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |   24 +++++++++++++++++++++++-
 fs/ext4/mballoc.c |   10 +++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1ca6995..c2d98f8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -90,6 +90,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_DELALLOC_RESERVED      1024
 /* We are doing stream allocation */
 #define EXT4_MB_STREAM_ALLOC	       2048
+/* We suppressed group preallocation */
+#define EXT4_MB_SUPPRESS_GROUP_PREALLOC 4096
 
 
 struct ext4_allocation_request {
@@ -952,6 +954,7 @@ struct ext4_sb_info {
 	atomic_t s_mb_lost_chunks;
 	atomic_t s_mb_preallocated;
 	atomic_t s_mb_discarded;
+	atomic_t s_lock_busy;
 
 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
@@ -1593,15 +1596,34 @@ struct ext4_group_info {
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
 
+#define EXT4_MAX_CONTENTION		8
+#define EXT4_CONTENTION_THRESHOLD	2
+
 static inline spinlock_t *ext4_group_lock_ptr(struct super_block *sb,
 					      ext4_group_t group)
 {
 	return bgl_lock_ptr(EXT4_SB(sb)->s_blockgroup_lock, group);
 }
 
+/*
+ * Returns true if the filesystem is busy enough that attempts to
+ * access the block group locks has run into contention.
+ */
+static inline int ext4_fs_is_busy(struct ext4_sb_info *sbi)
+{
+	return (atomic_read(&sbi->s_lock_busy) > EXT4_CONTENTION_THRESHOLD);
+}
+
 static inline void ext4_lock_group(struct super_block *sb, ext4_group_t group)
 {
-	spin_lock(ext4_group_lock_ptr(sb, group));
+	spinlock_t *lock = ext4_group_lock_ptr(sb, group);
+	if (spin_trylock(lock))
+		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, 1,
+				  EXT4_MAX_CONTENTION);
+	else {
+		atomic_add_unless(&EXT4_SB(sb)->s_lock_busy, -1, 0);
+		spin_lock(lock);
+	}
 }
 
 static inline void ext4_unlock_group(struct super_block *sb,
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index f019a50..482bf40 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4154,9 +4154,17 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 		return;
 
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
-	isize = i_size_read(ac->ac_inode) >> bsbits;
+	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
+		>> bsbits;
 	size = max(size, isize);
 
+	if ((size == isize) &&
+	    ext4_fs_is_busy(sbi) &&
+	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
+		ac->ac_flags |= EXT4_MB_SUPPRESS_GROUP_PREALLOC;
+		return;
+	}
+
 	/* don't use group allocation for large files */
 	if (size >= sbi->s_mb_stream_request) {
 		ac->ac_flags |= EXT4_MB_STREAM_ALLOC;
-- 
1.6.3.2.1.gb9f7d.dirty

