From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/31] libext2fs: Add space for metadata checksum when
 unconverting a hashed directory block
Date: Mon, 30 Sep 2013 18:27:14 -0700
Message-ID: <20131001012714.28415.87579.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB1T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:19 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_link function has the unfortunate habit of converting hashed
directories into unhashed directories.  It doesn't notice that it's slicing
and dicing directory entries from a former dx_{root,node} block, and therefore
doesn't write a protective dirent into the end of the block to store the
checksum.  Teach it to do this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/link.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index e3ff450..24fa083 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -42,6 +42,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	unsigned int rec_len, min_rec_len, curr_rec_len;
 	int ret = 0;
 	int csum_size = 0;
+	struct ext2_dir_entry_tail *t;
 
 	if (ls->done)
 		return 0;
@@ -71,6 +72,40 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	}
 
 	/*
+	 * Since ext2fs_link blows away htree data, we need to be careful --
+	 * if metadata_csum is enabled and we're passed in a dirent that
+	 * contains htree data, we need to create the fake entry at the end
+	 * of the block that hides the checksum.
+	 */
+
+	/* De-convert a dx_node block */
+	if (csum_size &&
+	    curr_rec_len == ls->fs->blocksize &&
+	    !dirent->inode) {
+		curr_rec_len -= csum_size;
+		ls->err = ext2fs_set_rec_len(ls->fs, curr_rec_len, dirent);
+		if (ls->err)
+			return DIRENT_ABORT;
+		t = EXT2_DIRENT_TAIL(buf, ls->fs->blocksize);
+		ext2fs_initialize_dirent_tail(ls->fs, t);
+		ret = DIRENT_CHANGED;
+	}
+
+	/* De-convert a dx_root block */
+	if (csum_size &&
+	    curr_rec_len == ls->fs->blocksize - EXT2_DIR_REC_LEN(1) &&
+	    offset == EXT2_DIR_REC_LEN(1) &&
+	    dirent->name[0] == '.' && dirent->name[1] == '.') {
+		curr_rec_len -= csum_size;
+		ls->err = ext2fs_set_rec_len(ls->fs, curr_rec_len, dirent);
+		if (ls->err)
+			return DIRENT_ABORT;
+		t = EXT2_DIRENT_TAIL(buf, ls->fs->blocksize);
+		ext2fs_initialize_dirent_tail(ls->fs, t);
+		ret = DIRENT_CHANGED;
+	}
+
+	/*
 	 * If the directory entry is used, see if we can split the
 	 * directory entry to make room for the new name.  If so,
 	 * truncate it and return.
@@ -152,6 +187,11 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	if ((retval = ext2fs_read_inode(fs, dir, &inode)) != 0)
 		return retval;
 
+	/*
+	 * If this function changes to preserve the htree, remove the two
+	 * hunks in link_proc that shove checksum tails into the former
+	 * dx_root/dx_node blocks.
+	 */
 	if (inode.i_flags & EXT2_INDEX_FL) {
 		inode.i_flags &= ~EXT2_INDEX_FL;
 		if ((retval = ext2fs_write_inode(fs, dir, &inode)) != 0)

