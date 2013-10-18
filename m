From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/25] resize2fs: rewrite extent/dir/ea block checksums when
 migrating
Date: Thu, 17 Oct 2013 21:51:27 -0700
Message-ID: <20131018045127.7339.73804.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3JREvc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:51:32 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the advent of metadata_csum, we now tie extent and directory
blocks to the associated inode number (and generation).  Therefore, we
must be careful when remapping inodes.  At that point in the resize
process, all the blocks that are going away have been duplicated
elsewhere in the FS (albeit with checksums based on the old inode
numbers).  If we're moving the inode, then do that and remember that
new inode number.  Now we can update the block mappings for each inode
with the final inode number, and schedule directory blocks for mass
inode relocation.  We also have to recalculate the EA block checksum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |  154 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 114 insertions(+), 40 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 440c20e..17b8c45 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1733,10 +1733,12 @@ __u64 extent_translate(ext2_filsys fs, ext2_extent extent, __u64 old_loc)
 struct process_block_struct {
 	ext2_resize_t 		rfs;
 	ext2_ino_t		ino;
+	ext2_ino_t		old_ino;
 	struct ext2_inode *	inode;
 	errcode_t		error;
 	int			is_dir;
 	int			changed;
+	int			has_extents;
 };
 
 static int process_block(ext2_filsys fs, blk64_t	*block_nr,
@@ -1760,11 +1762,23 @@ static int process_block(ext2_filsys fs, blk64_t	*block_nr,
 #ifdef RESIZE2FS_DEBUG
 			if (pb->rfs->flags & RESIZE_DEBUG_BMOVE)
 				printf("ino=%u, blockcnt=%lld, %llu->%llu\n",
-				       pb->ino, blockcnt, block, new_block);
+				       pb->old_ino, blockcnt, block,
+				       new_block);
 #endif
 			block = new_block;
 		}
 	}
+
+	/*
+	 * If we moved inodes and metadata_csum is enabled, we must force the
+	 * extent block to be rewritten with new checksum.
+	 */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    pb->has_extents &&
+	    pb->old_ino != pb->ino)
+		ret |= BLOCK_CHANGED;
+
 	if (pb->is_dir) {
 		retval = ext2fs_add_dir_block2(fs->dblist, pb->ino,
 					       block, (int) blockcnt);
@@ -1804,6 +1818,46 @@ static errcode_t progress_callback(ext2_filsys fs,
 	return 0;
 }
 
+static errcode_t migrate_ea_block(ext2_resize_t rfs, ext2_ino_t ino,
+				  struct ext2_inode *inode, int *changed)
+{
+	char *buf;
+	blk64_t new_block;
+	errcode_t err = 0;
+
+	/* No EA block or no remapping?  Quit early. */
+	if (ext2fs_file_acl_block(rfs->old_fs, inode) == 0 && !rfs->bmap)
+		return 0;
+	new_block = extent_translate(rfs->old_fs, rfs->bmap,
+		ext2fs_file_acl_block(rfs->old_fs, inode));
+	if (new_block == 0)
+		return 0;
+
+	/* Set the new ACL block */
+	ext2fs_file_acl_block_set(rfs->old_fs, inode, new_block);
+
+	/* Update checksum */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(rfs->new_fs->super,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		err = ext2fs_get_mem(rfs->old_fs->blocksize, &buf);
+		if (err)
+			return err;
+		rfs->old_fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		err = ext2fs_read_ext_attr3(rfs->old_fs, new_block, buf, ino);
+		rfs->old_fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		if (err)
+			goto out;
+		err = ext2fs_write_ext_attr3(rfs->old_fs, new_block, buf, ino);
+		if (err)
+			goto out;
+	}
+	*changed = 1;
+
+out:
+	ext2fs_free_mem(&buf);
+	return err;
+}
+
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 {
 	struct process_block_struct	pb;
@@ -1814,7 +1868,6 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	char			*block_buf = 0;
 	ext2_ino_t		start_to_move;
 	blk64_t			orig_size;
-	blk64_t			new_block;
 	int			inode_size;
 
 	if ((rfs->old_fs->group_desc_count <=
@@ -1877,37 +1930,19 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 		pb.changed = 0;
 
-		if (ext2fs_file_acl_block(rfs->old_fs, inode) && rfs->bmap) {
-			new_block = extent_translate(rfs->old_fs, rfs->bmap,
-				ext2fs_file_acl_block(rfs->old_fs, inode));
-			if (new_block) {
-				ext2fs_file_acl_block_set(rfs->old_fs, inode,
-							  new_block);
-				retval = ext2fs_write_inode_full(rfs->old_fs,
-							    ino, inode, inode_size);
-				if (retval) goto errout;
-			}
-		}
-
-		if (ext2fs_inode_has_valid_blocks2(rfs->old_fs, inode) &&
-		    (rfs->bmap || pb.is_dir)) {
-			pb.ino = ino;
-			retval = ext2fs_block_iterate3(rfs->old_fs,
-						       ino, 0, block_buf,
-						       process_block, &pb);
-			if (retval)
-				goto errout;
-			if (pb.error) {
-				retval = pb.error;
-				goto errout;
-			}
-		}
+		/* Remap EA block */
+		retval = migrate_ea_block(rfs, ino, inode, &pb.changed);
+		if (retval)
+			goto errout;
 
+		new_inode = ino;
 		if (ino <= start_to_move)
-			continue; /* Don't need to move it. */
+			goto remap_blocks; /* Don't need to move inode. */
 
 		/*
-		 * Find a new inode
+		 * Find a new inode.  Now that extents and directory blocks
+		 * are tied to the inode number through the checksum, we must
+		 * set up the new inode before we start rewriting blocks.
 		 */
 		retval = ext2fs_new_inode(rfs->new_fs, 0, 0, 0, &new_inode);
 		if (retval)
@@ -1915,16 +1950,12 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 
 		ext2fs_inode_alloc_stats2(rfs->new_fs, new_inode, +1,
 					  pb.is_dir);
-		if (pb.changed) {
-			/* Get the new version of the inode */
-			retval = ext2fs_read_inode_full(rfs->old_fs, ino,
-						inode, inode_size);
-			if (retval) goto errout;
-		}
 		inode->i_ctime = time(0);
 		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
 						inode, inode_size);
-		if (retval) goto errout;
+		if (retval)
+			goto errout;
+		pb.changed = 0;
 
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
@@ -1936,6 +1967,37 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 				goto errout;
 		}
 		ext2fs_add_extent_entry(rfs->imap, ino, new_inode);
+
+remap_blocks:
+		if (pb.changed)
+			retval = ext2fs_write_inode_full(rfs->old_fs,
+							 new_inode,
+							 inode, inode_size);
+		if (retval)
+			goto errout;
+
+		/*
+		 * Update inodes to point to new blocks; schedule directory
+		 * blocks for inode remapping.  Need to write out dir blocks
+		 * with new inode numbers if we have metadata_csum enabled.
+		 */
+		if (ext2fs_inode_has_valid_blocks2(rfs->old_fs, inode) &&
+		    (rfs->bmap || pb.is_dir)) {
+			pb.ino = new_inode;
+			pb.old_ino = ino;
+			pb.has_extents = inode->i_flags & EXT4_EXTENTS_FL;
+			rfs->old_fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			retval = ext2fs_block_iterate3(rfs->old_fs,
+						       new_inode, 0, block_buf,
+						       process_block, &pb);
+			rfs->old_fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			if (retval)
+				goto errout;
+			if (pb.error) {
+				retval = pb.error;
+				goto errout;
+			}
+		}
 	}
 	io_channel_flush(rfs->old_fs->io);
 
@@ -1978,6 +2040,7 @@ static int check_and_change_inodes(ext2_ino_t dir,
 	struct ext2_inode 	inode;
 	ext2_ino_t		new_inode;
 	errcode_t		retval;
+	int			ret = 0;
 
 	if (is->rfs->progress && offset == 0) {
 		io_channel_flush(is->rfs->old_fs->io);
@@ -1988,13 +2051,22 @@ static int check_and_change_inodes(ext2_ino_t dir,
 			return DIRENT_ABORT;
 	}
 
+	/*
+	 * If we have checksums enabled and the inode wasn't present in the
+	 * old fs, then we must rewrite all dir blocks with new checksums.
+	 */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(is->rfs->old_fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    !ext2fs_test_inode_bitmap2(is->rfs->old_fs->inode_map, dir))
+		ret |= DIRENT_CHANGED;
+
 	if (!dirent->inode)
-		return 0;
+		return ret;
 
 	new_inode = ext2fs_extent_translate(is->rfs->imap, dirent->inode);
 
 	if (!new_inode)
-		return 0;
+		return ret;
 #ifdef RESIZE2FS_DEBUG
 	if (is->rfs->flags & RESIZE_DEBUG_INODEMAP)
 		printf("Inode translate (dir=%u, name=%.*s, %u->%u)\n",
@@ -2010,10 +2082,10 @@ static int check_and_change_inodes(ext2_ino_t dir,
 		inode.i_mtime = inode.i_ctime = time(0);
 		is->err = ext2fs_write_inode(is->rfs->old_fs, dir, &inode);
 		if (is->err)
-			return DIRENT_ABORT;
+			return ret | DIRENT_ABORT;
 	}
 
-	return DIRENT_CHANGED;
+	return ret | DIRENT_CHANGED;
 }
 
 static errcode_t inode_ref_fix(ext2_resize_t rfs)
@@ -2040,9 +2112,11 @@ static errcode_t inode_ref_fix(ext2_resize_t rfs)
 			goto errout;
 	}
 
+	rfs->old_fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	retval = ext2fs_dblist_dir_iterate(rfs->old_fs->dblist,
 					   DIRENT_FLAG_INCLUDE_EMPTY, 0,
 					   check_and_change_inodes, &is);
+	rfs->old_fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (retval)
 		goto errout;
 	if (is.err) {

