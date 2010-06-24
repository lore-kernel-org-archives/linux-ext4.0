From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Store basic fs error information in the superblock
Date: Wed, 23 Jun 2010 23:21:54 -0400
Message-ID: <1277349714-9697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34972 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab0FXDV5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 23:21:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide better RAS serviceability by stashing some basic file system
error information in the ext4 superblock.

This can help provide better hints as to what might have happened to a
file system that contains errors when, for whatever reason,
/var/log/messages or /var/log/kmsgs is not available.  Perhaps the
hard drive got detached from computer containing the logs; perhaps the
file system error was from long enough ago that the /var/log/messages
information is no longer available or perhaps the user simply didn't
bother to send them along.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/block_validity.c |    8 ++-
 fs/ext4/dir.c            |    8 ++-
 fs/ext4/ext4.h           |   64 +++++++++++++++++--------
 fs/ext4/ext4_jbd2.c      |   50 ++++++++++---------
 fs/ext4/ext4_jbd2.h      |   47 ++++++++++---------
 fs/ext4/extents.c        |   10 ++--
 fs/ext4/inode.c          |   21 +++++---
 fs/ext4/mballoc.c        |   15 +++---
 fs/ext4/move_extent.c    |   10 ++--
 fs/ext4/namei.c          |   14 +++--
 fs/ext4/super.c          |  117 +++++++++++++++++++++++++++++----------------
 11 files changed, 218 insertions(+), 146 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 5b6973f..d587dae 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -229,16 +229,20 @@ int ext4_data_block_valid(struct ext4_sb_info *sbi, ext4_fsblk_t start_blk,
 
 	if ((start_blk <= le32_to_cpu(sbi->s_es->s_first_data_block)) ||
 	    (start_blk + count < start_blk) ||
-	    (start_blk + count > ext4_blocks_count(sbi->s_es)))
+	    (start_blk + count > ext4_blocks_count(sbi->s_es))) {
+		sbi->s_es->s_error_block = cpu_to_le64(start_blk);
 		return 0;
+	}
 	while (n) {
 		entry = rb_entry(n, struct ext4_system_zone, node);
 		if (start_blk + count - 1 < entry->start_blk)
 			n = n->rb_left;
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
-		else
+		else {
+			sbi->s_es->s_error_block = cpu_to_le64(start_blk);
 			return 0;
+		}
 	}
 	return 1;
 }
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 2965c39..8c929ce 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -61,7 +61,8 @@ static unsigned char get_dtype(struct super_block *sb, int filetype)
 }
 
 
-int ext4_check_dir_entry(const char *function, struct inode *dir,
+int ext4_check_dir_entry(const char *function, unsigned int line,
+			 struct inode *dir,
 			 struct ext4_dir_entry_2 *de,
 			 struct buffer_head *bh,
 			 unsigned int offset)
@@ -83,7 +84,7 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 		error_msg = "inode out of bounds";
 
 	if (error_msg != NULL)
-		ext4_error_inode(function, dir,
+		ext4_error_inode(function, line, dir,
 			"bad entry in directory: %s - block=%llu"
 			"offset=%u(%u), inode=%u, rec_len=%d, name_len=%d",
 			error_msg, (unsigned long long) bh->b_blocknr,
@@ -194,7 +195,8 @@ revalidate:
 		while (!error && filp->f_pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
-			if (!ext4_check_dir_entry("ext4_readdir", inode, de,
+			if (!ext4_check_dir_entry(__func__, __LINE__,
+						  inode, de,
 						  bh, offset)) {
 				/*
 				 * On error, skip the f_pos to the next block
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8b6d297..f51d961 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -57,10 +57,10 @@
 #endif
 
 #define EXT4_ERROR_INODE(inode, fmt, a...) \
-	ext4_error_inode(__func__, (inode), (fmt), ## a)
+	ext4_error_inode(__func__, __LINE__, (inode), (fmt), ## a)
 
 #define EXT4_ERROR_FILE(file, fmt, a...)	\
-	ext4_error_file(__func__, (file), (fmt), ## a)
+	ext4_error_file(__func__, __LINE__, (file), (fmt), ## a)
 
 /* data type for block offset of block group */
 typedef int ext4_grpblk_t;
@@ -1002,7 +1002,19 @@ struct ext4_super_block {
 	__u8	s_reserved_char_pad2;
 	__le16  s_reserved_pad;
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
-	__u32   s_reserved[160];        /* Padding to the end of the block */
+	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
+	__le32	s_snapshot_id;		/* sequential ID of active snapshot */
+	__le64	s_snapshot_r_blocks_count; /* reserved blocks for active
+					      snapshot's future use */
+	__le32	s_snapshot_list;	/* inode number of the head of the on-disk snapshot list */
+	__le32	s_first_error_time;	/* first time an error happened */
+	__le32	s_last_error_time;	/* most recent time of an error */
+	__le32	s_error_ino;		/* inode involved in last error */
+	__le64	s_error_block;		/* block involved of last error */
+	__le32	s_error_count;		/* number of fs errors */
+	char	s_error_func[32];	/* function where the error happened */
+	__le32	s_error_line;		/* line number where error happened */
+	__le32   s_reserved[140];        /* Padding to the end of the block */
 };
 
 #ifdef __KERNEL__
@@ -1509,7 +1521,7 @@ extern unsigned ext4_init_block_bitmap(struct super_block *sb,
 		ext4_init_block_bitmap(sb, NULL, group, desc)
 
 /* dir.c */
-extern int ext4_check_dir_entry(const char *, struct inode *,
+extern int ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 				struct ext4_dir_entry_2 *,
 				struct buffer_head *, unsigned int);
 extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
@@ -1615,25 +1627,35 @@ extern int ext4_group_extend(struct super_block *sb,
 				ext4_fsblk_t n_blocks_count);
 
 /* super.c */
-extern void __ext4_error(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-#define ext4_error(sb, message...)	__ext4_error(sb, __func__, ## message)
-extern void ext4_error_inode(const char *, struct inode *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void ext4_error_file(const char *, struct file *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void __ext4_std_error(struct super_block *, const char *, int);
-extern void ext4_abort(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void __ext4_warning(struct super_block *, const char *,
+extern void __ext4_error(struct super_block *, const char *, unsigned int, const char *, ...)
+	__attribute__ ((format (printf, 4, 5)));
+#define ext4_error(sb, message...)	__ext4_error(sb, __func__, __LINE__, ## message)
+extern void ext4_error_inode(const char *, unsigned int, struct inode *,
+			     const char *, ...)
+	__attribute__ ((format (printf, 4, 5)));
+extern void ext4_error_file(const char *, unsigned int, struct file *,
+			    const char *, ...)
+	__attribute__ ((format (printf, 4, 5)));
+extern void __ext4_std_error(struct super_block *, const char *,
+			     unsigned int, int);
+extern void __ext4_abort(struct super_block *, const char *, unsigned int,
+		       const char *, ...)
+	__attribute__ ((format (printf, 4, 5)));
+#define ext4_abort(sb, message...)	__ext4_abort(sb, __func__, \
+						       __LINE__, ## message)
+extern void __ext4_warning(struct super_block *, const char *, unsigned int,
 			  const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-#define ext4_warning(sb, message...)	__ext4_warning(sb, __func__, ## message)
+	__attribute__ ((format (printf, 4, 5)));
+#define ext4_warning(sb, message...)	__ext4_warning(sb, __func__, \
+						       __LINE__, ## message)
 extern void ext4_msg(struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
-extern void ext4_grp_locked_error(struct super_block *, ext4_group_t,
-				const char *, const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
+extern void __ext4_grp_locked_error(const char *, unsigned int, \
+				    struct super_block *, ext4_group_t, \
+				    const char *, ...)
+	__attribute__ ((format (printf, 5, 6)));
+#define ext4_grp_locked_error(sb, grp, message...) \
+	__ext4_grp_locked_error(__func__, __LINE__, (sb), (grp), ## message)
 extern void ext4_update_dynamic_rev(struct super_block *sb);
 extern int ext4_update_compat_feature(handle_t *handle, struct super_block *sb,
 					__u32 compat);
@@ -1767,7 +1789,7 @@ static inline unsigned int ext4_flex_bg_size(struct ext4_sb_info *sbi)
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
-		__ext4_std_error((sb), __func__, (errno));	\
+		__ext4_std_error((sb), __func__, __LINE__, (errno));	\
 } while (0)
 
 #ifdef CONFIG_SMP
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index cfd27b3..93b83e8 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -6,29 +6,29 @@
 
 #include <trace/events/ext4.h>
 
-int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+int __ext4_journal_get_undo_access(const char *where, unsigned int line,
+				   handle_t *handle, struct buffer_head *bh)
 {
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_undo_access(handle, bh);
 		if (err)
-			ext4_journal_abort_handle(where, __func__, bh,
+			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
 	}
 	return err;
 }
 
-int __ext4_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+int __ext4_journal_get_write_access(const char *where, unsigned int line,
+				    handle_t *handle, struct buffer_head *bh)
 {
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_write_access(handle, bh);
 		if (err)
-			ext4_journal_abort_handle(where, __func__, bh,
+			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
 	}
 	return err;
@@ -46,9 +46,9 @@ int __ext4_journal_get_write_access(const char *where, handle_t *handle,
  * If the handle isn't valid we're not journaling, but we still need to
  * call into ext4_journal_revoke() to put the buffer head.
  */
-int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
-		  struct inode *inode, struct buffer_head *bh,
-		  ext4_fsblk_t blocknr)
+int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
+		  int is_metadata, struct inode *inode,
+		  struct buffer_head *bh, ext4_fsblk_t blocknr)
 {
 	int err;
 
@@ -79,8 +79,8 @@ int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
 			BUFFER_TRACE(bh, "call jbd2_journal_forget");
 			err = jbd2_journal_forget(handle, bh);
 			if (err)
-				ext4_journal_abort_handle(where, __func__, bh,
-							  handle, err);
+				ext4_journal_abort_handle(where, line, __func__,
+							  bh, handle, err);
 			return err;
 		}
 		return 0;
@@ -92,15 +92,16 @@ int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
 	BUFFER_TRACE(bh, "call jbd2_journal_revoke");
 	err = jbd2_journal_revoke(handle, blocknr, bh);
 	if (err) {
-		ext4_journal_abort_handle(where, __func__, bh, handle, err);
-		ext4_abort(inode->i_sb, __func__,
+		ext4_journal_abort_handle(where, line, __func__, 
+					  bh, handle, err);
+		__ext4_abort(inode->i_sb, where, line,
 			   "error %d when attempting revoke", err);
 	}
 	BUFFER_TRACE(bh, "exit");
 	return err;
 }
 
-int __ext4_journal_get_create_access(const char *where,
+int __ext4_journal_get_create_access(const char *where, unsigned int line,
 				handle_t *handle, struct buffer_head *bh)
 {
 	int err = 0;
@@ -108,22 +109,23 @@ int __ext4_journal_get_create_access(const char *where,
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_create_access(handle, bh);
 		if (err)
-			ext4_journal_abort_handle(where, __func__, bh,
-						  handle, err);
+			ext4_journal_abort_handle(where, line, __func__,
+						  bh, handle, err);
 	}
 	return err;
 }
 
-int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
-				 struct inode *inode, struct buffer_head *bh)
+int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
+				 handle_t *handle, struct inode *inode,
+				 struct buffer_head *bh)
 {
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
-			ext4_journal_abort_handle(where, __func__, bh,
-						  handle, err);
+			ext4_journal_abort_handle(where, line,__func__,
+						  bh, handle, err);
 	} else {
 		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
@@ -144,8 +146,8 @@ int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
 	return err;
 }
 
-int __ext4_handle_dirty_super(const char *where, handle_t *handle,
-			      struct super_block *sb)
+int __ext4_handle_dirty_super(const char *where, unsigned int line,
+			      handle_t *handle, struct super_block *sb)
 {
 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
 	int err = 0;
@@ -153,8 +155,8 @@ int __ext4_handle_dirty_super(const char *where, handle_t *handle,
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
-			ext4_journal_abort_handle(where, __func__, bh,
-						  handle, err);
+			ext4_journal_abort_handle(where, line, __func__, 
+						  bh, handle, err);
 	} else
 		sb->s_dirt = 1;
 	return err;
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 38d1e66..b0bd792 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -122,44 +122,47 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode);
 /*
  * Wrapper functions with which ext4 calls into JBD.
  */
-void ext4_journal_abort_handle(const char *caller, const char *err_fn,
+void ext4_journal_abort_handle(const char *caller, unsigned int line,
+			       const char *err_fn,
 		struct buffer_head *bh, handle_t *handle, int err);
 
-int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh);
+int __ext4_journal_get_undo_access(const char *where, unsigned int line,
+				   handle_t *handle, struct buffer_head *bh);
 
-int __ext4_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh);
+int __ext4_journal_get_write_access(const char *where, unsigned int line,
+				    handle_t *handle, struct buffer_head *bh);
 
-int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
-		  struct inode *inode, struct buffer_head *bh,
-		  ext4_fsblk_t blocknr);
+int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
+		  int is_metadata, struct inode *inode,
+		  struct buffer_head *bh, ext4_fsblk_t blocknr);
 
-int __ext4_journal_get_create_access(const char *where,
+int __ext4_journal_get_create_access(const char *where, unsigned int line,
 				handle_t *handle, struct buffer_head *bh);
 
-int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
-				 struct inode *inode, struct buffer_head *bh);
+int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
+				 handle_t *handle, struct inode *inode,
+				 struct buffer_head *bh);
 
-int __ext4_handle_dirty_super(const char *where, handle_t *handle,
-			      struct super_block *sb);
+int __ext4_handle_dirty_super(const char *where, unsigned int line,
+			      handle_t *handle, struct super_block *sb);
 
 #define ext4_journal_get_undo_access(handle, bh) \
-	__ext4_journal_get_undo_access(__func__, (handle), (bh))
+	__ext4_journal_get_undo_access(__func__, __LINE__, (handle), (bh))
 #define ext4_journal_get_write_access(handle, bh) \
-	__ext4_journal_get_write_access(__func__, (handle), (bh))
+	__ext4_journal_get_write_access(__func__, __LINE__, (handle), (bh))
 #define ext4_forget(handle, is_metadata, inode, bh, block_nr) \
-	__ext4_forget(__func__, (handle), (is_metadata), (inode), (bh),\
-		      (block_nr))
+	__ext4_forget(__func__, __LINE__, (handle), (is_metadata), (inode), \
+		      (bh), (block_nr))
 #define ext4_journal_get_create_access(handle, bh) \
-	__ext4_journal_get_create_access(__func__, (handle), (bh))
+	__ext4_journal_get_create_access(__func__, __LINE__, (handle), (bh))
 #define ext4_handle_dirty_metadata(handle, inode, bh) \
-	__ext4_handle_dirty_metadata(__func__, (handle), (inode), (bh))
+	__ext4_handle_dirty_metadata(__func__, __LINE__, (handle), (inode), \
+				     (bh))
 #define ext4_handle_dirty_super(handle, sb) \
-	__ext4_handle_dirty_super(__func__, (handle), (sb))
+	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
-int __ext4_journal_stop(const char *where, handle_t *handle);
+int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
 
 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
 
@@ -212,7 +215,7 @@ static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
 }
 
 #define ext4_journal_stop(handle) \
-	__ext4_journal_stop(__func__, (handle))
+	__ext4_journal_stop(__func__, __LINE__, (handle))
 
 static inline handle_t *ext4_journal_current_handle(void)
 {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 346de3d..fac5516 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -401,9 +401,9 @@ static int ext4_valid_extent_entries(struct inode *inode,
 	return 1;
 }
 
-static int __ext4_ext_check(const char *function, struct inode *inode,
-					struct ext4_extent_header *eh,
-					int depth)
+static int __ext4_ext_check(const char *function, unsigned int line,
+			    struct inode *inode, struct ext4_extent_header *eh,
+			    int depth)
 {
 	const char *error_msg;
 	int max = 0;
@@ -436,7 +436,7 @@ static int __ext4_ext_check(const char *function, struct inode *inode,
 	return 0;
 
 corrupted:
-	ext4_error_inode(function, inode,
+	ext4_error_inode(function, line, inode,
 			"bad header/extent: %s - magic %x, "
 			"entries %u, max %u(%u), depth %u(%u)",
 			error_msg, le16_to_cpu(eh->eh_magic),
@@ -447,7 +447,7 @@ corrupted:
 }
 
 #define ext4_ext_check(inode, eh, depth)	\
-	__ext4_ext_check(__func__, inode, eh, depth)
+	__ext4_ext_check(__func__, __LINE__, inode, eh, depth)
 
 int ext4_ext_check_inode(struct inode *inode)
 {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b485987..aade5e4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -337,9 +337,11 @@ static int ext4_block_to_path(struct inode *inode,
 	return n;
 }
 
-static int __ext4_check_blockref(const char *function, struct inode *inode,
+static int __ext4_check_blockref(const char *function, unsigned int line,
+				 struct inode *inode,
 				 __le32 *p, unsigned int max)
 {
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 	__le32 *bref = p;
 	unsigned int blk;
 
@@ -348,7 +350,8 @@ static int __ext4_check_blockref(const char *function, struct inode *inode,
 		if (blk &&
 		    unlikely(!ext4_data_block_valid(EXT4_SB(inode->i_sb),
 						    blk, 1))) {
-			ext4_error_inode(function, inode,
+			es->s_error_block = cpu_to_le64(blk);
+			ext4_error_inode(function, line, inode,
 					 "invalid block reference %u", blk);
 			return -EIO;
 		}
@@ -358,11 +361,13 @@ static int __ext4_check_blockref(const char *function, struct inode *inode,
 
 
 #define ext4_check_indirect_blockref(inode, bh)                         \
-	__ext4_check_blockref(__func__, inode, (__le32 *)(bh)->b_data,  \
+	__ext4_check_blockref(__func__, __LINE__, inode,		\
+			      (__le32 *)(bh)->b_data,			\
 			      EXT4_ADDR_PER_BLOCK((inode)->i_sb))
 
 #define ext4_check_inode_blockref(inode)                                \
-	__ext4_check_blockref(__func__, inode, EXT4_I(inode)->i_data,   \
+	__ext4_check_blockref(__func__, __LINE__, inode,		\
+			      EXT4_I(inode)->i_data,			\
 			      EXT4_NDIR_BLOCKS)
 
 /**
@@ -1129,11 +1134,12 @@ void ext4_da_update_reserve_space(struct inode *inode,
 }
 
 static int check_block_validity(struct inode *inode, const char *func,
+				unsigned int line,
 				struct ext4_map_blocks *map)
 {
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
 				   map->m_len)) {
-		ext4_error_inode(func, inode,
+		ext4_error_inode(func, line, inode,
 			   "lblock %lu mapped to illegal pblock %llu "
 			   "(length %d)", (unsigned long) map->m_lblk,
 				 map->m_pblk, map->m_len);
@@ -1244,7 +1250,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	up_read((&EXT4_I(inode)->i_data_sem));
 
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
-		int ret = check_block_validity(inode, __func__, map);
+		int ret = check_block_validity(inode, __func__, __LINE__, map);
 		if (ret != 0)
 			return ret;
 	}
@@ -1324,8 +1330,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 
 	up_write((&EXT4_I(inode)->i_data_sem));
 	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
-		int ret = check_block_validity(inode,
-					       "ext4_map_blocks_after_alloc",
+		int ret = check_block_validity(inode, __func__, __LINE__,
 					       map);
 		if (ret != 0)
 			return ret;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b2948b0..92ae5e8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -446,7 +446,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 			blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 			blocknr += first + i;
 			ext4_grp_locked_error(sb, e4b->bd_group,
-				   __func__, "double-free of inode"
+				   "double-free of inode"
 				   " %lu's block %llu(bit %u in group %u)",
 				   inode ? inode->i_ino : 0, blocknr,
 				   first + i, e4b->bd_group);
@@ -712,7 +712,7 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 	grp->bb_fragments = fragments;
 
 	if (free != grp->bb_free) {
-		ext4_grp_locked_error(sb, group,  __func__,
+		ext4_grp_locked_error(sb, group,
 			"EXT4-fs: group %u: %u blocks in bitmap, %u in gd",
 			group, free, grp->bb_free);
 		/*
@@ -1296,7 +1296,7 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 			blocknr += block;
 			ext4_grp_locked_error(sb, e4b->bd_group,
-				   __func__, "double-free of inode"
+				   "double-free of inode"
 				   " %lu's block %llu(bit %u in group %u)",
 				   inode ? inode->i_ino : 0, blocknr, block,
 				   e4b->bd_group);
@@ -1789,7 +1789,7 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			 * we have free blocks
 			 */
 			ext4_grp_locked_error(sb, e4b->bd_group,
-					__func__, "%d free blocks as per "
+					"%d free blocks as per "
 					"group info. But bitmap says 0",
 					free);
 			break;
@@ -1799,7 +1799,7 @@ void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 		BUG_ON(ex.fe_len <= 0);
 		if (free < ex.fe_len) {
 			ext4_grp_locked_error(sb, e4b->bd_group,
-					__func__, "%d free blocks as per "
+					"%d free blocks as per "
 					"group info. But got %d blocks",
 					free, ex.fe_len);
 			/*
@@ -3584,8 +3584,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
 			pa, (unsigned long) pa->pa_lstart,
 			(unsigned long) pa->pa_pstart,
 			(unsigned long) pa->pa_len);
-		ext4_grp_locked_error(sb, group,
-					__func__, "free %u, pa_free %u",
+		ext4_grp_locked_error(sb, group, "free %u, pa_free %u",
 					free, pa->pa_free);
 		/*
 		 * pa is already deleted so we use the value obtained
@@ -4427,7 +4426,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		else if (block >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
 		else {
-			ext4_grp_locked_error(sb, e4b->bd_group, __func__,
+			ext4_grp_locked_error(sb, e4b->bd_group,
 					"Double free of blocks %d (%d %d)",
 					block, entry->start_blk, entry->count);
 			return 0;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 52abfa1..5f1ed9f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -148,17 +148,17 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
  */
 static int
 mext_check_null_inode(struct inode *inode1, struct inode *inode2,
-		const char *function)
+		      const char *function, unsigned int line)
 {
 	int ret = 0;
 
 	if (inode1 == NULL) {
-		__ext4_error(inode2->i_sb, function,
+		__ext4_error(inode2->i_sb, function, line,
 			"Both inodes should not be NULL: "
 			"inode1 NULL inode2 %lu", inode2->i_ino);
 		ret = -EIO;
 	} else if (inode2 == NULL) {
-		__ext4_error(inode1->i_sb, function,
+		__ext4_error(inode1->i_sb, function, line,
 			"Both inodes should not be NULL: "
 			"inode1 %lu inode2 NULL", inode1->i_ino);
 		ret = -EIO;
@@ -1084,7 +1084,7 @@ mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
 
 	BUG_ON(inode1 == NULL && inode2 == NULL);
 
-	ret = mext_check_null_inode(inode1, inode2, __func__);
+	ret = mext_check_null_inode(inode1, inode2, __func__, __LINE__);
 	if (ret < 0)
 		goto out;
 
@@ -1121,7 +1121,7 @@ mext_inode_double_unlock(struct inode *inode1, struct inode *inode2)
 
 	BUG_ON(inode1 == NULL && inode2 == NULL);
 
-	ret = mext_check_null_inode(inode1, inode2, __func__);
+	ret = mext_check_null_inode(inode1, inode2, __func__, __LINE__);
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a61f77..66b6e1c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -605,7 +605,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 					   dir->i_sb->s_blocksize -
 					   EXT4_DIR_REC_LEN(0));
 	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
-		if (!ext4_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
+		if (!ext4_check_dir_entry(__func__, __LINE__, dir, de, bh,
 					(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
 			/* On error, skip the f_pos to the next block. */
@@ -844,7 +844,7 @@ static inline int search_dirblock(struct buffer_head *bh,
 		if ((char *) de + namelen <= dlimit &&
 		    ext4_match (namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
-			if (!ext4_check_dir_entry("ext4_find_entry",
+			if (!ext4_check_dir_entry(__func__, __LINE__,
 						  dir, de, bh, offset))
 				return -1;
 			*res_dir = de;
@@ -1019,7 +1019,8 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 			int off = (block << EXT4_BLOCK_SIZE_BITS(sb))
 				  + ((char *) de - bh->b_data);
 
-			if (!ext4_check_dir_entry(__func__, dir, de, bh, off)) {
+			if (!ext4_check_dir_entry(__func__, __LINE__, dir,
+						  de, bh, off)) {
 				brelse(bh);
 				*err = ERR_BAD_DX_DIR;
 				goto errout;
@@ -1303,7 +1304,7 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 		de = (struct ext4_dir_entry_2 *)bh->b_data;
 		top = bh->b_data + blocksize - reclen;
 		while ((char *) de <= top) {
-			if (!ext4_check_dir_entry("ext4_add_entry", dir, de,
+			if (!ext4_check_dir_entry(__func__, __LINE__, dir, de,
 						  bh, offset))
 				return -EIO;
 			if (ext4_match(namelen, name, de))
@@ -1671,7 +1672,7 @@ static int ext4_delete_entry(handle_t *handle,
 	pde = NULL;
 	de = (struct ext4_dir_entry_2 *) bh->b_data;
 	while (i < bh->b_size) {
-		if (!ext4_check_dir_entry("ext4_delete_entry", dir, de, bh, i))
+		if (!ext4_check_dir_entry(__func__, __LINE__, dir, de, bh, i))
 			return -EIO;
 		if (de == de_del)  {
 			BUFFER_TRACE(bh, "get_write_access");
@@ -1954,7 +1955,8 @@ static int empty_dir(struct inode *inode)
 			}
 			de = (struct ext4_dir_entry_2 *) bh->b_data;
 		}
-		if (!ext4_check_dir_entry("empty_dir", inode, de, bh, offset)) {
+		if (!ext4_check_dir_entry(__func__, __LINE__, inode,
+					  de, bh, offset)) {
 			de = (struct ext4_dir_entry_2 *)(bh->b_data +
 							 sb->s_blocksize);
 			offset = (offset | (sb->s_blocksize - 1)) + 1;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 422a4ce..0c689fb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -248,7 +248,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
 		if (is_journal_aborted(journal)) {
-			ext4_abort(sb, __func__, "Detected aborted journal");
+			ext4_abort(sb, "Detected aborted journal");
 			return ERR_PTR(-EROFS);
 		}
 		return jbd2_journal_start(journal, nblocks);
@@ -262,7 +262,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
  */
-int __ext4_journal_stop(const char *where, handle_t *handle)
+int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle)
 {
 	struct super_block *sb;
 	int err;
@@ -279,12 +279,13 @@ int __ext4_journal_stop(const char *where, handle_t *handle)
 	if (!err)
 		err = rc;
 	if (err)
-		__ext4_std_error(sb, where, err);
+		__ext4_std_error(sb, where, line, err);
 	return err;
 }
 
-void ext4_journal_abort_handle(const char *caller, const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err)
+void ext4_journal_abort_handle(const char *caller, unsigned int line,
+			       const char *err_fn, struct buffer_head *bh,
+			       handle_t *handle, int err)
 {
 	char nbuf[16];
 	const char *errstr = ext4_decode_error(NULL, err, nbuf);
@@ -300,8 +301,8 @@ void ext4_journal_abort_handle(const char *caller, const char *err_fn,
 	if (is_handle_aborted(handle))
 		return;
 
-	printk(KERN_ERR "%s: aborting transaction: %s in %s\n",
-	       caller, errstr, err_fn);
+	printk(KERN_ERR "%s:%d: aborting transaction: %s in %s\n",
+	       caller, line, errstr, err_fn);
 
 	jbd2_journal_abort_handle(handle);
 }
@@ -327,6 +328,10 @@ static void ext4_handle_error(struct super_block *sb)
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
+	es->s_last_error_time = cpu_to_le32(get_seconds());
+	if (!es->s_first_error_time)
+		es->s_first_error_time = es->s_last_error_time;
+	es->s_error_count = cpu_to_le32(le32_to_cpu(es->s_error_count) + 1);
 
 	if (sb->s_flags & MS_RDONLY)
 		return;
@@ -349,12 +354,16 @@ static void ext4_handle_error(struct super_block *sb)
 }
 
 void __ext4_error(struct super_block *sb, const char *function,
-		const char *fmt, ...)
+		  unsigned int line, const char *fmt, ...)
 {
 	va_list args;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
+	strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+	es->s_error_line = cpu_to_le32(line);
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s: ", sb->s_id, function);
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
+	       function, line);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
@@ -362,14 +371,18 @@ void __ext4_error(struct super_block *sb, const char *function,
 	ext4_handle_error(sb);
 }
 
-void ext4_error_inode(const char *function, struct inode *inode,
-		      const char *fmt, ...)
+void ext4_error_inode(const char *function, unsigned int line,
+		      struct inode *inode, const char *fmt, ...)
 {
 	va_list args;
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 
+	strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+	es->s_error_line = cpu_to_le32(line);
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s: inode #%lu: (comm %s) ",
-	       inode->i_sb->s_id, function, inode->i_ino, current->comm);
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: inode #%lu: "
+	       "(comm %s) ",
+	       inode->i_sb->s_id, function, line, inode->i_ino, current->comm);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
@@ -377,20 +390,26 @@ void ext4_error_inode(const char *function, struct inode *inode,
 	ext4_handle_error(inode->i_sb);
 }
 
-void ext4_error_file(const char *function, struct file *file,
-		     const char *fmt, ...)
+void ext4_error_file(const char *function, unsigned int line,
+		     struct file *file, const char *fmt, ...)
 {
 	va_list args;
+	struct ext4_super_block *es;
 	struct inode *inode = file->f_dentry->d_inode;
 	char pathname[80], *path;
 
+	es = EXT4_SB(inode->i_sb)->s_es;
+	strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+	es->s_error_line = cpu_to_le32(line);
 	va_start(args, fmt);
 	path = d_path(&(file->f_path), pathname, sizeof(pathname));
 	if (!path)
 		path = "(unknown)";
 	printk(KERN_CRIT
-	       "EXT4-fs error (device %s): %s: inode #%lu (comm %s path %s): ",
-	       inode->i_sb->s_id, function, inode->i_ino, current->comm, path);
+	       "EXT4-fs error (device %s): %s:%d: inode #%lu "
+	       "(comm %s path %s): ",
+	       inode->i_sb->s_id, function, line, inode->i_ino,
+	       current->comm, path);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
@@ -435,10 +454,12 @@ static const char *ext4_decode_error(struct super_block *sb, int errno,
 /* __ext4_std_error decodes expected errors from journaling functions
  * automatically and invokes the appropriate error response.  */
 
-void __ext4_std_error(struct super_block *sb, const char *function, int errno)
+void __ext4_std_error(struct super_block *sb, const char *function,
+		      unsigned int line, int errno)
 {
 	char nbuf[16];
 	const char *errstr;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
 	/* Special case: if the error is EROFS, and we're not already
 	 * inside a transaction, then there's really no point in logging
@@ -448,8 +469,10 @@ void __ext4_std_error(struct super_block *sb, const char *function, int errno)
 		return;
 
 	errstr = ext4_decode_error(sb, errno, nbuf);
-	printk(KERN_CRIT "EXT4-fs error (device %s) in %s: %s\n",
-	       sb->s_id, function, errstr);
+	printk(KERN_CRIT "EXT4-fs error (device %s) in %s:%d: %s\n",
+	       sb->s_id, function, line, errstr);
+	strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+	es->s_error_line = cpu_to_le32(line);
 
 	ext4_handle_error(sb);
 }
@@ -464,29 +487,32 @@ void __ext4_std_error(struct super_block *sb, const char *function, int errno)
  * case we take the easy way out and panic immediately.
  */
 
-void ext4_abort(struct super_block *sb, const char *function,
-		const char *fmt, ...)
+void __ext4_abort(struct super_block *sb, const char *function,
+		unsigned int line, const char *fmt, ...)
 {
 	va_list args;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s: ", sb->s_id, function);
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
+	       function, line);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
 
+	if ((sb->s_flags & MS_RDONLY) == 0) {
+		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
+		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
+		sb->s_flags |= MS_RDONLY;
+		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+		if (EXT4_SB(sb)->s_journal)
+			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+		strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+		es->s_error_line = cpu_to_le32(line);
+		ext4_commit_super(sb, 1);
+	}
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT4-fs panic from previous error\n");
-
-	if (sb->s_flags & MS_RDONLY)
-		return;
-
-	ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
-	sb->s_flags |= MS_RDONLY;
-	EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
-	if (EXT4_SB(sb)->s_journal)
-		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 }
 
 void ext4_msg (struct super_block * sb, const char *prefix,
@@ -502,20 +528,21 @@ void ext4_msg (struct super_block * sb, const char *prefix,
 }
 
 void __ext4_warning(struct super_block *sb, const char *function,
-		  const char *fmt, ...)
+		    unsigned int line, const char *fmt, ...)
 {
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_WARNING "EXT4-fs warning (device %s): %s: ",
-	       sb->s_id, function);
+	printk(KERN_WARNING "EXT4-fs warning (device %s): %s:%d: ",
+	       sb->s_id, function, line);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
 }
 
-void ext4_grp_locked_error(struct super_block *sb, ext4_group_t grp,
-			   const char *function, const char *fmt, ...)
+void __ext4_grp_locked_error(const char *function, unsigned int line,
+			   struct super_block *sb, ext4_group_t grp,
+			   const char *fmt, ...)
 __releases(bitlock)
 __acquires(bitlock)
 {
@@ -523,14 +550,21 @@ __acquires(bitlock)
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s: ", sb->s_id, function);
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: ", sb->s_id,
+	       function, line);
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+	strncpy(es->s_error_func, function, sizeof(es->s_error_func));
+	es->s_error_line = cpu_to_le32(line);
 
 	if (test_opt(sb, ERRORS_CONT)) {
 		EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
+		es->s_last_error_time = cpu_to_le32(get_seconds());
+		if (!es->s_first_error_time)
+			es->s_first_error_time = es->s_last_error_time;
+		es->s_error_count = cpu_to_le32(le32_to_cpu(es->s_error_count) + 1);
 		ext4_commit_super(sb, 0);
 		return;
 	}
@@ -660,8 +694,7 @@ static void ext4_put_super(struct super_block *sb)
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 		if (err < 0)
-			ext4_abort(sb, __func__,
-				   "Couldn't clean up the journal");
+			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
 	ext4_release_system_zone(sb);
@@ -3605,7 +3638,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
-		ext4_abort(sb, __func__, "Abort forced by user");
+		ext4_abort(sb, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
-- 
1.7.0.4

