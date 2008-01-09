From: Jan Kara <jack@suse.cz>
Subject: [PATCH resend] e2fsprogs: Handle rec_len correctly for 64KB
	blocksize
Date: Wed, 9 Jan 2008 21:04:07 +0100
Message-ID: <20080109200407.GF2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35345 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbYAIUEK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2008 15:04:10 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  this is a resend of the new version of 64KB blocksize support for
e2fsprogs. The patch went through testing by a script which is also
attached to this email. Ted, would you be interested if I modify the test
script so that tests in it can be run when user does 'make test'?

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

--FL5UXtIhxfXey3p5
Content-Type: application/x-compressed-tar
Content-Disposition: attachment; filename="64KB_test.tar.gz"
Content-Transfer-Encoding: base64

H4sIADACWEcAA+zcW28Ud57G8VxbyiuYm7pZTdgNTtfv9O+2Vrsip1E2ZLISjGZXc9EydgNe
fEDudibMq9/qboNPGJvA43w1ooTA3VWucz31VCF9Kn78erqYzRdfLf/qN49efPbRh9EwVMTy
377laPW5X39eDW0Un/WjZpkxqhrG9z78+awbffxVuTqczBfbx1332f9t77xz00/ms+P5XazQ
3Q67sycnz57Ou34zRpvWfdHb/f862b9vw1G5t3E6cqvrhp206PaP5ot/e3p0cri78cPh0e5s
q+v7rusev3o5/Li7dzzbWRwdvxq+6X5aje2GIzsaPn2/v/1smMno1+WHP80OZ8fbi72jw+Gb
jb8Me3Vr+Rvdatzx0cnLs4+P9v6xXIYvz42N7/f2Z92Dbx5urUZ1375Z3Pq7jYd7hy+Ghdgw
7uv9o50XO8N6LobPWRvfH28/O5gtP3UPdnePZ/P56Uz+fHLwZLn81Yf10kYbO4u9g+UPv0bL
2uknk+7+/e6vs93u29lO12XX11Y/2UrvlvtoY/u9pj54r6m/fvjzNz8+2tr4YnS/v7fl7b6P
Nx7//PjBsL22ce7gfMjxrwvXv90/nev9naPj45OXi9nuR0iEm65/L3tz/Tfrh+u/wuPT9X8X
wy2v//15N39+dLyYDlfddH92uLFx4eNW993/PLZzGfDm9Ok+vziXo8Xz2fH0zeiz+V0z4vZz
Ptibz/cOn003p5ubG8tL+ovK9LrXbQ4X90e6Wv75hmuu/4/aA264/j29P73+a9SGG/9ypH+6
/9/JcMvr/+DFcAWeXXvTg+EGPx2+Ol8R9p6+ZYJu+UM3Gg5v5pX5XYyUy2Ovi4qz6XZ2bzHR
34/3FrNudvBy8Wr6dFkiln9tPNgfSsL2Mkb2TqvM+dXbP1xN1Q2l4fjV9HD7YDbMc/pk79m1
0wzLXU5yeLSYHpzsL/ZeDsu4YdrZrzuz2e58+mRZVy5u1ZBgl/fGhXi7VMwu7sfX3cxv6GaZ
H9zNVgn7W6tZb+MPqWazfru/XJ/GW15b/rZqduPUB+819Vk1u7cV/etW1m9cPjLXnZ6vj1F8
OkZ3c4zsrcfoHYVkdWyGOFz3h+WOWX9Yferz9OPqqn79hY3vXU2MZflYj152kWvD4s1MKuPK
hBeS4mKbWZ1lF7Lh9alVn06tuzm1/K2n1u99Y7/lcLn/zWzvYPvZ7C7738giT/tfllku+59b
+9T/7mI4Pd5v73/frFPxXICsEyj6re7J9m53mpXdcBlcP62tp11G4npiy7h58jez9mE9fu+d
9E88XL7+n853Xnzsl8A3XP992ejs+a8t3/94i0/Pf3cyzGx5xN9++f/39nx4MNzqvnk+23kx
9Iv1o9L8y/WlOvy7fbg7PPb9YzZfl47hlt7tzbvt1bW+273ceznrnpwsur3lq+OjF/Nuf+/F
bPlpmOh4tr2//2qY9k0AbA5F4tf/7F4Nc1sv2c4t+Swm5ovjk53FyfFs46xo7K2X7qdr1o2+
7I6ePp3PFp2lbb3t5dHGo+39X4bcO13elVnF1VkNt/+PNKeK28zpp3Wp6/64+cdhXud+4XTG
dX6HPZotFsuJl310MZS+7unR8bpDvv79zaG5ftEPzXJx1Nnmubl/8OzfOv/VEfS3HsGdo8PD
4ce9X/YWrzZe//pX5zvsekbDWfLvj5/Puj//5eHD9Vr9x/JO8+Xycfdkf7d7Muu+Gu4m966c
OHFuscezp7Pj2eHOrFvVzvl6ijw3xbNls+3mJwcH26utHzbtYFWCNzaWkXh/dX/c6v51OXTf
//Dwu+7R/z56/N1P3V8fPOp++vnbH77/4btv16Mv/EJfX/Xl41jttPmw5pujf+kOjw7vD9u/
2Ht2cnQyH7Yl4nSq9TV157e6i/nvv8f//0WrN+//hueJVf6PvP+U/3cxvNf7v9UpcvFN1eWv
rrxtW7+buuad2/jiO7KzaVcXzfTve4vn0+3p/tHhs+EZffXV8tZy6aXjud/aXz5qTldXemcX
nvOHZ/D2juf58fLxfXTv/LxWz+3j9RP55PRR/7o1uvhMfnxwfqtvWgu/uBbvvbTTd4vXTnxu
5OF09svscHpwsvN8/dfZxN3n68mn2092dmdPnz2f9u+75svXFjet9pttzIsTv2PNrqzX3Wy+
XTrL3rmQ8+edC/dbfNBOe73z/dIJ9h7zsStn+m9cn/fdSf1odPuz6+Nt4E1n1y/zp78lZoZf
O1tf6KZd+OqDN/IWJ/nZOX5h9O+z9U+u2fr3ioK8u91m1++2GGb6RL9Hhyz4uKdM3XxZ3PUG
3rKV3Gp7x2+290634lL/u9j/487//988w8rX/b+l9d5W//+f+an/38Xw3v0/zn07+/Xl9uHu
9OONOn2giHc9UGxPz66D/dnhs+Gf+dHBbPF8+fZg9UB59UHDRpci/OaZXAjyGE7Yc3O45U57
y9YMt51bLPrdk1BWBLNHjLIiTlmRoKxIUlakKCvSKCsypqzIhLIiPSdaMdnaY8K1x6Rrj4nX
HpOvPSZge0zC9piI7TEZa5iMNUzGGiZjDZOxhslYw2SsYTLWMBlrmIw1TMY6JmMdk7GOyVjH
ZKxjMtYxGeuYjHVMxjomYx2TsYHJ2MBkbGAyNjAZG5iMDUzGBiZjA5OxgcnYwGRsYjI2MRmb
mIxNTMYmJmMTk7GJydjEZGxiMjYxGVuYjC1MxhYmYwuTsYXJ2MJkbGEytjAZW5iMLUzGNkzG
NkzGNkzGNkzGNkzGNkzGNkzGNkzGNkzGNkzGjjEZO8Zk7BiTsWNMxo4xGTvGZOwYk7FjTMaO
MRk7xmTsBJOxE0zGTjAZO8Fk7ASTsRNMxk4wGTvBZOwEk7ETTMb2wwSf/+FvDz7/yHP9w99+
xKR3P+pV24i5L/QjU20j5o7Tj1y1jZh7WT8K1TZi7pL9KFXbiLn/9qNSbSPmzt6PmmobMZ2h
H41V24hpI/1ootpGTs/pJT2nR/WcXtJzelTP6SU9p0f1nF7Sc3pUz+klPadH9Zxe0nN6VM/p
JT2nR/WcXtJzelTP6SU9p0f1nF7Sc3pUzzFJzzFUzzFJzzFUzzFJzzFUzzFJzzFUzzFJzzFU
zzFJzzFUzzFJzzFUzzFJzzFUzzFJzzFUzzFJzzFUz3FJz3FUz3FJz3FUz3FJz3FUz3FJz3FU
z3FJz3FUz3FJz3FUz3FJz3FUz3FJz3FUz3FJz3FUz3FJz3FUzwlJzwlUzwlJzwlUzwlJzwlU
zwlJzwlUzwlJzwlUzwlJzwlUzwlJzwlUzwlJzwlUzwlJzwlUzwlJzwlUz0lJz0lUz0lJz0lU
z0lJz0lUz0lJz0lUz0lJz0lUz0lJz0lUz0lJz0lUz0lJz0lUz0lJz0lUz0lJz0lUzylJzylU
zylJzylUzylJzylUzylJzylUzylJzylUzylJzylUzylJzylUzylJzylUzylJzylUzylJzylU
z2mSntNQPadJek5D9Zwm6TkN1XOapOc0VM9pkp7TUD2nSXpOQ/WcJuk5DdVzmqTnNFTPaZKe
01A9p0l6TkP1nLGk54xRPWcs6TljVM8ZS3rOGNVzxpKeM0b1nLGk54xRPWcs6TljVM8ZS3rO
GNVzxpKeM0b1nLGk54xRPWcs6TljVM+ZSHrOBNVzJpKeM0H1nImk50xQPWci6TkTVM+ZSHrO
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
5m50O5qY+8btaGJW+NvRBK3FJWotLlFrcYlai0vUWlyi1uIStRaXqLW4RK3FJWotLlFrcY1a
i2vUWlyj1uIatRbXqLW4Rq3FNWotrlFrcY1ai2vUWtyi1uIWtRa3qLW4Ra3FLWotblFrcYta
i1vUWtyi1uIWtRb3qLW4R63FPWot7lFrcY9ai3vUWtyj1uIetRb3qLW4R63FI2otHlFr8Yha
i0fUWjyi1uIRtRaPqLV4RK3FI2otHlFr8Yxai2fUWjyj1uIZtRbPqLV4Rq3FM2otnlFr8Yxa
i2fUWryi1uIVtRavqLV4Ra3FK2otXlFr8Ypai1fUWryi1uIVtRbvqLV4R63FO2ot3lFr8Y5a
i3fUWryj1uIdtRbvqLV4R63FJ2otPlFr8Ylai0/UWnyi1uITtRafqLX4RK3FJ2otPklrcYnK
3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxd
icrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo
3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrd
lajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2J
yt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajc
XYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2V
qNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K
3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxd
jcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo
3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd
1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2N
yt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajc
XY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Lyt21
qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK
3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxd
i8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo
3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rd
tajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2L
yt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajc
XYvK3bWo3F2Lyt21qNxdi8rdtajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31
qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K
3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxd
j8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo
3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd
9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2P
yt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNzdiMrdjajc
3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2N
qNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK
3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzd
iMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o
3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrd
jajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2I
yt2NqNzdiMrdjajc3YjK3Y2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc
3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3N
qNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK
3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzd
jMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o
3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrd
zajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YrK3a2o3N2K
yt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc
3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2t
qNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK
3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzd
isrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o
3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrd
rajc3YrK3a2o3N2Kyt2tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2O
yt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc
3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3t
qNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K
3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzd
jsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o
3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Jyt2dqNzdicrd
najc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2J
yt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc
3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2d
qNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK
3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzd
icrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o
3N2Jyt2dqNzdicrdnaTc3fVTgtbi29HErMW3o4lZi29HE7MW344mZi2+HU3MWnw7mpi1+HY0
MWvx7Whi1uLb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJ
ubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QSt
xUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vR
BK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm7
29EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJ
ubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0QSt
xUm5u9vRBK3FSbm729EErcVJubvb0QStxUm5u9vRBK3FSbm729EErcVJubvb0eSsxSUqd1ei
cnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3
V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicncl
KndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6Jy
dyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndX
onJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUq
d1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3JSp3V6JydyUqd1eicnclKndXonJ3
JSp3V6JydyUqd1eicnclKndXonJ3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ej
cnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3
V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1
KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6Ny
dzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndX
o3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUq
d1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnc1KndXo3J3NSp3V6NydzUqd1ejcnctKnfXonJ3
LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9ei
cnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp3
16Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnct
KnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jy
dy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfX
onJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0qd9eicnctKnfXonJ3LSp316Jydy0q
d9eicnctKnfXonJ3LSp316Jydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3
PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ej
cnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp3
16Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9
KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Ny
dz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfX
o3J3PSp316Nydz0qd9ejcnc9KnfXo3J3PSp316Nydz0qd9ejcnc9KnfXo3J3Iyp3N6JydyMq
dzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3
Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzei
cncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3
N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncj
Knc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6Jy
dyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3onJ3Iyp3N6JydyMqdzeicncjKnc3
onJ3Iyp3N6JydyMqdzeicnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMq
dzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3
Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzej
cnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3
N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcncz
Knc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6Ny
dzMqdzejcnczKnc3o3J3Myp3N6NydzMqdzejcnczKnc3o3J3Myp3N6Nydysqd7eicncrKne3
onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysq
d7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3
Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7ei
cncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3
t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncr
Kne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jydysqd7eicncrKne3onJ3Kyp3t6Jy
dysqd7eicncrKne3onJ3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3
o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsq
d7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3
Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ej
cnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3
t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcnc7
Kne3o3J3Oyp3t6Nydzsqd7ejcnc7Kne3o3J3Oyp3t6Nydzsqd7ejcncnKnd3onJ3Jyp3d6Jy
dycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3
onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycq
d3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3
Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3ei
cncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3
d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncnKnd3onJ3Jyp3d6Jydycqd3eicncn
Knd3onJ3Jyp3d5Jyd+1xUu7udjQxa/HtaGLW4tvRxKzFt6OJWYtvRxOzFt+OJmYtvh1NzFp8
O5qYtfh2NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52
NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu
7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtx
Uu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRB
a3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52
NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu
7nY0QWtxUu7udjRBa3FS7u52NEFrcVLu7nY0QWtxUu7udjRBa3FS7u52NDlrcYnK3ZWo3F2J
yt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajc
XYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2V
qNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK
3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxd
icrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo
3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrdlajcXYnK3ZWo3F2Jyt2VqNxdicrd
lajcXYnK3ZWo3F2Jyt2VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2N
yt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajc
XY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3V
qNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K
3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxd
jcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo
3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Nyt3VqNxdjcrd1ajcXY3K3dWo3F2Lyt21qNxdi8rd
tajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2L
yt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajc
XYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21
qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK
3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxd
i8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo3F2Lyt21qNxdi8rdtajcXYvK3bWo
3F2Lyt21qNxdi8rdtajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd
9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2P
yt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajc
XY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31
qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K
3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNxd
j8rd9ajcXY/K3fWo3F2Pyt31qNxdj8rd9ajcXY/K3fWo3F2Pyt31qNzdiMrdjajc3YjK3Y2o
3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrd
jajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2I
yt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc
3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2N
qNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK
3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzdiMrdjajc3YjK3Y2o3N2Iyt2NqNzd
iMrdjajc3YjK3Y2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o
3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrd
zajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2M
yt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc
3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3N
qNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YzK
3c2o3N2Myt3NqNzdjMrdzajc3YzK3c2o3N2Myt3NqNzdjMrdzajc3YrK3a2o3N2Kyt2tqNzd
isrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o
3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrd
rajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2K
yt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc
3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2t
qNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK3a2o3N2Kyt2tqNzdisrdrajc3YrK
3a2o3N2Kyt2tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzd
jsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o
3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd
7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2O
yt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc
3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Oyt3t
qNzdjsrd7ajc3Y7K3e2o3N2Oyt3tqNzdjsrd7ajc3Y7K3e2o3N2Jyt2dqNzdicrdnajc3YnK
3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzd
icrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o
3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrd
najc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2J
yt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc
3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2dqNzdicrdnajc3YnK3Z2o3N2Jyt2d
qNzdicrdnV/L3f3g+4/f3sfsf/nT9149az++PXXvPKlPP33/50/eeTPd75R3n/3iv/dnvHqO
Z++v/lvWeHz7c3n959vHelx/UB6vOtZqrc8fPC7z+uMPHh7/Nh6gPj5/8fL959dJ9V/e/+A7
H+jnL548f/G7OKDf7cdbXtrXJL18+OmfXB+P/uKzZx8++clDOQ8PD3/3T7+8/ueHT58/+eDl
s+f/dP3Nw1/fPvvweI1x/enPP3n/59fXP/7H8uo6f3j4908+e/L8/ZdPn312/eWj/3jN6U9e
fdHD7XPPn33+yy//+LdP//n6RnXW61R59OfX+vDwJ//ur35y+9TDn/7qJ77+u0d/9fSzX1w/
p16f++knzz74xQfPPv/s5U8eRqmP/vz5+z//9MmrPz38yYcfPn/y4sWbb/K/fv7pz179/Nsf
Xv+0x48+ePn001f/4x/7Guuj+f4HD++88/B3H3/+8KdPPnh4mA+l/6Tsn7T58GqGHr3/Lxr9
6b9o9E//6m/+3V/+7U8e/fDxO+1HP+njnb4f/d3f/N2fXI+3P/qtLYffcv3/Fq76Lz90/T9u
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
rItiXRTrolgXxcr1elGsi2JdFOuiWBfFuijWRbEuinVRrIti5S1wUayLYl0U66JYF8W6KNZF
sS4vDRTroli5q1gU66JYF8W6KNZFsS6KdVGsi2JdFOuiWLlRWxTrolgXxboo1kWxLop1UayL
Yl0U66JYufddFOuiWBfFuijWRbEuinVRrItiXRTroljJiUWxLop1UayLYl0U66JYF8W6iMlF
+Sxu0ym05U2ld0C+Xfve4oXQV61PsbeYD046xepvQbEuinVRrItiXRTrolgXxboo1kWxLorV
zwrFuijWRbEuinVRrItiXRTrolgXxbooVn0HnuebYt0U66ZYN8W6KdZNsW6KdVOsm2LdFCuX
jk2xbop1U6ybYt0U66ZYN8W6KdZNsW6Klavxplg3xbop1k2xbop1U6ybYt0U6/biQbHyBrcp
1k2xbop1U6ybYt0U66ZYN8W6KdZNsXLPsCnWTbFuinVTrJti3RTrplg3xbop1k2xchu2KdZN
sW6KdVOsm2LdFOumWDfFuinWTbFyZ7sp1k2xbop1U6ybYt0U66ZYN8W6KdZNsRILm2LdFOum
WDfFuinWTbFuinVTrJvc3LQR/bW9k/e203sk39B99/FS6evaJ+FbzBgn3QM46RTrplg3xbop
1k2xbop1U6ybYt0UKz+vKT8U66FYD8V6KNZDsR6K9VCsh2I9FOuhWHkWH4r1UKyHYj0U66FY
D8V6KNZDsR6K9VCsXBgOxXoo1kOxHor1UKyHYj0U66FYD8V6vLzwwVKsh2I9FOuhWA/FeijW
Q7EeivVQrIdi5e3rUKyHYj0U66FYD8V6KNZDsR6K9VCsh2LljuBQrIdiPRTroVgPxXoo1kOx
Hor1UKyHYuUm61Csh2I9FOuhWA/FeijWQ7EeivVQrIdi5b71UKyHYj0U66FYD8V6KNZDsR6K
9VCsh2IlBQ7FeijWQ7EeivVQrIdiPRTroVgPxXoIUuvKfPJe3xtT76J8y/f9yYupr3yfpppT
PFRtF/nWNtcAj8Bzdo3Ac3aN4AMRaK8ReM6uEXjOrhF4zq4ReM6uEXrOPGEC7TXC34OTLtBe
IzjpAu01gpMu0F4jOOkCLd+A6RrASRdorxH+KZx0gfYawUkXaK8RnHSB9hrBSeeD9Qol0F4j
OOkC7TWCky7QXiM46QLtNYKTLtDybcKuAZx0gfYawUkXaK8RPlJOukB7jeCkC7TXCE46D1Sg
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
l9djinVRrNyoLYp1UayLYl0U66JYF8W6KNZFsS6KdVGs3PsuinVRrItiXRTrolgXxboo1kWx
Lop1UazkxKJYF8W6KNZFsS6KdVGsi2JdxOSifBa36RTa8qbSOyDfrn1v8ULoq9an2FvMByed
YvW3oFgXxboo1kWxLop1UayLYl0U66JYF8XqZ4ViXRTrolgXxboo1kWxLop1UayLYl0Uq74D
z/NNsW6KdVOsm2LdFOumWDfFuinWTbFuipVLx6ZYN8W6KdZNsW6KdVOsm2LdFOumWDfFytV4
U6ybYt0U66ZYN8W6KdZNsW6KdVOsm2LlDW5TrJti3RTrplg3xbop1k2xbop1e8WmWLln2BTr
plg3xbop1k2xbop1U6ybYt0U66ZYuQ3bFOumWDfFuinWTbFuinVTrJti3RTrpli5s90U66ZY
N8W6KdZNsW6KdVOsm2LdFOumWImFTbFuinVTrJti3RTrplg3xbop1k1ubtqI/treyXvb6T2S
b+i++3ip9HXtk/AtZoyT7gGcdIp1U6ybYt0U66ZYN8W6KdZNsW6KlZ/XlB+K9VCsh2I9FOuh
WA/FeijWQ7EeivVQrDyLD8V6KNZDsR6K9VCsh2I9FOuhWA/FeihWLgyHYj0U66FYD8V6KNZD
sR6K9VCsh2I9FCvX2kOxHor1UKyHYj0U66FYD8V6KNZDsR6v6XwoFOuhWA/FeijWQ7EeivVQ
rIdiPRTroVi5IzgU66FYD8V6KNZDsR6K9VCsh2I9FOuhWLnJOhTroVgPxXoo1kOxHor1UKyH
Yj0U66FYuW89FOuhWA/FeijWQ7EeivVQrIdiPRTroVhJgUOxHor1UKyHYj0U66FYD8V6KNZD
sR6C1Loyn7zX98bUuyjf8n1/8mLqK9+nqeYUD0Q7FxYFsyeYNcFsCWZJMDuCWRHMhmAWBLMf
WDtAtgOzHJjdwKwGZjMwi4HZC8xaYLYCsxRYO2lWArMRmIXA7ANmHTDbgFkGzC5gVgGzCVgi
YQ8wa4DZAswSYHYAswKYDcAsAGb/L+t/JTuW/7L7l9W/bP5l8S97f1n7y9Zflv6y85fHKHey
8Jd9v6z7Zdsvy37Z9cuqXzb9suiXT7awyZZflvyy45cVv2z4ZcEv+31Z78t2X141Eiarfdns
y2Jf9vqy1petviz1ZacvK325/IiV7PNlnS/bfFnmyy5fVvmyyZdFvuzx5TouS7LElx2+rPBl
gy8LfNnfy/petveyvBeHqPshm3tZ3MveXtb2srWXpb3s7GVlLxt7WdirjQXretnWy7JedvWy
qpdNvSzqZU8va3rZ0qsdGjt6WdHLhl4W9LKfl/W8bOdlOS+7eVnNq60ui3nZy8taXrbyspSX
nbys5GUjLwt52ccrM7CNl2W87OJlFS+beFnEyx5e1vCyhZclvMIXK3jZwMsCXvbvsn6X7bss
32X3Lqt32bzLQxAhWbvL1l2W7rJzl5W7bNxl4S77dlm3y+dShGTXLqt22bTLol327LJmly27
LNllxy4vChGSBbvs12W9Ltt1Wa7Lbl1W67JZl8W6XF1ESLbqslSXnbqs1GWjLgt12afLOl22
6eIItEqzSpdNuizSZY8ua3TZossSXXboskKXDbq63bE/l/W5bM9leS67c1mdy+ZcFueyN5e1
udo3sDSXnbmszGVjLgtz2ZfLuly25bIsl1252oCxKZdFuezJZU0uW3JZksuOXFbksiGXBbna
ybIel+24LMdlNy6rcdmMy2Jc9uKyFpetuCIBO3FZictGXBbisg+Xdbhsw2UZLrtwWYUrW7EI
lz24rMFlCy5LcNmBywpcNuCyAJf9t/wJIiTLb9l9y+pbNt+y+Ja9t6y9ZestS2/5VImQbLxl
4S37bll3y7Zblt2y65ZVt2y65TkvQrLmli23LLllxy0rbtlwy4Jb9tuy3hY/QGsHu21Zbctm
WxbbsteWtbZstWWpLTttWWmrRZiFtuyzZZ0t22xZZssuW1bZssmWRbbssdXdjC22LLFlhy0r
bNlgywJb9teyvpbttSyv1baA1bVsrmVxLXtrWVvL1lqW1rKzlpW1bKzV/op9tayrZVsty2rZ
VcuqWjbVsqiWPbWsqdVGlSW17KhlRS0ballQy35a1tOynZbltOym1Y6fzbQspmUvLWtp2UrL
Ulp20rKSlo20LKQVnVhHyzZaltGyi5ZVtGyiZREte2hZQ8sWWn4DEZIVtGygZQEt+2dZP8v2
WZbPsnuW1bN8JkRI9s6ydpatsyydZecsK2fZOMvCWfbN4ut1RrNsll2zrJpl0yyLZtkzy5pZ
tsyyZJYds1oa2DDLgln2y7Jelu2yLJdltyyrZdksy2JZrbGslWWrLEtl2SnLSlk2yrJQln2y
rJNlm6xuVuySZZUsm2RZJMseWdbIskWWJbLskGWFrO76LJBlfyzrY9key/JYdseyOpbNsSyO
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
N8W6KdZNsXLp2BTrplg3xbop1k2xbop1U6ybYt0U66ZYuRpvinVTrJti3RTrplg3xbop1k2x
bop1U6y8wW2KdVOsm2LdFOumWDfFuinWTbFur9gUK/cMm2LdFOumWDfFuinWTbFuinVTrJti
3RQrt2GbYt0U66ZYN8W6KdZNsW6KdVOsm2LdFCt3tpti3RTrplg3xbop1k2xbop1U6ybYt0U
K7GwKdZNsW6KdVOsm2LdFOumWDfFusnNTRvRX9s7eW87vUfyDd13Hy+Vvq59Er7FjHHSPYCT
TrFuinVTrJti3RTrplg3xbop1k2x8vOa8kOxHor1UKyHYj0U66FYD8V6KNZDsR6KlWfxoVgP
xXoo1kOxHor1UKyHYj0U66FYD8XKheFQrIdiPRTroVgPxXoo1kOxHor1UKyHYuVaeyjWQ7Ee
ivVQrIdiPRTroVgPxXoo1uM1nQ+FYj0U66FYD8V6KNZDsR6K9VCsh2I9FCt3BIdiPRTroVgP
xXoo1kOxHor1UKyHYj0UKzdZh2I9FOuhWA/FeijWQ7EeivVQrIdiPRQr962HYj0U66FYD8V6
KNZDsR6K9VCsh2I9FCspcCjWQ7EeivVQrIdiPRTroVgPxXoo1kOQWlfmk/f63ph6F+Vbvu9P
Xkx95fs01ZzigWjnwqJg9gSzJpgtwSwJZkcwK4LZEMyCYPYDawfIdmCWA7MbmNXAbAZmMTB7
gVkLzFZglgJrJ81KYDYCsxCYfcCsA2YbMMuA2QXMKmA2AUsk7AFmDTBbgFkCzA5gVgCzAZgF
wOz/Zf2vZMfyX3b/svqXzb8s/mXvL2t/2frL0l92/vIY5U4W/rLvl3W/bPtl2S+7fln1y6Zf
Fv3yyRY22fLLkl92/LLilw2/LPhlvy/rfdnuy6tGwmS1L5t9WezLXl/W+rLVl6W+7PRlpS+X
H7GSfb6s82WbL8t82eXLKl82+bLIlz2+XMdlSZb4ssOXFb5s8GWBL/t7Wd/L9l6W9+IQdT9k
cy+Le9nby9petvaytJedvazsZWMvC3u1sWBdL9t6WdbLrl5W9bKpl0W97OllTS9berVDY0cv
K3rZ0MuCXvbzsp6X7bws52U3L6t5tdVlMS97eVnLy1ZelvKyk5eVvGzkZSEv+3hlBrbxsoyX
Xbys4mUTL4t42cPLGl628LKEV/hiBS8beFnAy/5d1u+yfZflu+zeZfUum3d5CCIka3fZusvS
XXbusnKXjbss3GXfLut2+VyKkOzaZdUum3ZZtMueXdbssmWXJbvs2OVFIUKyYJf9uqzXZbsu
y3XZrctqXTbrsliXq4sIyVZdluqyU5eVumzUZaEu+3RZp8s2XRyBVmlW6bJJl0W67NFljS5b
dFmiyw5dVuiyQVe3O/bnsj6X7bksz2V3Lqtz2ZzL4lz25rI2V/sGluayM5eVuWzMZWEu+3JZ
l8u2XJblsitXGzA25bIolz25rMllSy5LctmRy4pcNuSyIFc7Wdbjsh2X5bjsxmU1LptxWYzL
XlzW4rIVVyRgJy4rcdmIy0Jc9uGyDpdtuCzDZRcuq3BlKxbhsgeXNbhswWUJLjtwWYHLBlwW
4LL/lj9BhGT5LbtvWX3L5lsW37L3lrW3bL1l6S2fKhGSjbcsvGXfLetu2XbLslt23bLqlk23
POdFSNbcsuWWJbfsuGXFLRtuWXDLflvW2+IHaO1gty2rbdlsy2Jb9tqy1pattiy1ZactK221
CLPQln22rLNlmy3LbNllyypbNtmyyJY9trqbscWWJbbssGWFLRtsWWDL/lrW17K9luW12haw
upbNtSyuZW8ta2vZWsvSWnbWsrKWjbXaX7GvlnW1bKtlWS27allVy6ZaFtWyp5Y1tdqosqSW
HbWsqGVDLQtq2U/Lelq207Kclt202vGzmZbFtOylZS0tW2lZSstOWlbSspGWhbSiE+to2UbL
Mlp20bKKlk20LKJlDy1raNlCy28gQrKClg20LKBl/yzrZ9k+y/JZds+yepbPhAjJ3lnWzrJ1
lqWz7Jxl5SwbZ1k4y75ZfL3OaJbNsmuWVbNsmmXRLHtmWTPLllmWzLJjVksDG2ZZMMt+WdbL
sl2W5bLslmW1LJtlWSyrNZa1smyVZaksO2VZKctGWRbKsk+WdbJsk9XNil2yrJJlkyyLZNkj
yxpZtsiyRJYdsqyQ1V2fBbLsj2V9LNtjWR7L7lhWx7I5lsWx7I3V9omtsSyNZWcsK2PZGMvC
WPbFsi6WbbEsi9U+lFWxbIplUSx7YlkTy5ZYlsSyI5YVsWyI1Yae/bCsh2U7LMth2Q3Lalg2
w7IYlr2wrIWVjFgKy05YVsKyEZaFsOyDZR0s22BZBssuWH9eMy1CsgeWNbBsgWUJLDtgWQHL
BlgWwOrTmGe2v7L8ld2vrH5l8yuLX9n7ytpXtr6y9FUnLCtf2fjKwlf2vbLulW2vLHtl1yur
Xtn0qiufPa+seWXLK0te2fHKilc2vLLglf2urHfVEspyV3a7stqVza4sdmWvK2td2erKUld2
uupexEZXFrqyz5V1rmxzZZkru1xZ5comVxa56qbOGle2uLLElR2urHBlgysLXNnfyvpWtrdq
d8TuVla3srmVxa3sbWVtK1tbWdrKzlZWtmqbycJW9rWyrpVtrSxrZVcrq1rZ1MqiVva0ar/O
llaWtLKjlRWtbGhlQSv7WVnPynZWlrMSPqQNd+TcSHL/w9s27zZcJHlt85S8ZvIH/+f7mP0v
f/reyycvXv741f/p73z04oNfvPvsF7/Vn/H4+pi9v/pvWePx7c/l9Z9vH2OOH5THq441alvX
58urd9H+wcPj3+pRfMvH5y9evv/84eEH/+X9D77zUX/+4snzF7+LA/rdfjypr57xh/Juf/xu
ffhhqe/8L59/8k59/Hj96NH//f0XLx7KTx7+3cdPPvjFdY08PP3s2YdPXvzrh5998uyDX1z/
ff+zDx9ePP3nJy9eD61fGfrh0+dPPnj57Pk/Pbx4+fzzD15+/vzJ60HtGwd98Oyzz67/+fTv
n778pzfj/uQnD3/zy5dPP336z18d+vSLH9a/8n2eP/noyfMnn33w5Po+n3/28s2I8ZURP3/+
7PNfPrz4/NNP379+2tPPPnr2/NP3Xz599tmjR6/O+3eefvr+z5/85OF/fvXx8Od/8Vd/9vC3
/6+//bs/++uH/+ef/O3DX//Nn/7Fn//Fn/3p609/7Qvq4x+X2XZ/eLWyvHj44eN3H/+PD589
++yd6wG9fPrzz599/uJH//qhnzejXk9c0jrz5fX/q//17ouPf7s/49U1vsb4luu/tLn6m+v/
+mwZr67/8fj76/938vH7/+rHP3v62Y9/9v6Ljx89+uu//LP653/7xz/++Lor/vjVhPz4xbPP
n3/w5MevVolfPn/28xc//vTpiw9+/OkvXv3Foz/9s5/+x3+P8R8++dnnP//oV/999OoH/Lu/
/M4veb0kvfnP9QV/8dd/8u//zAf1pN6uyUevh395kb6+wt/74NnzVyvID3/06P/76OHh6UfX
ivLRRw9/UN599vnL239+8fBfr2XiyS8ffu///Z/+6N/+59/74o/v/P2bv3n4T+9/8Ol/vlak
Jz/5vYd/ez2iv//xZ59/8sm/eXj58ZPPru/5cK1D1zr32UO5/vDR00e/+vPjR/+/R48+/PD6
oX98+6p/fvL82cOzj/74D26H+vCzF388x2jz4cWTJ7/441cLRXu9jv1xeahf/pxHL599/sHH
D08+/eXLf7ptZB49+oPXT9jDO3/+8M7PHl5/k3f+5tVa+d7Tzz588o8PX87CVw74+qb/U3n0
6Pcf/f7r9fHhHz6+9kBPnj988uzFyz/86PrJHz58/P61nH+xXP3+oz9481Q/vPMPD2+O+o/+
6M/+5s8f/u2rn/B6Dm/f9bqYXn7l+zy6xjy65vqrz8DtD+VXs/bkg4+fPfze7e8efnkt208+
/L1HTz558eTXPvXR+9cjvj51/e0/Pn356JrerzyAlx9fP/XDJy9f3UGefXZN7VfuLK92ew//
8PzZdRP49Lp7PfzDs+evHtLXvvLrg68/vNoeXsv4y+t/v//Bq+3hw5NrUq7ve5uRt/gen73/
6ZPbN/m3X3y7f/2r7/s/PvSHf/XHD4//9fUdHn71t0/+8YMnTz589aNe/4xX99W3+EHXqf/i
1Re9e7sZv/vuF1+Cp6y+8+aC/PKp+/QX17d+ePUkff7Ll08+fO/VbL13/dWjF9cT+Jt//Xo2
H5dXK/ubr33x8bPnL99784De/N2zV2fWe19++Ref/eDDb/3UPzx/+vLJV87z27310Sef3f57
PREvn//Te6/m9xr73s+e/vzXPnN9l1efuJ689z79/JOXT3/5G1/7ZsTrCX/x3m26Xx3Pu+++
OeY3c/reu+9df3U7o7/+yG5/9W1H/8mLb/3U7eu+9s3fXB7/6jcvkF89Qd9woVz7rD99/cmH
69n75ecvb2vZdXt6+Oj5s0+vE+E6mX55faMn1xx/9uRfffWi+f2H//Dk9fx+cd49/ezXHt0/
/uOHD+88f3Oy/NeHDz/8+lJVXu3V/v6Pr/l9/vlnH7xes/7ghz/s5X++rT9/WOof9h/96GsL
1+N//Oi6z98e7Df+/G+Zrx//5lP933hs9ctje/3/528e4ZP/1uP7phPut3WcdX/DZNbx3z6Z
33ju/xaP9vrjNzz718evHfCXq9jXrof/xiNpr4/kN37wF8D8+jG8Xkw/fvYPD28usYefPfn4
/b+/tu/XveNXE/fFze9X6+h3LKLv/OqrvlxOr3Xg69fVdywM16e+aVn49kXhyx/4TcvDF6O+
/X765ZDfvK9+7W7zZlP1+q7ycKnp1Y97vSD/wZud2fWEvfhict4Mf+flp7/8Ytvx+se9+cSX
0/PND+/NsG98UF8cync8qC+GfPGgvvJoXj3db6z7nc/26/3pwzv/9PDOR188qjeP4fVLI9/9
AF6N+Zajv/3s7zz42whvdD55+tnNtK9u+J9/9sWf3u6+3379fn/7y1d3v9f/4zfuva/P4S/u
wF/+6eHLl9Lef++Ta3d1ndi3v3q1XN+2DF8Z++oYX7x329M+1Otsf/T806994xdf3KG/7Rt+
9ZPX6vX31xL26bUZfv1/fn3we+//7IMPn3z084/fK/f71vX2GL/zG3/1Ubc3j/qOj+PvX3z0
NsO+9ldv8wU/+9oX/Ise9XjzqH/jZ359Jn7z/LmGfNsa2L7h8mrffl21t7igPn75/Mmrl44+
/eXzJ9cqfK0Lry6tL29Rnzx98fLtL7H+bVvr2ycfXVuz67u/9y/5izdXZ//Nq/M7X9F+fet7
9YR52Neetv74cbnN/6v1/oc/fHj6cGnl31z/+aNXn3r1v/7wDx9+9KN/8/Dhs2tWv302vm06
fvV4rlPvLQ7tO4f8wdPbkX54bXS/8XTp37GP7r5R9u+4UX71XvGnv3676G9xu+jfdrvovF30
t7pdvL7pfeUO/urkffvbdn+723b/jtt29227/8Zt+ytT/MW59ZtH+LUr7otPf7E9+vVXJH76
J9fHty4p3/D13/VQvhz1Fg/qK4N/ew+vfvnwrlXixZP3n3/w8evH+PAf/wQfv/EVf/XTn373
F7yZtv/08L+9eXnsz15R4uH1C0Xvv/y9b5nD1wf5Xx/+4YOHdz753x7eefL/eagP//mtJrb+
Sya2ftM18B279tdX3TedKtc2/J1P3ixNX5wrzx/eefHwf73+3x9969f+14cPrv/7zoe3Ydcy
UB5ff/Xi2t28EsyrFxnfefjmr/3FN72K+NWH+vUv+K5J+bWR33GqcUK+cnLdbozvffj5p7/8
+qx8/OT9y2nX4/zWL/+uR17f/5aHfn3nN2dYffx73/W9vz7f/W2mu/7sW37od8zjl6fhNej1
nH/X6J99ZdrfTPztdWA9XfX9bzqDry3SV17qffWnX18jkv4Z6fuP7z++//j+4/uP7z++//j+
4/uP7z++//j+4/uP8I//Ha1p1KoAYA4A

--FL5UXtIhxfXey3p5--
