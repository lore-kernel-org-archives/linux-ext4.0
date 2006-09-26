From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 07/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:48:32 +0200
Message-ID: <20060926144832.GG25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:63368 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932091AbWIZOsp
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:48:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 187BE19D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:48:41 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12488-03 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:48:34 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 508DD19D943
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:48:34 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

convert all 32bit on-disk block number definitions (currently __u32,
blk_t, unsigned long, unsigned int...) to pblk_t that is defined as
__u32. In this way we are sure that blk_t is used only in memory.
Later, this would allow to make blk_t 64bit without disturbing any
programs (this would just eat more momory and use 64bit arithmetic).

Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>


Index: e2fsprogs-1.39/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/debugfs.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/debugfs/debugfs.c	2006-09-19 20:50:30.000000000 +0200
@@ -1673,7 +1673,8 @@ void do_features(int argc, char *argv[])
 void do_bmap(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	blk_t		blk, pblk;
+	blk_t		blk;
+	blk_t		pblk;
 	int		err;
 	errcode_t	errcode;
 	
@@ -1698,7 +1699,8 @@ void do_bmap(int argc, char *argv[])
 void do_imap(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	unsigned long 	group, block, block_nr, offset;
+	unsigned long 	group, offset;
+	blk_t		block, block_nr;
 
 	if (common_args_process(argc, argv, 2, 2, argv[0],
 				"<file>", 0))
@@ -1721,7 +1723,7 @@ void do_imap(int argc, char *argv[])
 	offset &= (EXT2_BLOCK_SIZE(current_fs->super) - 1);
 
 	printf("Inode %d is part of block group %lu\n"
-	       "\tlocated at block %lu, offset 0x%04lx\n", ino, group,
+	       "\tlocated at block %u, offset 0x%04lx\n", ino, group,
 	       block_nr, offset);
 
 }
Index: e2fsprogs-1.39/debugfs/icheck.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/icheck.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/debugfs/icheck.c	2006-09-19 20:50:27.000000000 +0200
@@ -112,8 +112,10 @@ void do_icheck(int argc, char **argv)
 		bw.inode = ino;
 
 		if (inode.i_file_acl) {
-			icheck_proc(current_fs, &inode.i_file_acl, 0,
+			blk_t i_file_acl = inode.i_file_acl;
+			icheck_proc(current_fs, &i_file_acl, 0,
 				    0, 0, &bw);
+			inode.i_file_acl = i_file_acl;
 			if (bw.blocks_left == 0)
 				break;
 		}
Index: e2fsprogs-1.39/debugfs/logdump.c
===================================================================
--- e2fsprogs-1.39.orig/debugfs/logdump.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/debugfs/logdump.c	2006-09-19 20:50:27.000000000 +0200
@@ -36,11 +36,13 @@ extern char *optarg;
 
 enum journal_location {JOURNAL_IS_INTERNAL, JOURNAL_IS_EXTERNAL};
 
-#define ANY_BLOCK ((unsigned int) -1)
+#define ANY_BLOCK ((blk_t) -1)
 
 int		dump_all, dump_contents, dump_descriptors;
-unsigned int	block_to_dump, group_to_dump, bitmap_to_dump;
-unsigned int	inode_block_to_dump, inode_offset_to_dump, bitmap_to_dump;
+blk_t		block_to_dump, bitmap_to_dump;
+unsigned int	group_to_dump;
+blk_t		inode_block_to_dump;
+unsigned int	inode_offset_to_dump;
 ext2_ino_t	inode_to_dump;
 
 struct journal_source 
@@ -364,8 +366,8 @@ static void dump_journal(char *cmdname, 
 		if (dump_all) {
 			fprintf(out_file, "\tuuid=%s\n", jsb_buffer);
 			fprintf(out_file, "\tblocksize=%d\n", blocksize);
-			fprintf(out_file, "\tjournal data size %ld\n",
-				(long) sb->s_blocks_count);
+			fprintf(out_file, "\tjournal data size %lu\n",
+				(unsigned long) sb->s_blocks_count);
 		}
 	}
 	
Index: e2fsprogs-1.39/e2fsck/jfs_user.h
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/jfs_user.h	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/jfs_user.h	2006-09-19 19:20:58.000000000 +0200
@@ -103,7 +103,7 @@ _INLINE_ void do_cache_destroy(kmem_cach
 /*
  * Kernel compatibility functions are defined in journal.c
  */
-int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys);
+int journal_bmap(journal_t *journal, blk_t block, blk_t *phys);
 struct buffer_head *getblk(kdev_t ctx, blk_t blocknr, int blocksize);
 void sync_blockdev(kdev_t kdev);
 void ll_rw_block(int rw, int dummy, struct buffer_head *bh[]);
Index: e2fsprogs-1.39/e2fsck/journal.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/journal.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/journal.c	2006-09-19 20:50:27.000000000 +0200
@@ -43,7 +43,7 @@ static int bh_count = 0;
  * to use the recovery.c file virtually unchanged from the kernel, so we
  * don't have to do much to keep kernel and user recovery in sync.
  */
-int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys)
+int journal_bmap(journal_t *journal, blk_t block, blk_t *phys)
 {
 #ifdef USE_INODE_IO
 	*phys = block;
@@ -51,7 +51,6 @@ int journal_bmap(journal_t *journal, blk
 #else
 	struct inode 	*inode = journal->j_inode;
 	errcode_t	retval;
-	blk_t		pblk;
 
 	if (!inode) {
 		*phys = block;
@@ -59,8 +58,7 @@ int journal_bmap(journal_t *journal, blk
 	}
 
 	retval= ext2fs_bmap(inode->i_ctx->fs, inode->i_ino, 
-			    &inode->i_ext2, NULL, 0, block, &pblk);
-	*phys = pblk;
+			    &inode->i_ext2, NULL, 0, block, phys);
 	return (retval);
 #endif
 }
@@ -201,7 +199,7 @@ static errcode_t e2fsck_get_journal(e2fs
 	journal_t		*journal = NULL;
 	errcode_t		retval = 0;
 	io_manager		io_ptr = 0;
-	unsigned long		start = 0;
+	blk_t			start = 0;
 	blk_t			blk;
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c	2006-09-19 19:20:58.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1.c	2006-09-19 20:50:27.000000000 +0200
@@ -1777,7 +1777,7 @@ static char *describe_illegal_block(ext2
 		sprintf(problem, "< FIRSTBLOCK (%u)", super);
 		return(problem);
 	} else if (block >= fs->super->s_blocks_count) {
-		sprintf(problem, "> BLOCKS (%u)", fs->super->s_blocks_count);
+		sprintf(problem, "> BLOCKS (%lu)", fs->super->s_blocks_count);
 		return(problem);
 	}
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -2226,20 +2226,26 @@ static void handle_fs_bad_blocks(e2fsck_
 	blk_t		first_block;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
+		blk_t blk;
 		first_block = ext2fs_group_first_block(fs, i);
 
 		if (ctx->invalid_block_bitmap_flag[i]) {
+			blk = fs->group_desc[i].bg_block_bitmap;
 			new_table_block(ctx, first_block, i, _("block bitmap"),
-					1, &fs->group_desc[i].bg_block_bitmap);
+					1, &blk);
+			fs->group_desc[i].bg_block_bitmap = blk;
 		}
 		if (ctx->invalid_inode_bitmap_flag[i]) {
+			blk = fs->group_desc[i].bg_inode_bitmap;
 			new_table_block(ctx, first_block, i, _("inode bitmap"),
-					1, &fs->group_desc[i].bg_inode_bitmap);
+					1, &blk);
+			fs->group_desc[i].bg_inode_bitmap = blk;
 		}
 		if (ctx->invalid_inode_table_flag[i]) {
+			blk = fs->group_desc[i].bg_inode_table;
 			new_table_block(ctx, first_block, i, _("inode table"),
-					fs->inode_blocks_per_group, 
-					&fs->group_desc[i].bg_inode_table);
+					fs->inode_blocks_per_group, &blk);
+			fs->group_desc[i].bg_inode_table = blk;
 			ctx->flags |= E2F_FLAG_RESTART;
 		}
 	}
@@ -2330,7 +2336,7 @@ static void mark_table_blocks(e2fsck_t c
  * the inode again.
  */
 static errcode_t pass1_get_blocks(ext2_filsys fs, ext2_ino_t ino,
-				  blk_t *blocks)
+				  pblk_t *blocks)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 	int	i;
Index: e2fsprogs-1.39/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1b.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass1b.c	2006-09-19 20:50:27.000000000 +0200
@@ -289,9 +289,12 @@ static void pass1b(e2fsck_t ctx, char *b
 		    (ino == EXT2_BAD_INO))
 			pctx.errcode = ext2fs_block_iterate2(fs, ino,
 				     0, block_buf, process_pass1b_block, &pb);
-		if (inode.i_file_acl)
-			process_pass1b_block(fs, &inode.i_file_acl,
+		if (inode.i_file_acl) {
+			blk_t i_file_acl = inode.i_file_acl;
+			process_pass1b_block(fs, &i_file_acl,
 					     BLOCK_COUNT_EXTATTR, 0, 0, &pb);
+			inode.i_file_acl = i_file_acl;
+		}
 		if (pb.dup_blocks) {
 			end_problem_latch(ctx, PR_LATCH_DBLOCK);
 			if (ino >= EXT2_FIRST_INODE(fs->super) ||
@@ -617,9 +620,12 @@ static void delete_file(e2fsck_t ctx, ex
 		 */
 		if ((count == 0) ||
 		    ext2fs_test_block_bitmap(ctx->block_dup_map,
-					     inode.i_file_acl)) 
-			delete_file_block(fs, &inode.i_file_acl,
+					     inode.i_file_acl)) {
+			blk_t i_file_acl = inode.i_file_acl;
+			delete_file_block(fs, &i_file_acl,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
+			inode.i_file_acl = i_file_acl;
+		}
 	}
 	e2fsck_write_inode(ctx, ino, &inode, "delete_file");
 }
@@ -706,10 +712,12 @@ static int clone_file(e2fsck_t ctx, ext2
 	struct clone_struct cs;
 	struct problem_context	pctx;
 	blk_t		blk;
+	blk_t		i_file_acl;
 	dnode_t		*n;
 	struct inode_el	*ino_el;
 	struct dup_block	*db;
 	struct dup_inode	*di;
+	int ret;
 
 	clear_problem_context(&pctx);
 	cs.errcode = 0;
@@ -742,9 +750,10 @@ static int clone_file(e2fsck_t ctx, ext2
 	/* The inode may have changed on disk, so we have to re-read it */
 	e2fsck_read_inode(ctx, ino, &dp->inode, "clone file EA");
 	blk = dp->inode.i_file_acl;
-	if (blk && (clone_file_block(fs, &dp->inode.i_file_acl,
-				     BLOCK_COUNT_EXTATTR, 0, 0, &cs) ==
-		    BLOCK_CHANGED)) {
+	i_file_acl = dp->inode.i_file_acl;
+	ret = clone_file_block(fs, &i_file_acl, BLOCK_COUNT_EXTATTR, 0, 0, &cs);
+	dp->inode.i_file_acl = i_file_acl;
+	if (blk && (ret == BLOCK_CHANGED)) {
 		e2fsck_write_inode(ctx, ino, &dp->inode, "clone file EA");
 		/*
 		 * If we cloned the EA block, find all other inodes
Index: e2fsprogs-1.39/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass5.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/pass5.c	2006-09-19 20:50:27.000000000 +0200
@@ -114,8 +114,8 @@ static void check_block_bitmaps(e2fsck_t
 	blk_t	i, super;
 	int	*free_array;
 	int	group = 0;
-	unsigned int	blocks = 0;
-	unsigned int	free_blocks = 0;
+	blk_t	blocks = 0;
+	blk_t	free_blocks = 0;
 	int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
Index: e2fsprogs-1.39/e2fsck/recovery.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/recovery.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/recovery.c	2006-09-19 19:20:58.000000000 +0200
@@ -70,7 +70,7 @@ static int do_readahead(journal_t *journ
 {
 	int err;
 	unsigned int max, nbufs, next;
-	unsigned long blocknr;
+	blk_t blocknr;
 	struct buffer_head *bh;
 	
 	struct buffer_head * bufs[MAXBUF];
@@ -132,7 +132,7 @@ static int jread(struct buffer_head **bh
 		 unsigned int offset)
 {
 	int err;
-	unsigned long blocknr;
+	blk_t blocknr;
 	struct buffer_head *bh;
 
 	*bhp = NULL;
Index: e2fsprogs-1.39/e2fsck/super.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/super.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/e2fsck/super.c	2006-09-19 20:50:27.000000000 +0200
@@ -23,8 +23,8 @@
 #define MAX_CHECK 2
 
 static void check_super_value(e2fsck_t ctx, const char *descr,
-			      unsigned long value, int flags,
-			      unsigned long min_val, unsigned long max_val)
+			      blk_t value, int flags,
+			      blk_t min_val, blk_t max_val)
 {
 	struct		problem_context pctx;
 
@@ -114,7 +114,7 @@ static int release_inode_block(ext2_fils
 		 */
 		if (blockcnt < 0) {
 			int	i, limit;
-			blk_t	*bp;
+			pblk_t	*bp;
 			
 			pb->errcode = io_channel_read_blk(fs->io, blk, 1,
 							pb->buf);
@@ -122,7 +122,7 @@ static int release_inode_block(ext2_fils
 				goto return_abort;
 
 			limit = fs->blocksize >> 2;
-			for (i = 0, bp = (blk_t *) pb->buf;
+			for (i = 0, bp = (pblk_t *) pb->buf;
 			     i < limit;	 i++, bp++)
 				if (*bp)
 					return 0;
@@ -423,7 +423,7 @@ void check_resize_inode(e2fsck_t ctx)
 		for (j = 1; j < fs->group_desc_count; j++) {
 			if (!ext2fs_bg_has_super(fs, j))
 				continue;
-			expect = pblk + (j * fs->super->s_blocks_per_group);
+			expect = pblk + (j * (blk_t)fs->super->s_blocks_per_group);
 			if (ind_buf[ind_off] != expect)
 				goto resize_inode_invalid;
 			ind_off++;
Index: e2fsprogs-1.39/ext2ed/blockbitmap_com.c
===================================================================
--- e2fsprogs-1.39.orig/ext2ed/blockbitmap_com.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/ext2ed/blockbitmap_com.c	2006-09-19 19:20:58.000000000 +0200
@@ -249,7 +249,7 @@ The current position (as known from bloc
 	wprintw (show_win,"Block bitmap of block group %ld\n",block_bitmap_info.group_num);
 										/* Show the block number */
 										
-	block_num=block_bitmap_info.entry_num+block_bitmap_info.group_num*file_system_info.super_block.s_blocks_per_group;
+	block_num=block_bitmap_info.entry_num+block_bitmap_info.group_num*(blk_t)file_system_info.super_block.s_blocks_per_group;
 	block_num+=file_system_info.super_block.s_first_data_block;	
 
 	wprintw (show_win,"Status of block %ld - ",block_num);			/* and the allocation status */
Index: e2fsprogs-1.39/ext2ed/ext2ed.h
===================================================================
--- e2fsprogs-1.39.orig/ext2ed/ext2ed.h	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/ext2ed/ext2ed.h	2006-09-19 19:20:58.000000000 +0200
@@ -202,7 +202,7 @@ extern int ForceDefault;
 extern char device_name [80];
 extern char last_command_line [80];
 extern FILE *device_handle;
-extern long device_offset;
+extern blk_t device_offset;
 extern int  mounted;
 
 extern short block_size;
Index: e2fsprogs-1.39/ext2ed/group_com.c
===================================================================
--- e2fsprogs-1.39.orig/ext2ed/group_com.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/ext2ed/group_com.c	2006-09-19 20:50:27.000000000 +0200
@@ -90,7 +90,7 @@ void type_ext2_group_desc___gocopy (char
 
 	copy_num=atol (buffer);
 	
-	offset=file_system_info.first_group_desc_offset+copy_num*file_system_info.super_block.s_blocks_per_group*file_system_info.block_size;
+	offset=file_system_info.first_group_desc_offset+copy_num*(blk_t)file_system_info.super_block.s_blocks_per_group*file_system_info.block_size;
 	
 	if (offset > file_system_info.file_system_size) {
 		wprintw (command_win,"Error - Copy number out of bounds\n");refresh_command_win ();return;
@@ -134,39 +134,39 @@ void type_ext2_group_desc___show (char *
 void type_ext2_group_desc___inode (char *command_line)
 
 {
-	long inode_offset;
+	blk_t inode_offset;
 	char buffer [80];
 	
 	inode_offset=type_data.u.t_ext2_group_desc.bg_inode_table;
-	sprintf (buffer,"setoffset block %ld",inode_offset);dispatch (buffer);
+	sprintf (buffer,"setoffset block %lu",inode_offset);dispatch (buffer);
 	sprintf (buffer,"settype ext2_inode");dispatch (buffer);
 }
 
 void type_ext2_group_desc___blockbitmap (char *command_line)
 
 {
-	long block_bitmap_offset;
+	blk_t block_bitmap_offset;
 	char buffer [80];
 	
 	block_bitmap_info.entry_num=0;
 	block_bitmap_info.group_num=group_info.group_num;
 	
 	block_bitmap_offset=type_data.u.t_ext2_group_desc.bg_block_bitmap;
-	sprintf (buffer,"setoffset block %ld",block_bitmap_offset);dispatch (buffer);
+	sprintf (buffer,"setoffset block %lu",block_bitmap_offset);dispatch (buffer);
 	sprintf (buffer,"settype block_bitmap");dispatch (buffer);
 }
 
 void type_ext2_group_desc___inodebitmap (char *command_line)
 
 {
-	long inode_bitmap_offset;
+	blk_t inode_bitmap_offset;
 	char buffer [80];
 	
 	inode_bitmap_info.entry_num=0;
 	inode_bitmap_info.group_num=group_info.group_num;
 	
 	inode_bitmap_offset=type_data.u.t_ext2_group_desc.bg_inode_bitmap;
-	sprintf (buffer,"setoffset block %ld",inode_bitmap_offset);dispatch (buffer);
+	sprintf (buffer,"setoffset block %lu",inode_bitmap_offset);dispatch (buffer);
 	sprintf (buffer,"settype inode_bitmap");dispatch (buffer);
 }
 
Index: e2fsprogs-1.39/ext2ed/inode_com.c
===================================================================
--- e2fsprogs-1.39.orig/ext2ed/inode_com.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/ext2ed/inode_com.c	2006-09-19 20:50:27.000000000 +0200
@@ -25,7 +25,8 @@ void type_ext2_inode___prev (char *comma
 
 	char *ptr,buffer [80];
 
-	long group_num,group_offset,entry_num,block_num,first_entry,last_entry;
+	blk_t block_num,group_offset;
+	long group_num,entry_num,first_entry,last_entry;
 	long inode_num,mult=1;
 	struct ext2_group_desc desc;
 
@@ -52,7 +53,7 @@ void type_ext2_inode___prev (char *comma
 		device_offset-=sizeof (struct ext2_inode)*mult;
 		entry_num-=mult;
 		
-		sprintf (buffer,"setoffset %ld",device_offset);dispatch (buffer);
+		sprintf (buffer,"setoffset %lu",device_offset);dispatch (buffer);
 		strcpy (buffer,"show");dispatch (buffer);
 	}
 
@@ -72,7 +73,8 @@ void type_ext2_inode___next (char *comma
 
 	char *ptr,buffer [80];
 
-	long group_num,group_offset,entry_num,block_num,first_entry,last_entry;
+	blk_t group_offset,block_num;
+	long group_num,entry_num,first_entry,last_entry;
 	long inode_num,mult=1;
 	struct ext2_group_desc desc;
 
@@ -123,7 +125,8 @@ void type_ext2_inode___show (char *comma
 	unsigned short temp;
 	int i;
 	
-	long group_num,group_offset,entry_num,block_num,first_entry,last_entry,inode_num;
+	blk_t group_offset,block_num;
+	long group_num,entry_num,first_entry,last_entry,inode_num;
 	struct ext2_group_desc desc;
 
 	block_num=device_offset/file_system_info.block_size;
@@ -284,7 +287,8 @@ void type_ext2_inode___entry (char *comm
 {
 	char *ptr,buffer [80];
 
-	long group_num,group_offset,entry_num,block_num,wanted_entry;
+	blk_t group_offset,block_num;
+	long group_num,entry_num,wanted_entry;
 	struct ext2_group_desc desc;
 
 	ptr=parse_word (command_line,buffer);
@@ -372,7 +376,8 @@ long inode_offset_to_group_num (long ino
 	int found=0;
 	struct ext2_group_desc desc;
 	
-	long block_num,group_offset,group_num;
+	blk_t block_num,group_offset;
+	long group_num;
 	
 	block_num=inode_offset/file_system_info.block_size;
 
@@ -399,7 +404,8 @@ long inode_offset_to_group_num (long ino
 long int inode_offset_to_inode_num (long inode_offset)
 
 {
-	long group_num,group_offset,entry_num,block_num,first_entry,last_entry,inode_num;
+	blk_t group_offset, block_num;
+	long group_num,entry_num,first_entry,last_entry,inode_num;
 	struct ext2_group_desc desc;
 
 	block_num=inode_offset/file_system_info.block_size;
@@ -409,7 +415,9 @@ long int inode_offset_to_inode_num (long
 
 	low_read ((char *) &desc,sizeof (struct ext2_group_desc),group_offset);
 
-	entry_num=(inode_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof (struct ext2_inode);
+	entry_num=((inode_offset-desc.bg_inode_table*file_system_info.block_size)/sizeof(struct ext2_inode);
+		file_system_info.block_size)/
+		sizeof (struct ext2_inode);
 	first_entry=0;last_entry=file_system_info.super_block.s_inodes_per_group-1;
 	inode_num=group_num*file_system_info.super_block.s_inodes_per_group+1;
 	inode_num+=entry_num;
@@ -420,7 +428,8 @@ long int inode_offset_to_inode_num (long
 long int inode_num_to_inode_offset (long inode_num)
 
 {
-	long group_num,group_offset,inode_offset,inode_entry;
+	blk_t group_offset, inode_offset;
+	long group_num,inode_entry;
 	struct ext2_group_desc desc;
 
 	inode_num--;
Index: e2fsprogs-1.39/ext2ed/main.c
===================================================================
--- e2fsprogs-1.39.orig/ext2ed/main.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/ext2ed/main.c	2006-09-19 19:20:58.000000000 +0200
@@ -69,7 +69,7 @@ char last_command_line [80];			/* A simp
 
 char device_name [80];				/* The location of the filesystem */
 FILE *device_handle=NULL;			/* This is passed to the fopen / fread ... commands */
-long device_offset;				/* The current position in the filesystem */
+blk_t device_offset;				/* The current position in the filesystem */
 						/* Note that we have a 2 GB limitation */
 					
 int mounted=0;					/* This is set when we find that the filesystem is mounted */
Index: e2fsprogs-1.39/lib/ext2fs/badblocks.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/badblocks.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/badblocks.c	2006-09-19 19:20:58.000000000 +0200
@@ -42,15 +42,15 @@ static errcode_t make_u32_list(int size,
 	bb->magic = EXT2_ET_MAGIC_BADBLOCKS_LIST;
 	bb->size = size ? size : 10;
 	bb->num = num;
-	retval = ext2fs_get_mem(bb->size * sizeof(blk_t), &bb->list);
+	retval = ext2fs_get_mem(bb->size * sizeof(pblk_t), &bb->list);
 	if (!bb->list) {
 		ext2fs_free_mem(&bb);
 		return retval;
 	}
 	if (list)
-		memcpy(bb->list, list, bb->size * sizeof(blk_t));
+		memcpy(bb->list, list, bb->size * sizeof(pblk_t));
 	else
-		memset(bb->list, 0, bb->size * sizeof(blk_t));
+		memset(bb->list, 0, bb->size * sizeof(pblk_t));
 	*ret = bb;
 	return 0;
 }
@@ -282,8 +282,13 @@ int ext2fs_u32_list_iterate(ext2_u32_ite
 
 int ext2fs_badblocks_list_iterate(ext2_badblocks_iterate iter, blk_t *blk)
 {
-	return ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
-				       (__u32 *) blk);
+	int ret;
+	__u32 b = *blk;
+
+	ret = ext2fs_u32_list_iterate((ext2_u32_iterate) iter,
+				       &b);
+	*blk = b;
+	return ret;
 }
 
 
@@ -310,7 +315,7 @@ int ext2fs_u32_list_equal(ext2_u32_list 
 	if (bb1->num != bb2->num)
 		return 0;
 
-	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(blk_t)) != 0)
+	if (memcmp(bb1->list, bb2->list, bb1->num * sizeof(pblk_t)) != 0)
 		return 0;
 	return 1;
 }
Index: e2fsprogs-1.39/lib/ext2fs/bb_inode.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bb_inode.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bb_inode.c	2006-09-19 20:50:27.000000000 +0200
@@ -33,7 +33,7 @@
 struct set_badblock_record {
 	ext2_badblocks_iterate	bb_iter;
 	int		bad_block_count;
-	blk_t		*ind_blocks;
+	pblk_t		*ind_blocks;
 	int		max_ind_blocks;
 	int		ind_blocks_size;
 	int		ind_blocks_ptr;
@@ -68,11 +68,11 @@ errcode_t ext2fs_update_bb_inode(ext2_fi
 	rec.bad_block_count = 0;
 	rec.ind_blocks_size = rec.ind_blocks_ptr = 0;
 	rec.max_ind_blocks = 10;
-	retval = ext2fs_get_mem(rec.max_ind_blocks * sizeof(blk_t),
+	retval = ext2fs_get_mem(rec.max_ind_blocks * sizeof(pblk_t),
 				&rec.ind_blocks);
 	if (retval)
 		return retval;
-	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(blk_t));
+	memset(rec.ind_blocks, 0, rec.max_ind_blocks * sizeof(pblk_t));
 	retval = ext2fs_get_mem(fs->blocksize, &rec.block_buf);
 	if (retval)
 		goto cleanup;
@@ -174,10 +174,10 @@ static int clear_bad_block_proc(ext2_fil
 
 	if (blockcnt < 0) {
 		if (rec->ind_blocks_size >= rec->max_ind_blocks) {
-			old_size = rec->max_ind_blocks * sizeof(blk_t);
+			old_size = rec->max_ind_blocks * sizeof(pblk_t);
 			rec->max_ind_blocks += 10;
 			retval = ext2fs_resize_mem(old_size, 
-				   rec->max_ind_blocks * sizeof(blk_t),
+				   rec->max_ind_blocks * sizeof(pblk_t),
 				   &rec->ind_blocks);
 			if (retval) {
 				rec->max_ind_blocks -= 10;
Index: e2fsprogs-1.39/lib/ext2fs/bitmaps.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bitmaps.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bitmaps.c	2006-09-19 20:52:15.000000000 +0200
@@ -27,7 +27,7 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-static errcode_t make_bitmap(__u32 start, __u32 end, __u32 real_end,
+static errcode_t make_bitmap(blk_t start, blk_t end, blk_t real_end,
 			     const char *descr, char *init_map,
 			     ext2fs_generic_bitmap *ret)
 {
@@ -72,9 +72,9 @@ static errcode_t make_bitmap(__u32 start
 	return 0;
 }
 
-errcode_t ext2fs_allocate_generic_bitmap(__u32 start,
-					 __u32 end,
-					 __u32 real_end,
+errcode_t ext2fs_allocate_generic_bitmap(blk_t start,
+					 blk_t end,
+					 blk_t real_end,
 					 const char *descr,
 					 ext2fs_generic_bitmap *ret)
 {
@@ -100,7 +100,7 @@ errcode_t ext2fs_copy_bitmap(ext2fs_gene
 
 void ext2fs_set_bitmap_padding(ext2fs_generic_bitmap map)
 {
-	__u32	i, j;
+	blk_t	i, j;
 
 	/* Protect loop from wrap-around if map->real_end is maxed */
 	for (i=map->end+1, j = i - map->start; 
@@ -117,7 +117,7 @@ errcode_t ext2fs_allocate_inode_bitmap(e
 {
 	ext2fs_inode_bitmap bitmap;
 	errcode_t	retval;
-	__u32		start, end, real_end;
+	blk_t		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -146,7 +146,7 @@ errcode_t ext2fs_allocate_block_bitmap(e
 {
 	ext2fs_block_bitmap bitmap;
 	errcode_t	retval;
-	__u32		start, end, real_end;
+	blk_t		start, end, real_end;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
Index: e2fsprogs-1.39/lib/ext2fs/block.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/block.c	2006-09-19 19:20:58.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/block.c	2006-09-19 20:50:27.000000000 +0200
@@ -33,7 +33,7 @@ static int block_iterate_ind(blk_t *ind_
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	pblk_t	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
@@ -58,33 +58,38 @@ static int block_iterate_ind(blk_t *ind_
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->ind_buf;
+	block_nr = (pblk_t *) ctx->ind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			blk_t b = *block_nr;
+			flags = (*ctx->func)(ctx->fs, &b, ctx->bcount,
 					     *ind_block, offset, 
 					     ctx->priv_data);
+			*block_nr = b;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	} else {
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
+			blk_t b;
 			if (*block_nr == 0)
 				continue;
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			b = *block_nr;
+			flags = (*ctx->func)(ctx->fs, &b, ctx->bcount,
 					     *ind_block, offset, 
 					     ctx->priv_data);
+			*block_nr = b;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -107,7 +112,7 @@ static int block_iterate_dind(blk_t *din
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	pblk_t	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
@@ -132,35 +137,41 @@ static int block_iterate_dind(blk_t *din
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->dind_buf;
+	block_nr = (pblk_t *) ctx->dind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, block_nr++) {
-			flags = block_iterate_ind(block_nr,
+			blk_t b;
+			b = *block_nr;
+			flags = block_iterate_ind(&b,
 						  *dind_block, offset,
 						  ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	} else {
 		for (i = 0; i < limit; i++, block_nr++) {
+			blk_t b;
 			if (*block_nr == 0) {
 				ctx->bcount += limit;
 				continue;
 			}
-			flags = block_iterate_ind(block_nr,
+			b = *block_nr;
+			flags = block_iterate_ind(&b,
 						  *dind_block, offset,
 						  ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -183,7 +194,7 @@ static int block_iterate_tind(blk_t *tin
 {
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
-	blk_t	*block_nr;
+	pblk_t	*block_nr;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
@@ -208,35 +219,41 @@ static int block_iterate_tind(blk_t *tin
 		return ret;
 	}
 
-	block_nr = (blk_t *) ctx->tind_buf;
+	block_nr = (pblk_t *) ctx->tind_buf;
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, block_nr++) {
-			flags = block_iterate_dind(block_nr,
+			blk_t b;
+			b = *block_nr;
+			flags = block_iterate_dind(&b,
 						   *tind_block,
 						   offset, ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	} else {
 		for (i = 0; i < limit; i++, block_nr++) {
+			blk_t b;
 			if (*block_nr == 0) {
 				ctx->bcount += limit*limit;
 				continue;
 			}
-			flags = block_iterate_dind(block_nr,
+			b = *block_nr;
+			flags = block_iterate_dind(&b,
 						   *tind_block,
 						   offset, ctx);
+			*block_nr = b;
 			changed |= flags;
 			if (flags & (BLOCK_ABORT | BLOCK_ERROR)) {
 				ret |= flags & (BLOCK_ABORT | BLOCK_ERROR);
 				break;
 			}
-			offset += sizeof(blk_t);
+			offset += sizeof(pblk_t);
 		}
 	}
 	if (changed & BLOCK_CHANGED) {
@@ -269,7 +286,7 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 {
 	int	i;
 	int	ret = 0;
-	blk_t	blocks[EXT2_N_BLOCKS];	/* directory data blocks */
+	pblk_t	blocks[EXT2_N_BLOCKS];	/* directory data blocks */
 	struct ext2_inode inode;
 	errcode_t	retval;
 	struct block_context ctx;
@@ -319,10 +336,12 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 	if ((fs->super->s_creator_os == EXT2_OS_HURD) &&
 	    !(flags & BLOCK_FLAG_DATA_ONLY)) {
 		if (inode.osd1.hurd1.h_i_translator) {
+			blk_t h_i_translator = inode.osd1.hurd1.h_i_translator;
 			ret |= (*ctx.func)(fs,
-					   &inode.osd1.hurd1.h_i_translator,
+					   &h_i_translator,
 					   BLOCK_COUNT_TRANSLATOR,
 					   0, 0, priv_data);
+			inode.osd1.hurd1.h_i_translator = h_i_translator;
 			if (ret & BLOCK_ABORT)
 				goto abort_exit;
 		}
@@ -346,29 +365,38 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 	 */
 	for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
 		if (blocks[i] || (flags & BLOCK_FLAG_APPEND)) {
-			ret |= (*ctx.func)(fs, &blocks[i],
+			blk_t b = blocks[i];
+			ret |= (*ctx.func)(fs, &b,
 					    ctx.bcount, 0, i, priv_data);
+			blocks[i] = b;
 			if (ret & BLOCK_ABORT)
 				goto abort_exit;
 		}
 	}
 	if (*(blocks + EXT2_IND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_ind(blocks + EXT2_IND_BLOCK,
+		blk_t b;
+		b = *(blocks + EXT2_IND_BLOCK);
+		ret |= block_iterate_ind(&b,
 					 0, EXT2_IND_BLOCK, &ctx);
+		*(blocks + EXT2_IND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	} else
 		ctx.bcount += limit;
 	if (*(blocks + EXT2_DIND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_dind(blocks + EXT2_DIND_BLOCK,
+		blk_t b = *(blocks + EXT2_DIND_BLOCK);
+		ret |= block_iterate_dind(&b,
 					  0, EXT2_DIND_BLOCK, &ctx);
+		*(blocks + EXT2_DIND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	} else
 		ctx.bcount += limit * limit;
 	if (*(blocks + EXT2_TIND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_tind(blocks + EXT2_TIND_BLOCK,
+		blk_t b = *(blocks + EXT2_TIND_BLOCK);
+		ret |= block_iterate_tind(&b,
 					  0, EXT2_TIND_BLOCK, &ctx);
+		*(blocks + EXT2_TIND_BLOCK) = b;
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	}
Index: e2fsprogs-1.39/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bmap.c	2006-09-19 19:20:58.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bmap.c	2006-09-19 20:50:27.000000000 +0200
@@ -115,11 +115,11 @@ static _BMAP_INLINE_ errcode_t block_ind
 		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
 			b = ext2fs_swab32(b);
 #endif
-		((blk_t *) block_buf)[nr] = b;
+		((pblk_t *) block_buf)[nr] = b;
 		return io_channel_write_blk(fs->io, ind, 1, block_buf);
 	}
 
-	b = ((blk_t *) block_buf)[nr];
+	b = ((pblk_t *) block_buf)[nr];
 
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
@@ -128,7 +128,7 @@ static _BMAP_INLINE_ errcode_t block_ind
 #endif
 
 	if (!b && (flags & BMAP_ALLOC)) {
-		b = nr ? ((blk_t *) block_buf)[nr-1] : 0;
+		b = nr ? ((pblk_t *) block_buf)[nr-1] : 0;
 		retval = ext2fs_alloc_block(fs, b,
 					    block_buf + fs->blocksize, &b);
 		if (retval)
@@ -137,10 +137,10 @@ static _BMAP_INLINE_ errcode_t block_ind
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if ((fs->flags & EXT2_FLAG_SWAP_BYTES) ||
 		    (fs->flags & EXT2_FLAG_SWAP_BYTES_WRITE))
-			((blk_t *) block_buf)[nr] = ext2fs_swab32(b);
+			((pblk_t *) block_buf)[nr] = ext2fs_swab32(b);
 		else
 #endif
-			((blk_t *) block_buf)[nr] = b;
+			((pblk_t *) block_buf)[nr] = b;
 
 		retval = io_channel_write_blk(fs->io, ind, 1, block_buf);
 		if (retval)
Index: e2fsprogs-1.39/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext2fs.h	2006-09-19 19:20:58.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ext2fs.h	2006-09-19 20:50:27.000000000 +0200
@@ -74,6 +74,7 @@ extern "C" {
 
 typedef __u32		ext2_ino_t;
 typedef __u32		blk_t;
+typedef __u32		pblk_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
 typedef __s64		e2_blkcnt_t;
@@ -105,8 +106,8 @@ typedef struct struct_ext2_filsys *ext2_
 struct ext2fs_struct_generic_bitmap {
 	errcode_t	magic;
 	ext2_filsys 	fs;
-	__u32		start, end;
-	__u32		real_end;
+	blk_t		start, end;
+	blk_t		real_end;
 	char	*	description;
 	char	*	bitmap;
 	errcode_t	base_error_code;
@@ -217,7 +218,7 @@ struct struct_ext2_filsys {
 	int				inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
-	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
+	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, pblk_t *blocks);
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
 	errcode_t (*write_bitmaps)(ext2_filsys fs);
 	errcode_t (*read_inode)(ext2_filsys fs, ext2_ino_t ino,
@@ -427,7 +428,7 @@ typedef struct ext2_icount *ext2_icount_
 /*
  * For ext2 compression support
  */
-#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) 0xffffffff)
+#define EXT2FS_COMPRESSED_BLKADDR ((blk_t) -1)
 #define HOLE_BLKADDR(_b) ((_b) == 0 || (_b) == EXT2FS_COMPRESSED_BLKADDR)
 
 /*
@@ -500,10 +501,10 @@ extern errcode_t ext2fs_allocate_group_t
 extern errcode_t ext2fs_u32_list_create(ext2_u32_list *ret, int size);
 extern errcode_t ext2fs_u32_list_add(ext2_u32_list bb, __u32 blk);
 extern int ext2fs_u32_list_find(ext2_u32_list bb, __u32 blk);
-extern int ext2fs_u32_list_test(ext2_u32_list bb, blk_t blk);
+extern int ext2fs_u32_list_test(ext2_u32_list bb, pblk_t blk);
 extern errcode_t ext2fs_u32_list_iterate_begin(ext2_u32_list bb,
 					       ext2_u32_iterate *ret);
-extern int ext2fs_u32_list_iterate(ext2_u32_iterate iter, blk_t *blk);
+extern int ext2fs_u32_list_iterate(ext2_u32_iterate iter, pblk_t *blk);
 extern void ext2fs_u32_list_iterate_end(ext2_u32_iterate iter);
 extern errcode_t ext2fs_u32_copy(ext2_u32_list src, ext2_u32_list *dest);
 extern int ext2fs_u32_list_equal(ext2_u32_list bb1, ext2_u32_list bb2);
@@ -547,9 +548,9 @@ extern errcode_t ext2fs_write_inode_bitm
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
-extern errcode_t ext2fs_allocate_generic_bitmap(__u32 start,
-						__u32 end,
-						__u32 real_end,
+extern errcode_t ext2fs_allocate_generic_bitmap(blk_t start,
+						blk_t end,
+						blk_t real_end,
 						const char *descr,
 						ext2fs_generic_bitmap *ret);
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
@@ -845,7 +846,7 @@ extern errcode_t ext2fs_write_inode(ext2
 			    struct ext2_inode * inode);
 extern errcode_t ext2fs_write_new_inode(ext2_filsys fs, ext2_ino_t ino,
 			    struct ext2_inode * inode);
-extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
+extern errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, pblk_t *blocks);
 extern errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino);
 
 /* inode_io.c */
Index: e2fsprogs-1.39/lib/ext2fs/ind_block.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ind_block.c	2006-09-19 19:20:58.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/ind_block.c	2006-09-19 19:20:58.000000000 +0200
@@ -34,7 +34,7 @@ errcode_t ext2fs_read_ind_block(ext2_fil
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_READ)) {
 		int	limit = fs->blocksize >> 2;
-		blk_t	*block_nr = (blk_t *)buf;
+		pblk_t	*block_nr = (pblk_t *)buf;
 		int	i;
 
 		for (i = 0; i < limit; i++, block_nr++)
@@ -52,7 +52,7 @@ errcode_t ext2fs_write_ind_block(ext2_fi
 #ifdef EXT2FS_ENABLE_SWAPFS
 	if (fs->flags & (EXT2_FLAG_SWAP_BYTES | EXT2_FLAG_SWAP_BYTES_WRITE)) {
 		int	limit = fs->blocksize >> 2;
-		blk_t	*block_nr = (blk_t *)buf;
+		pblk_t	*block_nr = (pblk_t *)buf;
 		int	i;
 
 		for (i = 0; i < limit; i++, block_nr++)
Index: e2fsprogs-1.39/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/inode.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/inode.c	2006-09-19 20:50:27.000000000 +0200
@@ -107,7 +107,7 @@ errcode_t ext2fs_open_inode_scan(ext2_fi
 {
 	ext2_inode_scan	scan;
 	errcode_t	retval;
-	errcode_t (*save_get_blocks)(ext2_filsys f, ext2_ino_t ino, blk_t *blocks);
+	errcode_t (*save_get_blocks)(ext2_filsys f, ext2_ino_t ino, pblk_t *blocks);
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -502,7 +502,8 @@ errcode_t ext2fs_get_next_inode(ext2_ino
 errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 				 struct ext2_inode * inode, int bufsize)
 {
-	unsigned long 	group, block, block_nr, offset;
+	unsigned long 	group, block, offset;
+	blk_t		block_nr;
 	char 		*ptr;
 	errcode_t	retval;
 	int 		clen, i, inodes_per_block, length;
@@ -608,7 +609,8 @@ errcode_t ext2fs_read_inode(ext2_filsys 
 errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 				  struct ext2_inode * inode, int bufsize)
 {
-	unsigned long group, block, block_nr, offset;
+	unsigned long group, block, offset;
+	blk_t block_nr;
 	errcode_t retval = 0;
 	struct ext2_inode_large temp_inode, *w_inode;
 	char *ptr;
@@ -753,7 +755,7 @@ errcode_t ext2fs_write_new_inode(ext2_fi
 }
 
  
-errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks)
+errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, pblk_t *blocks)
 {
 	struct ext2_inode	inode;
 	int			i;
Index: e2fsprogs-1.39/lib/ext2fs/res_gdt.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/res_gdt.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/res_gdt.c	2006-09-19 19:20:58.000000000 +0200
@@ -166,7 +166,7 @@ errcode_t ext2fs_create_resize_inode(ext
 
 		while ((grp = list_backups(fs, &three, &five, &seven)) <
 		       fs->group_desc_count) {
-			blk_t expect = gdt_blk + grp * sb->s_blocks_per_group;
+			blk_t expect = gdt_blk + grp * (blk_t)sb->s_blocks_per_group;
 
 			if (!gdt_buf[last]) {
 #ifdef RES_GDT_DEBUG
Index: e2fsprogs-1.39/lib/ext2fs/tst_iscan.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/tst_iscan.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/tst_iscan.c	2006-09-19 20:50:27.000000000 +0200
@@ -171,7 +171,7 @@ static void iterate(void)
 static void check_map(void)
 {
 	int	i, j, first=1;
-	unsigned long	blk;
+	blk_t	blk;
 
 	for (i=0; test_vec[i]; i++) {
 		if (ext2fs_test_block_bitmap(touched_map, test_vec[i])) {
Index: e2fsprogs-1.39/misc/dumpe2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/dumpe2fs.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/misc/dumpe2fs.c	2006-09-19 20:50:27.000000000 +0200
@@ -55,20 +55,20 @@ static void usage(void)
 	exit (1);
 }
 
-static void print_number(unsigned long num)
+static void print_number(blk_t num)
 {
 	if (hex_format) 
-		printf("0x%04lx", num);
+		printf("0x%04x", num);
 	else
-		printf("%lu", num);
+		printf("%u", num);
 }
 
-static void print_range(unsigned long a, unsigned long b)
+static void print_range(blk_t a, blk_t b)
 {
 	if (hex_format) 
-		printf("0x%04lx-0x%04lx", a, b);
+		printf("0x%04x-0x%04x", a, b);
 	else
-		printf("%lu-%lu", a, b);
+		printf("%u-%u", a, b);
 }
 
 static void print_free (unsigned long group, char * bitmap,
Index: e2fsprogs-1.39/misc/e2image.c
===================================================================
--- e2fsprogs-1.39.orig/misc/e2image.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/misc/e2image.c	2006-09-19 20:50:27.000000000 +0200
@@ -165,7 +165,7 @@ static struct ext2_inode *stashed_inode;
 
 static errcode_t meta_get_blocks(ext2_filsys fs EXT2FS_ATTR((unused)), 
 				 ext2_ino_t ino,
-				 blk_t *blocks)
+				 pblk_t *blocks)
 {
 	int	i;
 	
Index: e2fsprogs-1.39/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/mke2fs.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/misc/mke2fs.c	2006-09-19 20:50:27.000000000 +0200
@@ -684,10 +684,10 @@ static void show_stats(ext2_filsys fs)
 	       100.0 * s->s_r_blocks_count / s->s_blocks_count);
 	printf(_("First data block=%u\n"), s->s_first_data_block);
 	if (s->s_reserved_gdt_blocks)
-		printf(_("Maximum filesystem blocks=%lu\n"),
-		       (s->s_reserved_gdt_blocks + fs->desc_blocks) *
+		printf(_("Maximum filesystem blocks=%u\n"),
+		       (blk_t)((s->s_reserved_gdt_blocks + fs->desc_blocks) *
 		       (fs->blocksize / sizeof(struct ext2_group_desc)) *
-		       s->s_blocks_per_group);
+		       s->s_blocks_per_group));
 	if (fs->group_desc_count > 1)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
@@ -1399,13 +1399,6 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
-	if (!force && fs_param.s_blocks_count >= (1 << 31)) {
-		com_err(program_name, 0,
-			_("Filesystem too large.  No more than 2**31-1 blocks\n"
-			  "\t (8TB using a blocksize of 4k) are currently supported."));
-             exit(1);
-	}
-
 	if ((blocksize > 4096) &&
 	    (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
Index: e2fsprogs-1.39/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.39.orig/misc/tune2fs.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/misc/tune2fs.c	2006-09-19 20:50:27.000000000 +0200
@@ -64,7 +64,8 @@ static int m_flag, M_flag, r_flag, s_fla
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
-static unsigned long interval, reserved_blocks;
+static unsigned long interval;
+static blk_t reserved_blocks;
 static double reserved_ratio;
 static unsigned long resgid, resuid;
 static unsigned short errors;
@@ -832,13 +833,13 @@ int main (int argc, char ** argv)
 	if (r_flag) {
 		if (reserved_blocks >= sb->s_blocks_count/2) {
 			com_err (program_name, 0,
-				 _("reserved blocks count is too big (%lu)"),
+				 _("reserved blocks count is too big (%u)"),
 				 reserved_blocks);
 			exit (1);
 		}
 		sb->s_r_blocks_count = reserved_blocks;
 		ext2fs_mark_super_dirty(fs);
-		printf (_("Setting reserved blocks count to %lu\n"),
+		printf (_("Setting reserved blocks count to %u\n"),
 			reserved_blocks);
 	}
 	if (s_flag == 1) {
Index: e2fsprogs-1.39/resize/resize2fs.c
===================================================================
--- e2fsprogs-1.39.orig/resize/resize2fs.c	2006-09-19 19:18:10.000000000 +0200
+++ e2fsprogs-1.39/resize/resize2fs.c	2006-09-19 20:50:27.000000000 +0200
@@ -901,7 +901,8 @@ static blk_t get_new_block(ext2_resize_t
 
 static errcode_t block_mover(ext2_resize_t rfs)
 {
-	blk_t			blk, old_blk, new_blk;
+	blk_t			blk;
+	pblk_t			old_blk, new_blk;
 	ext2_filsys		fs = rfs->new_fs;
 	ext2_filsys		old_fs = rfs->old_fs;
 	errcode_t		retval;
Index: e2fsprogs-1.39/lib/ext2fs/bitops.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bitops.c	2006-09-19 20:50:27.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bitops.c	2006-09-19 20:52:15.000000000 +0200
@@ -30,7 +30,7 @@
  * systems, as well as non-32 bit systems.
  */
 
-int ext2fs_set_bit(unsigned int nr,void * addr)
+int ext2fs_set_bit(blk_t nr,void * addr)
 {
 	int		mask, retval;
 	unsigned char	*ADDR = (unsigned char *) addr;
@@ -42,7 +42,7 @@ int ext2fs_set_bit(unsigned int nr,void 
 	return retval;
 }
 
-int ext2fs_clear_bit(unsigned int nr, void * addr)
+int ext2fs_clear_bit(blk_t nr, void * addr)
 {
 	int		mask, retval;
 	unsigned char	*ADDR = (unsigned char *) addr;
@@ -54,7 +54,7 @@ int ext2fs_clear_bit(unsigned int nr, vo
 	return retval;
 }
 
-int ext2fs_test_bit(unsigned int nr, const void * addr)
+int ext2fs_test_bit(blk_t nr, const void * addr)
 {
 	int			mask;
 	const unsigned char	*ADDR = (const unsigned char *) addr;
Index: e2fsprogs-1.39/lib/ext2fs/gen_bitmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/gen_bitmap.c	2006-09-19 20:50:27.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/gen_bitmap.c	2006-09-19 20:52:15.000000000 +0200
@@ -28,7 +28,7 @@
 #include "ext2fs.h"
 
 int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					 __u32 bitno)
+					 blk_t bitno)
 {
 	if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
 		ext2fs_warn_bitmap2(bitmap, EXT2FS_MARK_ERROR, bitno);
Index: e2fsprogs-1.39/lib/ext2fs/bitops.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bitops.h	2006-09-19 20:50:27.000000000 +0200
+++ e2fsprogs-1.39/lib/ext2fs/bitops.h	2006-09-19 20:52:15.000000000 +0200
@@ -14,11 +14,11 @@
  */
 
 
-extern int ext2fs_set_bit(unsigned int nr,void * addr);
-extern int ext2fs_clear_bit(unsigned int nr, void * addr);
-extern int ext2fs_test_bit(unsigned int nr, const void * addr);
-extern void ext2fs_fast_set_bit(unsigned int nr,void * addr);
-extern void ext2fs_fast_clear_bit(unsigned int nr, void * addr);
+extern int ext2fs_set_bit(blk_t nr,void * addr);
+extern int ext2fs_clear_bit(blk_t nr, void * addr);
+extern int ext2fs_test_bit(blk_t nr, const void * addr);
+extern void ext2fs_fast_set_bit(blk_t nr,void * addr);
+extern void ext2fs_fast_clear_bit(blk_t nr, void * addr);
 extern __u16 ext2fs_swab16(__u16 val);
 extern __u32 ext2fs_swab32(__u32 val);
 
@@ -105,7 +105,7 @@ extern void ext2fs_set_bitmap_padding(ex
 
 /* These two routines moved to gen_bitmap.c */
 extern int ext2fs_mark_generic_bitmap(ext2fs_generic_bitmap bitmap,
-					 __u32 bitno);
+					 blk_t bitno);
 extern int ext2fs_unmark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 					   blk_t bitno);
 /*
@@ -140,7 +140,7 @@ extern int ext2fs_unmark_generic_bitmap(
  * previous bit value.
  */
 
-_INLINE_ void ext2fs_fast_set_bit(unsigned int nr,void * addr)
+_INLINE_ void ext2fs_fast_set_bit(blk_t nr,void * addr)
 {
 	unsigned char	*ADDR = (unsigned char *) addr;
 
@@ -148,7 +148,7 @@ _INLINE_ void ext2fs_fast_set_bit(unsign
 	*ADDR |= (1 << (nr & 0x07));
 }
 
-_INLINE_ void ext2fs_fast_clear_bit(unsigned int nr, void * addr)
+_INLINE_ void ext2fs_fast_clear_bit(blk_t nr, void * addr)
 {
 	unsigned char	*ADDR = (unsigned char *) addr;
 
@@ -158,7 +158,8 @@ _INLINE_ void ext2fs_fast_clear_bit(unsi
 
 
 #if ((defined __GNUC__) && !defined(_EXT2_USE_C_VERSIONS_) && \
-     (defined(__i386__) || defined(__i486__) || defined(__i586__)))
+     (defined(__i386__) || defined(__i486__) || defined(__i586__)) && \
+     !(defined(_EXT2_64BIT_BLK_T) && (SIZEOF_LONG == 4)))
 
 #define _EXT2_HAVE_ASM_BITOPS_
 #define _EXT2_HAVE_ASM_SWAB_
@@ -179,7 +180,7 @@ struct __dummy_h { unsigned long a[100];
 #define EXT2FS_ADDR (*(struct __dummy_h *) addr)
 #define EXT2FS_CONST_ADDR (*(const struct __dummy_h *) addr)	
 
-_INLINE_ int ext2fs_set_bit(unsigned int nr, void * addr)
+_INLINE_ int ext2fs_set_bit(blk_t nr, void * addr)
 {
 	int oldbit;
 
@@ -190,7 +191,7 @@ _INLINE_ int ext2fs_set_bit(unsigned int
 	return oldbit;
 }
 
-_INLINE_ int ext2fs_clear_bit(unsigned int nr, void * addr)
+_INLINE_ int ext2fs_clear_bit(blk_t nr, void * addr)
 {
 	int oldbit;
 
@@ -201,7 +202,7 @@ _INLINE_ int ext2fs_clear_bit(unsigned i
 	return oldbit;
 }
 
-_INLINE_ int ext2fs_test_bit(unsigned int nr, const void * addr)
+_INLINE_ int ext2fs_test_bit(blk_t nr, const void * addr)
 {
 	int oldbit;
 
@@ -305,7 +306,7 @@ _INLINE_ __u64 ext2fs_swab64(__u64 val)
 
 #define _EXT2_HAVE_ASM_BITOPS_
 
-_INLINE_ int ext2fs_set_bit(unsigned int nr,void * addr)
+_INLINE_ int ext2fs_set_bit(blk_t nr,void * addr)
 {
 	char retval;
 
@@ -315,7 +316,7 @@ _INLINE_ int ext2fs_set_bit(unsigned int
 	return retval;
 }
 
-_INLINE_ int ext2fs_clear_bit(unsigned int nr, void * addr)
+_INLINE_ int ext2fs_clear_bit(blk_t nr, void * addr)
 {
 	char retval;
 
@@ -325,7 +326,7 @@ _INLINE_ int ext2fs_clear_bit(unsigned i
 	return retval;
 }
 
-_INLINE_ int ext2fs_test_bit(unsigned int nr, const void * addr)
+_INLINE_ int ext2fs_test_bit(blk_t nr, const void * addr)
 {
 	char retval;
 
