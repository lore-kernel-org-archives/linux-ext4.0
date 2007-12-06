From: Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize
Date: Thu, 6 Dec 2007 15:11:34 +0100
Message-ID: <20071206141133.GA6396@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52621 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753037AbXLFOLi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Dec 2007 09:11:38 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  attached is a new version of support for 64KB blocksize in e2fsprogs. The
patch went through testing by a script I'll send in the following email so
now the modifications should be correct. Ted, can you have a look at it
when you have time? Thanks.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

---

Subject: Support for 64KB blocksize in ext2-4 directories.

When block size is 64KB, we have to take care that rec_len does not overflow.
Kernel stores 0xffff in case 0x10000 should be stored - perform appropriate
conversion when processing directories.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/debugfs/htree.c b/debugfs/htree.c
index d0e673e..a326241 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -40,6 +40,7 @@ static void htree_dump_leaf_node(ext2_fi
 	blk_t		pblk;
 	ext2_dirhash_t 	hash;
 	int		hash_alg;
+	int rec_len;
 	
 	errcode = ext2fs_bmap(fs, ino, inode, buf, 0, blk, &pblk);
 	if (errcode) {
@@ -61,10 +62,8 @@ static void htree_dump_leaf_node(ext2_fi
 
 	while (offset < fs->blocksize) {
 		dirent = (struct ext2_dir_entry *) (buf + offset);
-		if (((offset + dirent->rec_len) > fs->blocksize) ||
-		    (dirent->rec_len < 8) ||
-		    ((dirent->rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > dirent->rec_len)) {
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
+		if (ext2fs_validate_dirent(fs, offset, dirent) < 0) {
 			fprintf(pager, "Corrupted directory block (%u)!\n", blk);
 			break;
 		}
@@ -79,7 +78,7 @@ static void htree_dump_leaf_node(ext2_fi
 			com_err("htree_dump_leaf_node", errcode,
 				"while calculating hash");
 		sprintf(tmp, "%u 0x%08x (%d) %s   ", dirent->inode,
-			hash, dirent->rec_len, name);
+			hash, rec_len, name);
 		thislen = strlen(tmp);
 		if (col + thislen > 80) {
 			fprintf(pager, "\n");
@@ -87,7 +86,7 @@ static void htree_dump_leaf_node(ext2_fi
 		}
 		fprintf(pager, "%s", tmp);
 		col += thislen;
-		offset += dirent->rec_len;
+		offset += rec_len;
 	}
 	fprintf(pager, "\n");
 }
@@ -389,7 +388,7 @@ static int search_dir_block(ext2_filsys
 			printf("offset %u\n", offset);
 			return BLOCK_ABORT;
 		}
-		offset += dirent->rec_len;
+		offset += ext2fs_rec_len_from_disk(dirent->rec_len);
 	}
 	return 0;
 }
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 52c7e34..1960c11 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -97,7 +97,7 @@ static int list_dir_proc(ext2_ino_t dir
 		fprintf (ls->f, " %s %s\n", datestr, name);
 	} else {
 		sprintf(tmp, "%c%u%c (%d) %s   ", lbr, dirent->inode, rbr,
-			dirent->rec_len, name);
+			ext2fs_rec_len_from_disk(dirent->rec_len), name);
 		thislen = strlen(tmp);
 
 		if (ls->col + thislen > 80) {
diff --git a/e2fsck/message.c b/e2fsck/message.c
index b2e3e0f..05b2e17 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -342,12 +342,13 @@ static _INLINE_ void expand_dirent_expre
 					      struct problem_context *ctx)
 {
 	struct ext2_dir_entry	*dirent;
-	int	len;
+	int	len, rec_len;
 	
 	if (!ctx || !ctx->dirent)
 		goto no_dirent;
 	
 	dirent = ctx->dirent;
+	rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 	
 	switch (ch) {
 	case 'i':
@@ -357,12 +358,12 @@ static _INLINE_ void expand_dirent_expre
 		len = dirent->name_len & 0xFF;
 		if (len > EXT2_NAME_LEN)
 			len = EXT2_NAME_LEN;
-		if (len > dirent->rec_len)
-			len = dirent->rec_len;
+		if (len > rec_len)
+			len = rec_len;
 		safe_print(dirent->name, len);
 		break;
 	case 'r':
-		printf("%u", dirent->rec_len);
+		printf("%u", rec_len);
 		break;
 	case 'l':
 		printf("%u", dirent->name_len & 0xFF);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..fd2c7d0 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -379,6 +379,7 @@ static void check_is_really_dir(e2fsck_t
 	errcode_t		retval;
 	blk_t			blk;
 	int			i, not_device = 0;
+	int			rec_len;
 
 	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode) ||
 	    LINUX_S_ISLNK(inode->i_mode) || inode->i_block[0] == 0)
@@ -408,20 +409,22 @@ static void check_is_really_dir(e2fsck_t
 		return;
 
 	dirent = (struct ext2_dir_entry *) buf;
+	rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 	if (((dirent->name_len & 0xFF) != 1) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->inode != pctx->ino) ||
-	    (dirent->rec_len < 12) ||
-	    (dirent->rec_len % 4) ||
-	    (dirent->rec_len >= ctx->fs->blocksize - 12))
+	    (rec_len < 12) ||
+	    (rec_len % 4) ||
+	    (rec_len >= ctx->fs->blocksize - 12))
 		return;
 
 	dirent = (struct ext2_dir_entry *) (buf + dirent->rec_len);
+	rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 	if (((dirent->name_len & 0xFF) != 2) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->name[1] != '.') ||
-	    (dirent->rec_len < 12) ||
-	    (dirent->rec_len % 4))
+	    (rec_len < 12) ||
+	    (rec_len % 4))
 		return;
 
 	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 27f7136..3080326 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -365,6 +365,7 @@ static int check_dot(e2fsck_t ctx,
 	int	created = 0;
 	int	new_len;
 	int	problem = 0;
+	int	rec_len;
 	
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
@@ -374,10 +375,11 @@ static int check_dot(e2fsck_t ctx,
 	else if (dirent->name[1] != '\0')
 		problem = PR_2_DOT_NULL_TERM;
 	
+	rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 	if (problem) {
 		if (fix_problem(ctx, problem, pctx)) {
-			if (dirent->rec_len < 12)
-				dirent->rec_len = 12;
+			if (rec_len < 12)
+				dirent->rec_len = ext2fs_rec_len_to_disk(12);
 			dirent->inode = ino;
 			dirent->name_len = 1;
 			dirent->name[0] = '.';
@@ -392,15 +394,15 @@ static int check_dot(e2fsck_t ctx,
 			status = 1;
 		}
 	}
-	if (dirent->rec_len > 12) {
-		new_len = dirent->rec_len - 12;
+	if (rec_len > 12) {
+		new_len = rec_len - 12;
 		if (new_len > 12) {
 			if (created ||
 			    fix_problem(ctx, PR_2_SPLIT_DOT, pctx)) {
 				nextdir = (struct ext2_dir_entry *)
 					((char *) dirent + 12);
-				dirent->rec_len = 12;
-				nextdir->rec_len = new_len;
+				dirent->rec_len = ext2fs_rec_len_to_disk(12);
+				nextdir->rec_len = ext2fs_rec_len_to_disk(new_len);
 				nextdir->inode = 0;
 				nextdir->name_len = 0;
 				status = 1;
@@ -432,8 +434,8 @@ static int check_dotdot(e2fsck_t ctx,
 
 	if (problem) {
 		if (fix_problem(ctx, problem, pctx)) {
-			if (dirent->rec_len < 12)
-				dirent->rec_len = 12;
+			if (ext2fs_rec_len_from_disk(dirent->rec_len) < 12)
+				dirent->rec_len = ext2fs_rec_len_to_disk(12);
 			/*
 			 * Note: we don't have the parent inode just
 			 * yet, so we will fill it in with the root
@@ -652,14 +654,15 @@ static void salvage_directory(ext2_filsy
 			      unsigned int *offset)
 {
 	char	*cp = (char *) dirent;
-	int left = fs->blocksize - *offset - dirent->rec_len;
+	int rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
+	int left = fs->blocksize - *offset - rec_len;
 	unsigned int name_len = dirent->name_len & 0xFF;
 
 	/*
 	 * Special case of directory entry of size 8: copy what's left
 	 * of the directory block up to cover up the invalid hole.
 	 */
-	if ((left >= 12) && (dirent->rec_len == 8)) {
+	if ((left >= 12) && (rec_len == 8)) {
 		memmove(cp, cp+8, left);
 		memset(cp + left, 0, 8);
 		return;
@@ -670,10 +673,10 @@ static void salvage_directory(ext2_filsy
 	 * record length.
 	 */
 	if ((left < 0) &&
-	    (name_len + 8 <= dirent->rec_len + (unsigned) left) &&
+	    (name_len + 8 <= rec_len + (unsigned) left) &&
 	    dirent->inode <= fs->super->s_inodes_count &&
 	    strnlen(dirent->name, name_len) == name_len) {
-		dirent->rec_len += left;
+		dirent->rec_len = ext2fs_rec_len_to_disk(rec_len + left);
 		return;
 	}
 	/*
@@ -681,10 +684,11 @@ static void salvage_directory(ext2_filsy
 	 * of four, and not too big, such that it is valid, let the
 	 * previous directory entry absorb the invalid one.
 	 */
-	if (prev && dirent->rec_len && (dirent->rec_len % 4) == 0 &&
-	    (*offset + dirent->rec_len <= fs->blocksize)) {
-		prev->rec_len += dirent->rec_len;
-		*offset += dirent->rec_len;
+	if (prev && rec_len && (rec_len % 4) == 0 &&
+	    (*offset + rec_len <= fs->blocksize)) {
+		prev->rec_len = ext2fs_rec_len_to_disk(
+			ext2fs_rec_len_from_disk(prev->rec_len) + rec_len);
+		*offset += rec_len;
 		return;
 	}
 	/*
@@ -694,10 +698,13 @@ static void salvage_directory(ext2_filsy
 	 * new empty directory entry the rest of the directory block.
 	 */
 	if (prev) {
-		prev->rec_len += fs->blocksize - *offset;
+		prev->rec_len = ext2fs_rec_len_to_disk(
+			ext2fs_rec_len_from_disk(prev->rec_len) +
+			fs->blocksize - *offset);
 		*offset = fs->blocksize;
 	} else {
-		dirent->rec_len = fs->blocksize - *offset;
+		dirent->rec_len = ext2fs_rec_len_to_disk(
+			fs->blocksize - *offset);
 		dirent->name_len = 0;
 		dirent->inode = 0;
 	}
@@ -731,6 +738,7 @@ static int check_dir_block(ext2_filsys f
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
+	int	rec_len;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -802,6 +810,7 @@ static int check_dir_block(ext2_filsys f
 		dx_db->max_hash = 0;
 			
 		dirent = (struct ext2_dir_entry *) buf;
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
 			root = (struct ext2_dx_root_info *) (buf + 24);
@@ -821,7 +830,7 @@ static int check_dir_block(ext2_filsys f
 				dx_dir->hashversion += 3;
 			dx_dir->depth = root->indirect_levels + 1;
 		} else if ((dirent->inode == 0) &&
-			   (dirent->rec_len == fs->blocksize) &&
+			   (rec_len == fs->blocksize) &&
 			   (dirent->name_len == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) == 
 			    ((fs->blocksize-8) / 
@@ -835,12 +844,13 @@ static int check_dir_block(ext2_filsys f
 	do {
 		problem = 0;
 		dirent = (struct ext2_dir_entry *) (buf + offset);
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 		cd->pctx.dirent = dirent;
 		cd->pctx.num = offset;
-		if (((offset + dirent->rec_len) > fs->blocksize) ||
-		    (dirent->rec_len < 12) ||
-		    ((dirent->rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > dirent->rec_len)) {
+		if (((offset + rec_len) > fs->blocksize) ||
+		    (rec_len < 12) ||
+		    ((rec_len % 4) != 0) ||
+		    (((dirent->name_len & 0xFF)+8) > rec_len)) {
 			if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
 				salvage_directory(fs, dirent, prev, &offset);
 				dir_modified++;
@@ -1035,7 +1045,7 @@ static int check_dir_block(ext2_filsys f
 		ctx->fs_total_count++;
 	next:
 		prev = dirent;
-		offset += dirent->rec_len;
+		offset += ext2fs_rec_len_from_disk(dirent->rec_len);
 		dot_state++;
 	} while (offset < fs->blocksize);
 #if 0
@@ -1055,9 +1065,10 @@ static int check_dir_block(ext2_filsys f
 	}
 #endif /* ENABLE_HTREE */
 	if (offset != fs->blocksize) {
-		cd->pctx.num = dirent->rec_len - fs->blocksize + offset;
+		cd->pctx.num = ext2fs_rec_len_from_disk(dirent->rec_len)
+				 - fs->blocksize + offset;
 		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-			dirent->rec_len = cd->pctx.num;
+			dirent->rec_len = ext2fs_rec_len_to_disk(cd->pctx.num);
 			dir_modified++;
 		}
 	}
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 8c1459c..2b70f98 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -102,7 +102,7 @@ static int fill_dir_block(ext2_filsys fs
 	if (HOLE_BLKADDR(*block_nr)) {
 		memset(dir, 0, fs->blocksize);
 		dirent = (struct ext2_dir_entry *) dir;
-		dirent->rec_len = fs->blocksize;
+		dirent->rec_len = ext2fs_rec_len_to_disk(fs->blocksize);
 	} else {
 		fd->err = ext2fs_read_dir_block(fs, *block_nr, dir);
 		if (fd->err)
@@ -116,14 +116,11 @@ static int fill_dir_block(ext2_filsys fs
 	dir_offset = 0;
 	while (dir_offset < fs->blocksize) {
 		dirent = (struct ext2_dir_entry *) (dir + dir_offset);
-		if (((dir_offset + dirent->rec_len) > fs->blocksize) ||
-		    (dirent->rec_len < 8) ||
-		    ((dirent->rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > dirent->rec_len)) {
+		if (ext2fs_validate_dirent(fs, dir_offset, dirent) < 0) {
 			fd->err = EXT2_ET_DIR_CORRUPTED;
 			return BLOCK_ABORT;
 		}
-		dir_offset += dirent->rec_len;
+		dir_offset += ext2fs_rec_len_from_disk(dirent->rec_len);
 		if (dirent->inode == 0)
 			continue;
 		if (!fd->compress && ((dirent->name_len&0xFF) == 1) &&
@@ -416,7 +413,9 @@ static errcode_t copy_dir_entries(ext2_f
 		rec_len = EXT2_DIR_REC_LEN(ent->dir->name_len & 0xFF);
 		if (rec_len > left) {
 			if (left)
-				dirent->rec_len += left;
+				dirent->rec_len = ext2fs_rec_len_to_disk(
+					ext2fs_rec_len_from_disk(dirent->rec_len) +
+					left);
 			if ((retval = get_next_block(fs, outdir,
 						      &block_start)))
 				return retval;
@@ -432,19 +431,20 @@ static errcode_t copy_dir_entries(ext2_f
 		}
 		dirent->inode = ent->dir->inode;
 		dirent->name_len = ent->dir->name_len;
-		dirent->rec_len = rec_len;
+		dirent->rec_len = ext2fs_rec_len_to_disk(rec_len);
 		memcpy(dirent->name, ent->dir->name, dirent->name_len & 0xFF);
 		offset += rec_len;
 		left -= rec_len;
 		if (left < 12) {
-			dirent->rec_len += left;
+			dirent->rec_len = ext2fs_rec_len_to_disk(rec_len + left);
 			offset += left;
 			left = 0;
 		}
 		prev_hash = ent->hash;
 	}
 	if (left)
-		dirent->rec_len += left;
+		dirent->rec_len = ext2fs_rec_len_to_disk(
+			ext2fs_rec_len_from_disk(dirent->rec_len) + left);
 
 	return 0;
 }
@@ -466,13 +466,13 @@ static struct ext2_dx_root_info *set_roo
 	dir->inode = ino;
 	dir->name[0] = '.';
 	dir->name_len = 1 | filetype;
-	dir->rec_len = 12;
+	dir->rec_len = ext2fs_rec_len_to_disk(12);
 	dir = (struct ext2_dir_entry *) (buf + 12);
 	dir->inode = parent;
 	dir->name[0] = '.';
 	dir->name[1] = '.';
 	dir->name_len = 2 | filetype;
-	dir->rec_len = fs->blocksize - 12;
+	dir->rec_len = ext2fs_rec_len_to_disk(fs->blocksize - 12);
 	
 	root = (struct ext2_dx_root_info *) (buf+24);
 	root->reserved_zero = 0;
@@ -497,7 +497,7 @@ static struct ext2_dx_entry *set_int_nod
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
 	dir->inode = 0;
-	dir->rec_len = fs->blocksize;
+	dir->rec_len = ext2fs_rec_len_to_disk(fs->blocksize);
 	
 	limits = (struct ext2_dx_countlimit *) (buf+8);
 	limits->limit = (fs->blocksize - 8) / sizeof(struct ext2_dx_entry);
diff --git a/ext2ed/dir_com.c b/ext2ed/dir_com.c
index c6b194e..d36d4b9 100644
--- a/ext2ed/dir_com.c
+++ b/ext2ed/dir_com.c
@@ -117,7 +117,7 @@ struct struct_file_info search_dir_entri
 		dir_entry_ptr=(struct ext2_dir_entry_2 *) (info.buffer+info.dir_entry_offset);
 
 		info.dir_entry_num++;
-		next = dir_entry_ptr->rec_len;
+		next = ext2_rec_len_from_disk(dir_entry_ptr->rec_len);
 		if (!next)
 			next = file_system_info.block_size - info.dir_entry_offset;
 		info.dir_entry_offset += next;
@@ -463,7 +463,7 @@ Show the current search entry (info) in
 	if (dir_entry_ptr->name_len > (COLS - 55) && COLS > 55)
 		temp [COLS-55]=0;
 	wprintw (show_pad,"inode = %-8lu rec_len = %-4lu name_len = %-3lu name = %s\n",	/* Display the various fields */
-		 dir_entry_ptr->inode,dir_entry_ptr->rec_len,dir_entry_ptr->name_len,temp);
+		 dir_entry_ptr->inode,ext2fs_rec_len_from_disk(dir_entry_ptr->rec_len),dir_entry_ptr->name_len,temp);
 
 	show_pad_info.max_line++;
 
@@ -619,8 +619,8 @@ because it is of variable length.
 
 	if (strcasecmp ("rec_len",variable)==0) {
 		found=1;
-		dir_entry_ptr->rec_len=(unsigned int) atol (value);
-		wprintw (command_win,"Variable %s set to %lu\n",variable,dir_entry_ptr->rec_len);refresh_command_win ();
+		dir_entry_ptr->rec_len=ext2fs_rec_len_to_disk((unsigned int) atol (value));
+		wprintw (command_win,"Variable %s set to %lu\n",variable,ext2fs_rec_len_from_disk(dir_entry_ptr->rec_len));refresh_command_win ();
 
 	}
 
@@ -648,7 +648,7 @@ because it is of variable length.
 		temp [dir_entry_ptr->name_len]=0;
 		wmove (show_pad,file_info.dir_entry_num,0);
 		wprintw (show_pad,"inode = %-8lu rec_len = %-4lu name_len = %-3lu name = %s\n",
-			 dir_entry_ptr->inode,dir_entry_ptr->rec_len,dir_entry_ptr->name_len,temp);
+			 dir_entry_ptr->inode,ext2fs_rec_len_from_disk(dir_entry_ptr->rec_len),dir_entry_ptr->name_len,temp);
 		wattrset (show_pad,A_NORMAL);
 		show_pad_info.line=file_info.dir_entry_num-show_pad_info.display_lines/2;
 		refresh_show_pad ();
diff --git a/ext2ed/disk.c b/ext2ed/disk.c
index d29c719..b602724 100644
--- a/ext2ed/disk.c
+++ b/ext2ed/disk.c
@@ -210,7 +210,7 @@ Just read from the current position into
 		
 	if (current_type!=NULL)
 		if (strcmp (current_type->name,"ext2_dir_entry")==0)
-			current_type->length=type_data.u.t_ext2_dir_entry.rec_len;
+			current_type->length=ext2_rec_len_from_disk(type_data.u.t_ext2_dir_entry.rec_len);
 
 	return (1);
 }
diff --git a/ext2ed/ext2ed.h b/ext2ed/ext2ed.h
index deae516..7eb5b29 100644
--- a/ext2ed/ext2ed.h
+++ b/ext2ed/ext2ed.h
@@ -35,6 +35,7 @@ Copyright (C) 1995 Gadi Oxman
 #define DEBUG						/* Activate self-sanity checks */
 
 #include <ext2fs/ext2_fs.h>				/* Main kernel ext2 include file */
+#include <ext2fs/ext2fs.h>
 #include <sys/stat.h>
 
 #include <ncurses.h>
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 003c0a3..63ea974 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -35,10 +35,8 @@ static int ext2fs_validate_entry(char *b
 	
 	while (offset < final_offset) {
 		dirent = (struct ext2_dir_entry *)(buf + offset);
-		offset += dirent->rec_len;
-		if ((dirent->rec_len < 8) ||
-		    ((dirent->rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > dirent->rec_len))
+		offset += ext2fs_rec_len_from_disk(dirent->rec_len);
+		if (ext2fs_validate_dirent(NULL, 0, dirent) < 0)
 			return 0;
 	}
 	return (offset == final_offset);
@@ -145,6 +143,7 @@ int ext2fs_process_dir_block(ext2_filsys
 	int		changed = 0;
 	int		do_abort = 0;
 	int		entry, size;
+	int		rec_len;
 	struct ext2_dir_entry *dirent;
 
 	if (blockcnt < 0)
@@ -158,10 +157,7 @@ int ext2fs_process_dir_block(ext2_filsys
 
 	while (offset < fs->blocksize) {
 		dirent = (struct ext2_dir_entry *) (ctx->buf + offset);
-		if (((offset + dirent->rec_len) > fs->blocksize) ||
-		    (dirent->rec_len < 8) ||
-		    ((dirent->rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > dirent->rec_len)) {
+		if (ext2fs_validate_dirent(fs, offset, dirent) < 0) {
 			ctx->errcode = EXT2_ET_DIR_CORRUPTED;
 			return BLOCK_ABORT;
 		}
@@ -185,16 +181,17 @@ int ext2fs_process_dir_block(ext2_filsys
 			break;
 		}
 next:		
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
  		if (next_real_entry == offset)
-			next_real_entry += dirent->rec_len;
+			next_real_entry += rec_len;
  
  		if (ctx->flags & DIRENT_FLAG_INCLUDE_REMOVED) {
 			size = ((dirent->name_len & 0xFF) + 11) & ~3;
 
-			if (dirent->rec_len != size)  {
+			if (rec_len != size)  {
 				unsigned int final_offset;
 
-				final_offset = offset + dirent->rec_len;
+				final_offset = offset + rec_len;
 				offset += size;
 				while (offset < final_offset &&
 				       !ext2fs_validate_entry(ctx->buf,
@@ -204,7 +201,7 @@ next:
 				continue;
 			}
 		}
-		offset += dirent->rec_len;
+		offset += rec_len;
 	}
 
 	if (changed) {
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index fb20fa0..545a22b 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -25,7 +25,7 @@ errcode_t ext2fs_read_dir_block2(ext2_fi
 	errcode_t	retval;
 	char		*p, *end;
 	struct ext2_dir_entry *dirent;
-	unsigned int	name_len, rec_len;
+	unsigned int	rec_len;
 	
 
  	retval = io_channel_read_blk(fs->io, block, 1, buf);
@@ -39,20 +39,23 @@ errcode_t ext2fs_read_dir_block2(ext2_fi
 #ifdef WORDS_BIGENDIAN
 		dirent->inode = ext2fs_swab32(dirent->inode);
 		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-		dirent->name_len = ext2fs_swab16(dirent->name_len);
-#endif
-		name_len = dirent->name_len;
-#ifdef WORDS_BIGENDIAN
-		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
+		if (!(flags & EXT2_DIRBLOCK_V2_STRUCT))
 			dirent->name_len = ext2fs_swab16(dirent->name_len);
 #endif
-		rec_len = dirent->rec_len;
-		if ((rec_len < 8) || (rec_len % 4)) {
-			rec_len = 8;
-			retval = EXT2_ET_DIR_CORRUPTED;
+		rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
+		switch (ext2fs_validate_dirent(fs, p - (char *)buf, dirent)) {
+			case -1:
+				rec_len = end - p;
+				retval = EXT2_ET_DIR_CORRUPTED;
+				break;
+			case -2:
+				rec_len = 8;
+				retval = EXT2_ET_DIR_CORRUPTED;
+				break;
+			case -3:
+				retval = EXT2_ET_DIR_CORRUPTED;
+				break;
 		}
-		if (((name_len & 0xFF) + 8) > dirent->rec_len)
-			retval = EXT2_ET_DIR_CORRUPTED;
 		p += rec_len;
 	}
 	return retval;
@@ -73,6 +76,7 @@ errcode_t ext2fs_write_dir_block2(ext2_f
 	char		*p, *end;
 	char		*buf = 0;
 	struct ext2_dir_entry *dirent;
+	int rec_len;
 
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
@@ -82,17 +86,14 @@ errcode_t ext2fs_write_dir_block2(ext2_f
 	end = buf + fs->blocksize;
 	while (p < end) {
 		dirent = (struct ext2_dir_entry *) p;
-		if ((dirent->rec_len < 8) ||
-		    (dirent->rec_len % 4)) {
+		if (ext2fs_validate_dirent(fs, p-buf, dirent) < 0) {
 			ext2fs_free_mem(&buf);
 			return (EXT2_ET_DIR_CORRUPTED);
 		}
-		p += dirent->rec_len;
+		p += ext2fs_rec_len_from_disk(dirent->rec_len);
 		dirent->inode = ext2fs_swab32(dirent->inode);
 		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-		dirent->name_len = ext2fs_swab16(dirent->name_len);
-
-		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
+		if (!(flags & EXT2_DIRBLOCK_V2_STRUCT))
 			dirent->name_len = ext2fs_swab16(dirent->name_len);
 	}
  	retval = io_channel_write_blk(fs->io, block, 1, buf);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 36e7c8c..7b31c8b 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -724,6 +724,21 @@ struct ext2_dir_entry_2 {
 #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
+#define EXT2_MAX_REC_LEN               ((1<<16)-1)
+
+static inline unsigned ext2fs_rec_len_from_disk(unsigned len)
+{
+	if (len == EXT2_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline unsigned ext2fs_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+		return EXT2_MAX_REC_LEN;
+	return len;
+}
 
 /*
  * This structure will be used for multiple mount protection. It will be
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d691c1b..8b08c07 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1003,6 +1003,8 @@ extern blk_t ext2fs_group_last_block(ext
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 				      struct ext2_inode *inode);
 extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
+extern int ext2fs_validate_dirent(ext2_filsys fs, unsigned int offset,
+				 struct ext2_dir_entry *dirent);
 
 /*
  * The actual inlined functions definitions themselves...
@@ -1203,6 +1205,24 @@ _INLINE_ unsigned int ext2fs_div_ceil(un
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+/*
+ * Check whether directory entry is valid
+ */
+_INLINE_ int ext2fs_validate_dirent(ext2_filsys fs, unsigned int offset,
+				 struct ext2_dir_entry *dirent)
+{
+	int rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
+
+	if (fs && offset + rec_len > fs->blocksize)
+		return -1;
+	if (rec_len < 8 || rec_len % 4 != 0)
+		return -2;
+	if ((dirent->name_len & 0xFF)+8 > rec_len)
+		return -3;
+	return 0;
+}
+
 #undef _INLINE_
 #endif
 
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 5e0f4f3..0838599 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -35,21 +35,26 @@ static int link_proc(struct ext2_dir_ent
 {
 	struct link_struct *ls = (struct link_struct *) priv_data;
 	struct ext2_dir_entry *next;
-	int rec_len, min_rec_len;
+	int rec_len, min_rec_len, n_rec_len, c_rec_len;
 	int ret = 0;
 
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
+	c_rec_len = ext2fs_rec_len_from_disk(dirent->rec_len);
 
 	/*
 	 * See if the following directory entry (if any) is unused;
 	 * if so, absorb it into this one.
 	 */
-	next = (struct ext2_dir_entry *) (buf + offset + dirent->rec_len);
-	if ((offset + dirent->rec_len < blocksize - 8) &&
-	    (next->inode == 0) &&
-	    (offset + dirent->rec_len + next->rec_len <= blocksize)) {
-		dirent->rec_len += next->rec_len;
-		ret = DIRENT_CHANGED;
+	next = (struct ext2_dir_entry *) (buf + offset + c_rec_len);
+	if ((offset + c_rec_len < blocksize - 8) &&
+	    (next->inode == 0)) {
+		n_rec_len = ext2fs_rec_len_from_disk(next->rec_len);
+		if (offset + c_rec_len + n_rec_len <= blocksize) {
+			dirent->rec_len =
+			    ext2fs_rec_len_to_disk(c_rec_len + n_rec_len);
+			c_rec_len += n_rec_len;
+			ret = DIRENT_CHANGED;
+		}
 	}
 
 	/*
@@ -59,15 +64,15 @@ static int link_proc(struct ext2_dir_ent
 	 */
 	if (dirent->inode) {
 		min_rec_len = EXT2_DIR_REC_LEN(dirent->name_len & 0xFF);
-		if (dirent->rec_len < (min_rec_len + rec_len))
+		if (c_rec_len < (min_rec_len + rec_len))
 			return ret;
-		rec_len = dirent->rec_len - min_rec_len;
-		dirent->rec_len = min_rec_len;
+		rec_len = c_rec_len - min_rec_len;
+		dirent->rec_len = ext2fs_rec_len_to_disk(min_rec_len);
 		next = (struct ext2_dir_entry *) (buf + offset +
-						  dirent->rec_len);
+						  min_rec_len);
 		next->inode = 0;
 		next->name_len = 0;
-		next->rec_len = rec_len;
+		next->rec_len = ext2fs_rec_len_to_disk(rec_len);
 		return DIRENT_CHANGED;
 	}
 
@@ -75,7 +80,7 @@ static int link_proc(struct ext2_dir_ent
 	 * If we get this far, then the directory entry is not used.
 	 * See if we can fit the request entry in.  If so, do it.
 	 */
-	if (dirent->rec_len < rec_len)
+	if (c_rec_len < rec_len)
 		return ret;
 	dirent->inode = ls->inode;
 	dirent->name_len = ls->namelen;
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 3904d91..6a4b478 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -41,7 +41,7 @@ errcode_t ext2fs_new_dir_block(ext2_fils
 		return retval;
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
-	dir->rec_len = fs->blocksize;
+	dir->rec_len = ext2fs_rec_len_to_disk(fs->blocksize);
 
 	if (dir_ino) {
 		if (fs->super->s_feature_incompat &
@@ -53,14 +53,16 @@ errcode_t ext2fs_new_dir_block(ext2_fils
 		dir->inode = dir_ino;
 		dir->name_len = 1 | filetype;
 		dir->name[0] = '.';
-		rec_len = dir->rec_len - EXT2_DIR_REC_LEN(1);
-		dir->rec_len = EXT2_DIR_REC_LEN(1);
+		rec_len = ext2fs_rec_len_from_disk(dir->rec_len)
+				- EXT2_DIR_REC_LEN(1);
+		dir->rec_len = ext2fs_rec_len_to_disk(EXT2_DIR_REC_LEN(1));
 
 		/*
 		 * Set up entry for '..'
 		 */
-		dir = (struct ext2_dir_entry *) (buf + dir->rec_len);
-		dir->rec_len = rec_len;
+		dir = (struct ext2_dir_entry *) (buf +
+			ext2fs_rec_len_from_disk(dir->rec_len));
+		dir->rec_len = ext2fs_rec_len_to_disk(rec_len);
 		dir->inode = parent_ino;
 		dir->name_len = 2 | filetype;
 		dir->name[0] = '.';
diff --git a/lib/ext2fs/unlink.c b/lib/ext2fs/unlink.c
index 31dd8ec..f5f34dc 100644
--- a/lib/ext2fs/unlink.c
+++ b/lib/ext2fs/unlink.c
@@ -57,7 +57,12 @@ static int unlink_proc(struct ext2_dir_e
 	}
 
 	if (offset) 
-		prev->rec_len += dirent->rec_len;
+		/* We actually would not need to convert initial values as
+		 * they are certainly less than 64K but let's not try to be
+		 * too clever */
+		prev->rec_len = ext2fs_rec_len_to_disk(
+			ext2fs_rec_len_from_disk(prev->rec_len) +
+			ext2fs_rec_len_from_disk(dirent->rec_len));
 	else
 		dirent->inode = 0;
 	ls->done++;
diff --git a/misc/e2image.c b/misc/e2image.c
index 1fbb267..3006af2 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -345,25 +345,29 @@ static void scramble_dir_block(ext2_fils
 	end = buf + fs->blocksize;
 	for (p = buf; p < end-8; p += rec_len) {
 		dirent = (struct ext2_dir_entry_2 *) p;
-		rec_len = dirent->rec_len;
 #ifdef WORDS_BIGENDIAN
-		rec_len = ext2fs_swab16(rec_len);
+		rec_len = ext2fs_swab16(dirent->rec_len);
+#else
+		rec_len = dirent->rec_len;
 #endif
+		rec_len = ext2fs_rec_len_from_disk(rec_len);
 #if 0
 		printf("rec_len = %d, name_len = %d\n", rec_len, dirent->name_len);
 #endif
-		if (rec_len < 8 || (rec_len % 4) ||
-		    (p+rec_len > end)) {
+		switch (ext2fs_validate_dirent(fs, p - buf, (struct ext2_dir_entry *)dirent)) {
+		    case -1:
+		    case -2:
 			printf("Corrupt directory block %lu: "
 			       "bad rec_len (%d)\n", (unsigned long) blk, 
 			       rec_len);
-			rec_len = end - p;
+			rec_len = ext2fs_rec_len_to_disk(end - p);
 #ifdef WORDS_BIGENDIAN
-				dirent->rec_len = ext2fs_swab16(rec_len);
+			dirent->rec_len = ext2fs_swab16(rec_len);
+#else
+			dirent->rec_len = rec_len;
 #endif
 			continue;
-		}
-		if (dirent->name_len + 8 > rec_len) {
+		    case -3:
 			printf("Corrupt directory block %lu: "
 			       "bad name_len (%d)\n", (unsigned long) blk, 
 			       dirent->name_len);
