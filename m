From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] resize2fs: add support for resizing filesystems with ea_inode feature
Date: Fri, 14 Jul 2017 17:38:49 -0700
Message-ID: <20170715003849.1982-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33042 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdGOAiy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jul 2017 20:38:54 -0400
Received: by mail-pf0-f174.google.com with SMTP id e7so52324857pfk.0
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jul 2017 17:38:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resizing filesystems with ea_inode feature was disallowed so far
because the code for updating the ea entries was missing. This patch
adds that support.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 lib/ext2fs/ext2_err.et.in |   3 -
 resize/resize2fs.c        | 167 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 157 insertions(+), 13 deletions(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index c5a9ffcc420c..ac96964d93d0 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -542,7 +542,4 @@ ec	EXT2_ET_CORRUPT_JOURNAL_SB,
 ec	EXT2_ET_INODE_CORRUPTED,
 	"Inode is corrupted"
 
-ec	EXT2_ET_CANNOT_MOVE_EA_INODE,
-	"Cannot move extended attribute inode"
-
 	end
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index a54564f08ae5..20a0c463e411 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1986,6 +1986,145 @@ static void quiet_com_err_proc(const char *whoami EXT2FS_ATTR((unused)),
 {
 }
 
+static int fix_ea_entries(ext2_extent imap, struct ext2_ext_attr_entry *entry,
+			  struct ext2_ext_attr_entry *end, ext2_ino_t last_ino)
+{
+	int modified = 0;
+	ext2_ino_t new_ino;
+	errcode_t retval;
+
+	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_inum > last_ino) {
+			new_ino = ext2fs_extent_translate(imap,
+							  entry->e_value_inum);
+			entry->e_value_inum = new_ino;
+			modified = 1;
+		}
+		entry = EXT2_EXT_ATTR_NEXT(entry);
+	}
+	return modified;
+}
+
+static int fix_ea_ibody_entries(ext2_extent imap,
+				struct ext2_inode_large *inode, int inode_size,
+				ext2_ino_t last_ino)
+{
+	struct ext2_ext_attr_entry *start, *end;
+	__u32 *ea_magic;
+
+	if (inode->i_extra_isize == 0)
+		return 0;
+
+	ea_magic = (__u32 *)((char *)inode + EXT2_GOOD_OLD_INODE_SIZE +
+				inode->i_extra_isize);
+	if (*ea_magic != EXT2_EXT_ATTR_MAGIC)
+		return 0;
+
+	start = (struct ext2_ext_attr_entry *)(ea_magic + 1);
+	end = (struct ext2_ext_attr_entry *)((char *)inode + inode_size);
+
+	return fix_ea_entries(imap, start, end, last_ino);
+}
+
+static int fix_ea_block_entries(ext2_extent imap, char *block_buf,
+				unsigned int blocksize, ext2_ino_t last_ino)
+{
+	struct ext2_ext_attr_header *header;
+	struct ext2_ext_attr_entry *start, *end;
+
+	header = (struct ext2_ext_attr_header *)block_buf;
+	start = (struct ext2_ext_attr_entry *)(header+1);
+	end = (struct ext2_ext_attr_entry *)(block_buf + blocksize);
+
+	return fix_ea_entries(imap, start, end, last_ino);
+}
+
+/* A simple LRU cache to check recently processed blocks. */
+struct blk_cache {
+	int cursor;
+	blk64_t blks[4];
+};
+
+#define BLK_IN_CACHE(b,c) ((b) == (c).blks[0] || (b) == (c).blks[1] || \
+			   (b) == (c).blks[2] || (b) == (c).blks[3])
+#define BLK_ADD_CACHE(b,c) { 			\
+	(c).blks[(c).cursor] = (b);		\
+	(c).cursor = ((c).cursor + 1) % 4;	\
+}
+
+static errcode_t fix_ea_inode_refs(ext2_resize_t rfs, struct ext2_inode *inode,
+				   char *block_buf, ext2_ino_t last_ino)
+{
+	ext2_filsys	fs = rfs->new_fs;
+	ext2_inode_scan	scan = NULL;
+	ext2_ino_t	ino;
+	int		inode_size = EXT2_INODE_SIZE(fs->super);
+	blk64_t		blk;
+	int		modified;
+	struct blk_cache blk_cache = { 0 };
+	struct ext2_ext_attr_header *header;
+	errcode_t		retval;
+
+	header = (struct ext2_ext_attr_header *)block_buf;
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto out;
+
+	while (1) {
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode,
+						    inode_size);
+		if (retval)
+			goto out;
+		if (!ino)
+			break;
+
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
+			continue; /* inode not in use */
+
+		if (inode_size != EXT2_GOOD_OLD_INODE_SIZE) {
+			modified = fix_ea_ibody_entries(rfs->imap,
+					(struct ext2_inode_large *)inode,
+					inode_size, last_ino);
+			if (modified) {
+				retval = ext2fs_write_inode_full(fs, ino, inode,
+								 inode_size);
+				if (retval)
+					goto out;
+			}
+		}
+
+		blk = ext2fs_file_acl_block(fs, inode);
+		if (blk && !BLK_IN_CACHE(blk, blk_cache)) {
+			retval = ext2fs_read_ext_attr3(fs, blk, block_buf, ino);
+			if (retval)
+				goto out;
+
+			modified = fix_ea_block_entries(rfs->imap, block_buf,
+							fs->blocksize,
+							last_ino);
+			if (modified) {
+				retval = ext2fs_write_ext_attr3(fs, blk,
+								block_buf, ino);
+				if (retval)
+					goto out;
+				/*
+				 * If refcount is greater than 1, we might see
+				 * the same block referenced by other inodes
+				 * later.
+				 */
+				if (header->h_refcount > 1)
+					BLK_ADD_CACHE(blk, blk_cache);
+			}
+		}
+	}
+	retval = 0;
+out:
+	if (scan)
+		ext2fs_close_inode_scan(scan);
+	return retval;
+
+}
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 {
 	struct process_block_struct	pb;
@@ -1996,6 +2135,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	char			*block_buf = 0;
 	ext2_ino_t		start_to_move;
 	int			inode_size;
+	int			update_ea_inode_refs = 0;
 
 	if ((rfs->old_fs->group_desc_count <=
 	     rfs->new_fs->group_desc_count) &&
@@ -2057,15 +2197,6 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		if (ino <= start_to_move)
 			goto remap_blocks; /* Don't need to move inode. */
 
-		/*
-		 * Moving an extended attribute inode requires updating all inodes
-		 * that reference it which is a lot more involved.
-		 */
-		if (inode->i_flags & EXT4_EA_INODE_FL) {
-			retval = EXT2_ET_CANNOT_MOVE_EA_INODE;
-			goto errout;
-		}
-
 		/*
 		 * Find a new inode.  Now that extents and directory blocks
 		 * are tied to the inode number through the checksum, we must
@@ -2077,7 +2208,15 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 
 		ext2fs_inode_alloc_stats2(rfs->new_fs, new_inode, +1,
 					  pb.is_dir);
-		inode->i_ctime = time(0);
+		/*
+		 * i_ctime field in xattr inodes contain a portion of the ref
+		 * count, do not overwrite.
+		 */
+		if (inode->i_flags & EXT4_EA_INODE_FL)
+			update_ea_inode_refs = 1;
+		else
+			inode->i_ctime = time(0);
+
 		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
 						inode, inode_size);
 		if (retval)
@@ -2143,6 +2282,14 @@ remap_blocks:
 				goto errout;
 		}
 	}
+
+	if (update_ea_inode_refs &&
+	    ext2fs_has_feature_ea_inode(rfs->new_fs->super)) {
+		retval = fix_ea_inode_refs(rfs, inode, block_buf,
+					   start_to_move);
+		if (retval)
+			goto errout;
+	}
 	io_channel_flush(rfs->old_fs->io);
 
 errout:
-- 
2.13.2.932.g7449e964c-goog
