From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs w/64-bit patches: make check gets one failure
Date: Fri, 13 Mar 2009 16:38:38 -0600
Message-ID: <20090313223838.GU3199@webber.adilger.int>
References: <12304.1236797612@alphaville.usa.hp.com>
 <20090312040210.GQ3199@webber.adilger.int>
 <12502.1236867091@gamaville.dokosmarshall.org>
 <20090312203645.GI3199@webber.adilger.int>
 <12379.1236894135@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65195 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZCMWjU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2009 18:39:20 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2DMdGVR021290
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 15:39:16 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KGG00B00UEOC600@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 13 Mar 2009 15:39:16 -0700 (PDT)
In-reply-to: <12379.1236894135@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 12, 2009  17:42 -0400, Nick Dokos wrote:
> Andreas Dilger <adilger@sun.com> wrote:
> > > +Inode 24001, i_size is 596992, should be 485376.  Fix? yes
> > 
> > This looks like it is causing an inode to be truncated.
> > 
> > >  Pass 2: Checking directory structure
> > > +Problem in HTREE directory inode 24001 (/test2): bad block number 578.
> > > +Clear HTree index? yes
> > 
> > Supporting evidence that this is a directory being truncated.
> > 
> > >  Pass 3: Checking directory connectivity
> > > +Pass 3A: Optimizing directories
> > >  Pass 4: Checking reference counts
> > > +Unattached zero-length inode 12.  Clear? yes
> > > +
> > > +Unattached zero-length inode 13.  Clear? yes
> > 
> > These are all of the inodes that were lost from the truncated directory.
> > 
> > This seems like a non-trivial failure and needs to be investigated.
> > Posting the offending patch (assuming you can pass "make check" before
> > the patch, and fail afterward) would get more eyes on the subject.
> 
> I attach the patch - it's entitled
> 
>   0024-Miscellaneous-e2fsck-related-64-bit-fixes.patch
> 
> Without it (and without all subesequent patches) in the series file, "make
> check" succeeds.  Adding back just this one patch to the series file leads to
> "make check" failure.

The problem with this patch is that it only converts the many callsites
over to using the 64-bit routines, it doesn't actually contain the code
for those routines.

What is confusing is why an existing test (where the inode itself in the
test image is not changing) is suddenly reporting a corruption?

[f_h_reindex]$ zcat image.gz > image
[f_h_reindex]$ debugfs image
debugfs 1.40.11.sun1 (17-June-2008)
debugfs:  stat <24001>
Inode: 24001   Type: directory    Mode:  0755   Flags: 0x1000   Generation:
58715525
User:     0   Group:     0   Size: 485376
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 956
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x3d984528 -- Mon Sep 30 06:35:52 2002
atime: 0x3d984526 -- Mon Sep 30 06:35:50 2002
mtime: 0x3d984528 -- Mon Sep 30 06:35:52 2002
BLOCKS:
(0-11):6649-6660, (IND):6661, (12-267):6662-6917, (DIND):6918, (IND):6919,
(268-473):6920-7125, (IND):7680
TOTAL: 478

Hmm, this is interesting.  The last allocated block in the inode is an
indirect block, which is unusual.  The inode size 485376 = 474 * 1024
leaf blocks, which matches the last data block in the inode and the
TOTAL 478 - 4 indirect blocks.

The size that is expected with the new patch is 596992, which is 583 * 1024
leaf blocks, 109? blocks more.  However, the last indirect block is empty:

[f_h_reindex]$ dd if=image bs=1k skip=7680 count=1 | od -Ax -tx4 | more
1+0 records in
1+0 records out
1024 bytes (1.0 kB) copied, 2.172e-05 s, 47.1 MB/s
000000 00000000 00000000 00000000 00000000
*
000400

While this is an unusual situation, I don't think it is correct to
extend the file and size based on an empty indirect block, and then
create a bad directory.  

> ---------------------------------------------------------------------------
> e2fsck: Miscellaneous e2fsck-related 64-bit fixes.
> 
> From: Valerie Aurora Henson <vaurora@redhat.com>
> 
> With this change, e2fsck runs to completion on a minimal 33-bit file system.
> 
> Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index 0113469..9e5870d 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -206,8 +206,8 @@ struct e2fsck_struct {
>  	char *io_options;
>  	int	flags;		/* E2fsck internal flags */
>  	int	options;
> -	blk_t	use_superblock;	/* sb requested by user */
> -	blk_t	superblock;	/* sb used to open fs */
> +	blk64_t	use_superblock;	/* sb requested by user */
> +	blk64_t	superblock;	/* sb used to open fs */
>  	int	blocksize;	/* blocksize */
>  	blk64_t	num_blocks;	/* Total number of blocks */
>  	int	mount_flags;
> diff --git a/e2fsck/emptydir.c b/e2fsck/emptydir.c
> index e03db56..0f5ef9b 100644
> --- a/e2fsck/emptydir.c
> +++ b/e2fsck/emptydir.c
> @@ -25,8 +25,8 @@ struct empty_dir_info_struct {
>  	char *block_buf;
>  	ext2_ino_t ino;
>  	struct ext2_inode inode;
> -	blk_t	logblk;
> -	blk_t	freed_blocks;
> +	blk64_t	logblk;
> +	blk64_t	freed_blocks;
>  };
>  
>  typedef struct empty_dir_info_struct *empty_dir_info;
> @@ -97,7 +97,7 @@ void add_empty_dirblock(empty_dir_info edi,
>  	printf(_("Empty directory block %u (#%d) in inode %u\n"),
>  	       db->blk, db->blockcnt, db->ino);
>  
> -	ext2fs_mark_block_bitmap(edi->empty_dir_blocks, db->blk);
> +	ext2fs_mark_block_bitmap2(edi->empty_dir_blocks, db->blk);
>  	if (ext2fs_test_inode_bitmap(edi->dir_map, db->ino))
>  		return;
>  	ext2fs_mark_inode_bitmap(edi->dir_map, db->ino);
> @@ -116,20 +116,20 @@ void add_empty_dirblock(empty_dir_info edi,
>   *
>   * Also question --- how to free the indirect blocks.
>   */
> -int empty_pass1(ext2_filsys fs, blk_t *block_nr, e2_blkcnt_t blockcnt,
> -		blk_t ref_block, int ref_offset, void *priv_data)
> +int empty_pass1(ext2_filsys fs, blk64_t *block_nr, e2_blkcnt_t blockcnt,
> +		blk64_t ref_block, int ref_offset, void *priv_data)
>  {
>  	empty_dir_info edi = (empty_dir_info) priv_data;
> -	blk_t	block, new_block;
> +	blk64_t	block, new_block;
>  	errcode_t	retval;
>  
>  	if (blockcnt < 0)
>  		return 0;
>  	block = *block_nr;
>  	do {
> -		retval = ext2fs_bmap(fs, edi->ino, &edi->inode,
> -				     edi->block_buf, 0, edi->logblk,
> -				     &new_block);
> +		retval = ext2fs_bmap2(fs, edi->ino, &edi->inode,
> +				      edi->block_buf, 0, edi->logblk, 0
> +				      &new_block);
>  		if (retval)
>  			return DIRENT_ABORT;   /* XXX what to do? */
>  		if (new_block == 0)
> @@ -161,7 +161,7 @@ static int fix_directory(ext2_filsys fs,
>  	if (retval)
>  		return 0;
>  
> -	retval = ext2fs_block_iterate2(fs, db->ino, 0, edi->block_buf,
> +	retval = ext2fs_block_iterate3(fs, db->ino, 0, edi->block_buf,
>  				       empty_pass1, edi);
>  	if (retval)
>  		return 0;
> diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
> index 60cc682..2bb71c3 100644
> --- a/e2fsck/jfs_user.h
> +++ b/e2fsck/jfs_user.h
> @@ -120,8 +120,8 @@ _INLINE_ size_t journal_tag_bytes(journal_t *journal)
>  /*
>   * Kernel compatibility functions are defined in journal.c
>   */
> -int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys);
> -struct buffer_head *getblk(kdev_t ctx, blk_t blocknr, int blocksize);
> +int journal_bmap(journal_t *journal, blk64_t block, unsigned long *phys);
> +struct buffer_head *getblk(kdev_t ctx, blk64_t blocknr, int blocksize);
>  void sync_blockdev(kdev_t kdev);
>  void ll_rw_block(int rw, int dummy, struct buffer_head *bh[]);
>  void mark_buffer_dirty(struct buffer_head *bh);
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index ab61ea7..c6d5b10 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -43,7 +43,7 @@ static int bh_count = 0;
>   * to use the recovery.c file virtually unchanged from the kernel, so we
>   * don't have to do much to keep kernel and user recovery in sync.
>   */
> -int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys)
> +int journal_bmap(journal_t *journal, blk64_t block, unsigned long *phys)
>  {
>  #ifdef USE_INODE_IO
>  	*phys = block;
> @@ -51,21 +51,21 @@ int journal_bmap(journal_t *journal, blk_t block, unsigned long *phys)
>  #else
>  	struct inode 	*inode = journal->j_inode;
>  	errcode_t	retval;
> -	blk_t		pblk;
> +	blk64_t		pblk;
>  
>  	if (!inode) {
>  		*phys = block;
>  		return 0;
>  	}
>  
> -	retval= ext2fs_bmap(inode->i_ctx->fs, inode->i_ino,
> -			    &inode->i_ext2, NULL, 0, block, &pblk);
> +	retval= ext2fs_bmap2(inode->i_ctx->fs, inode->i_ino,
> +			     &inode->i_ext2, NULL, 0, block, 0, &pblk);
>  	*phys = pblk;
>  	return (retval);
>  #endif
>  }
>  
> -struct buffer_head *getblk(kdev_t kdev, blk_t blocknr, int blocksize)
> +struct buffer_head *getblk(kdev_t kdev, blk64_t blocknr, int blocksize)
>  {
>  	struct buffer_head *bh;
>  	int bufsize = sizeof(*bh) + kdev->k_ctx->fs->blocksize -
> @@ -203,14 +203,14 @@ struct process_block_struct {
>  };
>  
>  static int process_journal_block(ext2_filsys fs,
> -				 blk_t	*block_nr,
> +				 blk64_t	*block_nr,
>  				 e2_blkcnt_t blockcnt,
> -				 blk_t ref_block EXT2FS_ATTR((unused)),
> +				 blk64_t ref_block EXT2FS_ATTR((unused)),
>  				 int ref_offset EXT2FS_ATTR((unused)),
>  				 void *priv_data)
>  {
>  	struct process_block_struct *p;
> -	blk_t	blk = *block_nr;
> +	blk64_t	blk = *block_nr;
>  
>  	p = (struct process_block_struct *) priv_data;
>  
> @@ -307,7 +307,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
>  			goto try_backup_journal;
>  		}
>  		pb.last_block = -1;
> -		retval = ext2fs_block_iterate2(ctx->fs, j_inode->i_ino,
> +		retval = ext2fs_block_iterate3(ctx->fs, j_inode->i_ino,
>  					       BLOCK_FLAG_HOLE, 0,
>  					       process_journal_block, &pb);
>  		if ((pb.last_block+1) * ctx->fs->blocksize <
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 3af77c1..398b113 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -55,11 +55,11 @@
>  #define _INLINE_ inline
>  #endif
>  
> -static int process_block(ext2_filsys fs, blk_t	*blocknr,
> -			 e2_blkcnt_t blockcnt, blk_t ref_blk,
> +static int process_block(ext2_filsys fs, blk64_t	*blocknr,
> +			 e2_blkcnt_t blockcnt, blk64_t ref_blk,
>  			 int ref_offset, void *priv_data);
> -static int process_bad_block(ext2_filsys fs, blk_t *block_nr,
> -			     e2_blkcnt_t blockcnt, blk_t ref_blk,
> +static int process_bad_block(ext2_filsys fs, blk64_t *block_nr,
> +			     e2_blkcnt_t blockcnt, blk64_t ref_blk,
>  			     int ref_offset, void *priv_data);
>  static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  			 char *block_buf);
> @@ -74,17 +74,17 @@ static errcode_t scan_callback(ext2_filsys fs, ext2_inode_scan scan,
>  				  dgrp_t group, void * priv_data);
>  static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
>  				    char *block_buf, int adjust_sign);
> -/* static char *describe_illegal_block(ext2_filsys fs, blk_t block); */
> +/* static char *describe_illegal_block(ext2_filsys fs, blk64_t block); */
>  
>  struct process_block_struct {
>  	ext2_ino_t	ino;
>  	unsigned	is_dir:1, is_reg:1, clear:1, suppress:1,
>  				fragmented:1, compressed:1, bbcheck:1;
> -	blk_t		num_blocks;
> -	blk_t		max_blocks;
> +	blk64_t		num_blocks;
> +	blk64_t		max_blocks;
>  	e2_blkcnt_t	last_block;
>  	int		num_illegal_blocks;
> -	blk_t		previous_block;
> +	blk64_t		previous_block;
>  	struct ext2_inode *inode;
>  	struct problem_context *pctx;
>  	ext2fs_block_bitmap64 fs_meta_blocks;
> @@ -168,7 +168,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
>  {
>  	unsigned int len;
>  	int i;
> -	blk_t	blocks;
> +	blk64_t	blocks;
>  	ext2_extent_handle_t	handle;
>  	struct ext2_extent_info	info;
>  	struct ext2fs_extent	extent;
> @@ -199,7 +199,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
>  		return i;
>  	}
>  
> -	blocks = ext2fs_inode_data_blocks(fs, inode);
> +	blocks = ext2fs_inode_data_blocks2(fs, inode);
>  	if (blocks) {
>  		if ((inode->i_size >= fs->blocksize) ||
>  		    (blocks != fs->blocksize >> 9) ||
> @@ -403,7 +403,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
>  	struct ext2_dir_entry 	*dirent;
>  	const char		*old_op;
>  	errcode_t		retval;
> -	blk_t			blk;
> +	blk64_t			blk;
>  	unsigned int		i, rec_len, not_device = 0;
>  
>  	if (LINUX_S_ISDIR(inode->i_mode) || LINUX_S_ISREG(inode->i_mode) ||
> @@ -773,7 +773,7 @@ void e2fsck_pass1(e2fsck_t ctx)
>  			pb.inode = inode;
>  			pb.pctx = &pctx;
>  			pb.ctx = ctx;
> -			pctx.errcode = ext2fs_block_iterate2(fs, ino, 0,
> +			pctx.errcode = ext2fs_block_iterate3(fs, ino, 0,
>  				     block_buf, process_bad_block, &pb);
>  			ext2fs_free_block_bitmap(pb.fs_meta_blocks);
>  			if (pctx.errcode) {
> @@ -1283,7 +1283,7 @@ static void alloc_imagic_map(e2fsck_t ctx)
>   * WARNING: Assumes checks have already been done to make sure block
>   * is valid.  This is true in both process_block and process_bad_block.
>   */
> -static _INLINE_ void mark_block_used(e2fsck_t ctx, blk_t block)
> +static _INLINE_ void mark_block_used(e2fsck_t ctx, blk64_t block)
>  {
>  	struct		problem_context pctx;
>  
> @@ -1322,7 +1322,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
>  	struct ext2_ext_attr_header 	*header;
>  	struct problem_context		pctx;
>  	ext2_filsys			fs = ctx->fs;
> -	blk_t				blk;
> +	blk64_t				blk;
>  	__u32				should_be;
>  	int				count;
>  
> @@ -1333,7 +1333,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
>  		if ((blk = ea_refcount_intr_next(refcount, &count)) == 0)
>  			break;
>  		pctx.blk = blk;
> -		pctx.errcode = ext2fs_read_ext_attr(fs, blk, block_buf);
> +		pctx.errcode = ext2fs_read_ext_attr2(fs, blk, block_buf);
>  		if (pctx.errcode) {
>  			fix_problem(ctx, PR_1_EXTATTR_READ_ABORT, &pctx);
>  			return;
> @@ -1344,7 +1344,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
>  		pctx.num = should_be;
>  		if (fix_problem(ctx, PR_1_EXTATTR_REFCOUNT, &pctx)) {
>  			header->h_refcount = should_be;
> -			pctx.errcode = ext2fs_write_ext_attr(fs, blk,
> +			pctx.errcode = ext2fs_write_ext_attr2(fs, blk,
>  							     block_buf);
>  			if (pctx.errcode) {
>  				fix_problem(ctx, PR_1_EXTATTR_WRITE, &pctx);
> @@ -1363,7 +1363,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
>  	ext2_filsys fs = ctx->fs;
>  	ext2_ino_t	ino = pctx->ino;
>  	struct ext2_inode *inode = pctx->inode;
> -	blk_t		blk;
> +	blk64_t		blk;
>  	char *		end;
>  	struct ext2_ext_attr_header *header;
>  	struct ext2_ext_attr_entry *entry;
> @@ -1441,7 +1441,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
>  	 * validate it
>  	 */
>  	pctx->blk = blk;
> -	pctx->errcode = ext2fs_read_ext_attr(fs, blk, block_buf);
> +	pctx->errcode = ext2fs_read_ext_attr2(fs, blk, block_buf);
>  	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
>  		goto clear_extattr;
>  	header = (struct ext2_ext_attr_header *) block_buf;
> @@ -1546,7 +1546,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
>  	struct ext2_dx_root_info	*root;
>  	ext2_filsys			fs = ctx->fs;
>  	errcode_t			retval;
> -	blk_t				blk;
> +	blk64_t				blk;
>  
>  	if ((!LINUX_S_ISDIR(inode->i_mode) &&
>  	     fix_problem(ctx, PR_1_HTREE_NODIR, pctx)) ||
> @@ -1554,7 +1554,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
>  	     fix_problem(ctx, PR_1_HTREE_SET, pctx)))
>  		return 1;
>  
> -	pctx->errcode = ext2fs_bmap(fs, ino, inode, 0, 0, 0, &blk);
> +	pctx->errcode = ext2fs_bmap2(fs, ino, inode, 0, 0, 0, 0, &blk);
>  
>  	if ((pctx->errcode) ||
>  	    (blk == 0) ||
> @@ -1627,7 +1627,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>  			     ext2_extent_handle_t ehandle)
>  {
>  	struct ext2fs_extent	extent;
> -	blk_t			blk;
> +	blk64_t			blk;
>  	e2_blkcnt_t		blockcnt;
>  	unsigned int		i;
>  	int			is_dir, is_leaf;
> @@ -1852,7 +1852,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
>  			check_blocks_extents(ctx, pctx, &pb);
>  		else
> -			pctx->errcode = ext2fs_block_iterate2(fs, ino,
> +			pctx->errcode = ext2fs_block_iterate3(fs, ino,
>  						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
>  						block_buf, process_block, &pb);
>  	}
> @@ -1997,9 +1997,9 @@ out:
>   * Helper function called by process block when an illegal block is
>   * found.  It returns a description about why the block is illegal
>   */
> -static char *describe_illegal_block(ext2_filsys fs, blk_t block)
> +static char *describe_illegal_block(ext2_filsys fs, blk64_t block)
>  {
> -	blk_t	super;
> +	blk64_t	super;
>  	int	i;
>  	static char	problem[80];
>  
> @@ -2048,15 +2048,15 @@ static char *describe_illegal_block(ext2_filsys fs, blk_t block)
>   * This is a helper function for check_blocks().
>   */
>  static int process_block(ext2_filsys fs,
> -		  blk_t	*block_nr,
> +		  blk64_t	*block_nr,
>  		  e2_blkcnt_t blockcnt,
> -		  blk_t ref_block EXT2FS_ATTR((unused)),
> +		  blk64_t ref_block EXT2FS_ATTR((unused)),
>  		  int ref_offset EXT2FS_ATTR((unused)),
>  		  void *priv_data)
>  {
>  	struct process_block_struct *p;
>  	struct problem_context *pctx;
> -	blk_t	blk = *block_nr;
> +	blk64_t	blk = *block_nr;
>  	int	ret_code = 0;
>  	int	problem = 0;
>  	e2fsck_t	ctx;
> @@ -2197,7 +2197,7 @@ static int process_block(ext2_filsys fs,
>  mark_dir:
>  	if (p->is_dir && (blockcnt >= 0)) {
>  		pctx->errcode = ext2fs_add_dir_block(fs->dblist, p->ino,
> -						    blk, blockcnt);
> +						      blk, blockcnt);
>  		if (pctx->errcode) {
>  			pctx->blk = blk;
>  			pctx->num = blockcnt;
> @@ -2211,15 +2211,15 @@ mark_dir:
>  }
>  
>  static int process_bad_block(ext2_filsys fs,
> -		      blk_t *block_nr,
> +		      blk64_t *block_nr,
>  		      e2_blkcnt_t blockcnt,
> -		      blk_t ref_block EXT2FS_ATTR((unused)),
> +		      blk64_t ref_block EXT2FS_ATTR((unused)),
>  		      int ref_offset EXT2FS_ATTR((unused)),
>  		      void *priv_data)
>  {
>  	struct process_block_struct *p;
> -	blk_t		blk = *block_nr;
> -	blk_t		first_block;
> +	blk64_t		blk = *block_nr;
> +	blk64_t		first_block;
>  	dgrp_t		i;
>  	struct problem_context *pctx;
>  	e2fsck_t	ctx;
> @@ -2390,7 +2390,7 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
>  	pctx.blk = old_block;
>  	pctx.str = name;
>  
> -	last_block = ext2fs_group_last_block(fs, group);
> +	last_block = ext2fs_group_last_block2(fs, group);
>  	pctx.errcode = ext2fs_get_free_blocks2(fs, first_block, last_block,
>  					num, ctx->block_found_map, new_block);
>  	if (pctx.errcode) {
> @@ -2446,7 +2446,7 @@ static void handle_fs_bad_blocks(e2fsck_t ctx)
>  	blk64_t		new_blk;
>  
>  	for (i = 0; i < fs->group_desc_count; i++) {
> -		first_block = ext2fs_group_first_block(fs, i);
> +		first_block = ext2fs_group_first_block2(fs, i);
>  
>  		if (ctx->invalid_block_bitmap_flag[i]) {
>  			new_blk = ext2fs_block_bitmap_loc(fs, i);
> @@ -2479,7 +2479,7 @@ static void handle_fs_bad_blocks(e2fsck_t ctx)
>  static void mark_table_blocks(e2fsck_t ctx)
>  {
>  	ext2_filsys fs = ctx->fs;
> -	blk_t	b;
> +	blk64_t	b;
>  	dgrp_t	i;
>  	int	j;
>  	struct problem_context pctx;
> @@ -2611,8 +2611,8 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
>  	blk64_t		new_block;
>  
>  	if (ctx->block_found_map) {
> -		retval = ext2fs_new_block2(fs, (blk_t) goal,
> -					  ctx->block_found_map, &new_block);
> +		retval = ext2fs_new_block2(fs, goal, ctx->block_found_map,
> +					   &new_block);
>  		if (retval)
>  			return retval;
>  	} else {
> @@ -2622,7 +2622,7 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
>  				return retval;
>  		}
>  
> -		retval = ext2fs_new_block2(fs, (blk_t) goal, 0, &new_block);
> +		retval = ext2fs_new_block2(fs, goal, 0, &new_block);
>  		if (retval)
>  			return retval;
>  	}
> @@ -2637,11 +2637,9 @@ static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
>  
>  	if (ctx->block_found_map) {
>  		if (inuse > 0)
> -			ext2fs_mark_block_bitmap2(ctx->block_found_map,
> -						 (blk_t) blk);
> +			ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
>  		else
> -			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
> -						   (blk_t) blk);
> +			ext2fs_unmark_block_bitmap2(ctx->block_found_map, blk);
>  	}
>  }
>  
> diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
> index 0d5ce5d..a998b17 100644
> --- a/e2fsck/pass1b.c
> +++ b/e2fsck/pass1b.c
> @@ -54,7 +54,7 @@ typedef long intptr_t;
>  #define BLOCK_COUNT_EXTATTR	(-5)
>  
>  struct block_el {
> -	blk_t	block;
> +	blk64_t	block;
>  	struct block_el *next;
>  };
>  
> @@ -89,7 +89,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
>  			struct dup_inode *dp, char *block_buf);
>  static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
>  		      struct dup_inode *dp, char* block_buf);
> -static int check_if_fs_block(e2fsck_t ctx, blk_t test_blk);
> +static int check_if_fs_block(e2fsck_t ctx, blk64_t test_blk);
>  
>  static void pass1b(e2fsck_t ctx, char *block_buf);
>  static void pass1c(e2fsck_t ctx, char *block_buf);
> @@ -115,7 +115,7 @@ static int dict_int_cmp(const void *a, const void *b)
>  /*
>   * Add a duplicate block record
>   */
> -static void add_dupe(e2fsck_t ctx, ext2_ino_t ino, blk_t blk,
> +static void add_dupe(e2fsck_t ctx, ext2_ino_t ino, blk64_t blk,
>  		     struct ext2_inode *inode)
>  {
>  	dnode_t	*n;
> @@ -534,7 +534,7 @@ static void pass1d(e2fsck_t ctx, char *block_buf)
>   * Drop the refcount on the dup_block structure, and clear the entry
>   * in the block_dup_map if appropriate.
>   */
> -static void decrement_badcount(e2fsck_t ctx, blk_t block, struct dup_block *p)
> +static void decrement_badcount(e2fsck_t ctx, blk64_t block, struct dup_block *p)
>  {
>  	p->num_bad--;
>  	if (p->num_bad <= 0 ||
> @@ -608,7 +608,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
>  	if (ext2fs_file_acl_block(&inode) &&
>  	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
>  		count = 1;
> -		pctx.errcode = ext2fs_adjust_ea_refcount(fs,
> +		pctx.errcode = ext2fs_adjust_ea_refcount2(fs,
>  						   ext2fs_file_acl_block(&inode),
>  						   block_buf, -1, &count);
>  		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
> @@ -806,10 +806,10 @@ errout:
>   * This routine returns 1 if a block overlaps with one of the superblocks,
>   * group descriptors, inode bitmaps, or block bitmaps.
>   */
> -static int check_if_fs_block(e2fsck_t ctx, blk_t test_block)
> +static int check_if_fs_block(e2fsck_t ctx, blk64_t test_block)
>  {
>  	ext2_filsys fs = ctx->fs;
> -	blk_t	first_block;
> +	blk64_t	first_block;
>  	dgrp_t	i;
>  
>  	first_block = fs->super->s_first_data_block;
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 976605b..d7de6bf 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1196,7 +1196,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
>  
>  	if (ext2fs_file_acl_block(&inode) &&
>  	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
> -		pctx.errcode = ext2fs_adjust_ea_refcount(fs, ext2fs_file_acl_block(&inode),
> +		pctx.errcode = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(&inode),
>  						   block_buf, -1, &count);
>  		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
>  			pctx.errcode = 0;
> diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
> index 5929430..ed232e2 100644
> --- a/e2fsck/pass3.c
> +++ b/e2fsck/pass3.c
> @@ -689,24 +689,24 @@ static void fix_dotdot(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
>   */
>  
>  struct expand_dir_struct {
> -	int			num;
> -	int			guaranteed_size;
> -	int			newblocks;
> -	int			last_block;
> +	blk64_t			num;
> +	blk64_t			guaranteed_size;
> +	blk64_t			newblocks;
> +	blk64_t			last_block;
>  	errcode_t		err;
>  	e2fsck_t		ctx;
>  };
>  
>  static int expand_dir_proc(ext2_filsys fs,
> -			   blk_t	*blocknr,
> +			   blk64_t	*blocknr,
>  			   e2_blkcnt_t	blockcnt,
> -			   blk_t ref_block EXT2FS_ATTR((unused)),
> +			   blk64_t ref_block EXT2FS_ATTR((unused)),
>  			   int ref_offset EXT2FS_ATTR((unused)),
>  			   void	*priv_data)
>  {
>  	struct expand_dir_struct *es = (struct expand_dir_struct *) priv_data;
>  	blk64_t	new_blk;
> -	static blk_t	last_blk = 0;
> +	static blk64_t	last_blk = 0;
>  	char		*block;
>  	errcode_t	retval;
>  	e2fsck_t	ctx;
> @@ -789,7 +789,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
>  	es.newblocks = 0;
>  	es.ctx = ctx;
>  
> -	retval = ext2fs_block_iterate2(fs, dir, BLOCK_FLAG_APPEND,
> +	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
>  				       0, expand_dir_proc, &es);
>  
>  	if (es.err)
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 1bb4b6b..c8708b3 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -72,7 +72,7 @@ void e2fsck_pass5(e2fsck_t ctx)
>  #endif
>  }
>  
> -#define NO_BLK ((blk_t) -1)
> +#define NO_BLK ((blk64_t) -1)
>  
>  static void print_bitmap_problem(e2fsck_t ctx, int problem,
>  			    struct problem_context *pctx)
> @@ -112,11 +112,11 @@ static void check_block_bitmaps(e2fsck_t ctx)
>  {
>  	ext2_filsys fs = ctx->fs;
>  	blk64_t	i;
> -	blk_t   super;
> +	blk64_t   super;
>  	int	*free_array;
>  	int	group = 0;
> -	blk_t	blocks = 0;
> -	blk_t	free_blocks = 0;
> +	blk64_t	blocks = 0;
> +	blk64_t	free_blocks = 0;
>  	int	group_free = 0;
>  	int	actual, bitmap;
>  	struct problem_context	pctx;
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 89f1de5..d00b94b 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -54,16 +54,16 @@ struct process_block_struct {
>  };
>  
>  static int release_inode_block(ext2_filsys fs,
> -			       blk_t	*block_nr,
> +			       blk64_t	*block_nr,
>  			       e2_blkcnt_t blockcnt,
> -			       blk_t	ref_blk EXT2FS_ATTR((unused)),
> +			       blk64_t	ref_blk EXT2FS_ATTR((unused)),
>  			       int	ref_offset EXT2FS_ATTR((unused)),
>  			       void *priv_data)
>  {
>  	struct process_block_struct *pb;
>  	e2fsck_t 		ctx;
>  	struct problem_context	*pctx;
> -	blk_t			blk = *block_nr;
> +	blk64_t			blk = *block_nr;
>  	int			retval = 0;
>  
>  	pb = (struct process_block_struct *) priv_data;
> @@ -180,7 +180,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
>  		pb.truncate_offset = 0;
>  	}
>  	pb.truncated_blocks = 0;
> -	retval = ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_DEPTH_TRAVERSE,
> +	retval = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_DEPTH_TRAVERSE,
>  				      block_buf, release_inode_block, &pb);
>  	if (retval) {
>  		com_err("release_inode_blocks", retval,
> @@ -198,7 +198,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
>  		ext2fs_iblk_sub_blocks(fs, inode, pb.truncated_blocks);
>  
>  	if (ext2fs_file_acl_block(inode)) {
> -		retval = ext2fs_adjust_ea_refcount(fs, ext2fs_file_acl_block(inode),
> +		retval = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(inode),
>  						   block_buf, -1, &count);
>  		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
>  			retval = 0;
> @@ -206,7 +206,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
>  		}
>  		if (retval) {
>  			com_err("release_inode_blocks", retval,
> -		_("while calling ext2fs_adjust_ea_refcount for inode %d"),
> +		_("while calling ext2fs_adjust_ea_refcount2 for inode %d"),
>  				ino);
>  			return 1;
>  		}
> @@ -313,7 +313,7 @@ static void check_resize_inode(e2fsck_t ctx)
>  	struct problem_context	pctx;
>  	int		i, gdt_off, ind_off;
>  	dgrp_t		j;
> -	blk_t		blk, pblk, expect;
> +	blk64_t		blk, pblk, expect;
>  	__u32 		*dind_buf = 0, *ind_buf;
>  	errcode_t	retval;
>  
> @@ -456,19 +456,19 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
>  void check_super_block(e2fsck_t ctx)
>  {
>  	ext2_filsys fs = ctx->fs;
> -	blk_t	first_block, last_block;
> +	blk64_t	first_block, last_block;
>  	struct ext2_super_block *sb = fs->super;
>  	struct ext2_group_desc *gd;
> -	blk_t	blocks_per_group = fs->super->s_blocks_per_group;
> -	blk_t	bpg_max;
> +	blk64_t	blocks_per_group = fs->super->s_blocks_per_group;
> +	blk64_t	bpg_max;
>  	int	inodes_per_block;
>  	int	ipg_max;
>  	int	inode_size;
>  	int	buggy_init_scripts;
>  	dgrp_t	i;
> -	blk_t	should_be;
> +	blk64_t	should_be;
>  	struct problem_context	pctx;
> -	blk_t	free_blocks = 0;
> +	blk64_t	free_blocks = 0;
>  	ino_t	free_inodes = 0;
>  	int     csum_flag, clear_test_fs_flag;
>  
> @@ -591,8 +591,8 @@ void check_super_block(e2fsck_t ctx)
>  
>  		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
>  					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> -			first_block = ext2fs_group_first_block(fs, i);
> -			last_block = ext2fs_group_last_block(fs, i);
> +			first_block = ext2fs_group_first_block2(fs, i);
> +			last_block = ext2fs_group_last_block2(fs, i);
>  		}
>  
>  		if ((ext2fs_block_bitmap_loc(fs, i) < first_block) ||
> @@ -889,7 +889,7 @@ int check_backup_super_block(e2fsck_t ctx)
>  	ext2_filsys	tfs = 0;
>  	errcode_t	retval;
>  	dgrp_t		g;
> -	blk_t		sb;
> +	blk64_t		sb;
>  	int		ret = 0;
>  
>  	/*
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index a5e0086..924481f 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -101,9 +101,9 @@ static void show_stats(e2fsck_t	ctx)
>  {
>  	ext2_filsys fs = ctx->fs;
>  	ext2_ino_t inodes, inodes_used;
> -	blk_t blocks, blocks_used;
> -	int dir_links;
> -	int num_files, num_links;
> +	blk64_t blocks, blocks_used;
> +	unsigned int dir_links;
> +	unsigned int num_files, num_links;
>  	int frag_percent_file, frag_percent_dir, frag_percent_total;
>  	int i, j;
>  
> @@ -129,7 +129,7 @@ static void show_stats(e2fsck_t	ctx)
>  	frag_percent_total = (frag_percent_total + 5) / 10;
>  
>  	if (!verbose) {
> -		printf(_("%s: %u/%u files (%0d.%d%% non-contiguous), %u/%u blocks\n"),
> +		printf(_("%s: %u/%u files (%0d.%d%% non-contiguous), %llu/%llu blocks\n"),
>  		       ctx->device_name, inodes_used, inodes,
>  		       frag_percent_total / 10, frag_percent_total % 10,
>  		       blocks_used, blocks);
> @@ -163,7 +163,8 @@ static void show_stats(e2fsck_t	ctx)
>  		fputc('\n', stdout);
>  	}
>  
> -	printf (P_("%8u block used (%2.2f%%)\n", "%8u blocks used (%2.2f%%)\n",
> +	printf (P_("%8llu block used (%2.2f%%)\n",
> +		   "%8llu blocks used (%2.2f%%)\n",
>  		   blocks_used), blocks_used, 100.0 * blocks_used / blocks);
>  	printf (P_("%8u bad block\n", "%8u bad blocks\n",
>  		   ctx->fs_badblocks_count), ctx->fs_badblocks_count);
> @@ -731,7 +732,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  			/* What we do by default, anyway! */
>  			break;
>  		case 'b':
> -			res = sscanf(optarg, "%u", &ctx->use_superblock);
> +			res = sscanf(optarg, "%llu", &ctx->use_superblock);
>  			if (res != 1)
>  				goto sscanf_err;
>  			ctx->flags |= E2F_FLAG_SB_SPECIFIED;
> diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
> index bf32dd0..6a969e0 100644
> --- a/lib/ext2fs/check_desc.c
> +++ b/lib/ext2fs/check_desc.c
> @@ -34,8 +34,8 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
>  	ext2fs_block_bitmap64 bmap;
>  	errcode_t retval;
>  	dgrp_t i;
> -	blk_t first_block = fs->super->s_first_data_block;
> -	blk_t last_block = ext2fs_blocks_count(fs->super)-1;
> +	blk64_t first_block = fs->super->s_first_data_block;
> +	blk64_t last_block = ext2fs_blocks_count(fs->super)-1;
>  	blk_t blk, b;
>  	int j;
>  
> @@ -51,8 +51,8 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
>  	for (i = 0; i < fs->group_desc_count; i++) {
>  		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
>  					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> -			first_block = ext2fs_group_first_block(fs, i);
> -			last_block = ext2fs_group_last_block(fs, i);
> +			first_block = ext2fs_group_first_block2(fs, i);
> +			last_block = ext2fs_group_last_block2(fs, i);
>  			if (i == (fs->group_desc_count - 1))
>  				last_block = ext2fs_blocks_count(fs->super)-1;
>  		}
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 517ed15..bb80fe2 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -206,6 +206,7 @@ struct struct_ext2_filsys {
>  	int				inode_blocks_per_group;
>  	ext2fs_inode_bitmap64		inode_map;
>  	ext2fs_block_bitmap64		block_map;
> +	/* XXX FIXME-64: not 64-bit safe, but not used? */
>  	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
>  	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
>  	errcode_t (*write_bitmaps)(ext2_filsys fs);
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index c0c202c..a6edd0c 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -789,7 +789,7 @@ errcode_t ext2fs_extent_replace(ext2_extent_handle_t handle,
>  static errcode_t extent_node_split(ext2_extent_handle_t handle)
>  {
>  	errcode_t			retval = 0;
> -	blk_t				new_node_pblk;
> +	blk64_t				new_node_pblk;
>  	blk64_t				new_node_start;
>  	blk64_t				orig_lblk;
>  	blk64_t				goal_blk = 0;
> @@ -904,7 +904,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
>  		goal_blk = (group * handle->fs->super->s_blocks_per_group) +
>  			handle->fs->super->s_first_data_block;
>  	}
> -	retval = ext2fs_alloc_block(handle->fs, (blk_t) goal_blk, block_buf,
> +	retval = ext2fs_alloc_block2(handle->fs, (blk_t) goal_blk, block_buf,
>  				    &new_node_pblk);
>  	if (retval)
>  		goto done;
> @@ -1362,7 +1362,7 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
>  			retval = ext2fs_write_inode_full(handle->fs,
>  					handle->ino, handle->inode,
>  					EXT2_INODE_SIZE(handle->fs->super));
> -			ext2fs_block_alloc_stats(handle->fs, extent.e_pblk, -1);
> +			ext2fs_block_alloc_stats2(handle->fs, extent.e_pblk, -1);
>  		}
>  	} else {
>  		eh = (struct ext3_extent_header *) path->buf;
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 6b7f4f5..59f46b9 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -93,7 +93,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>  	unsigned long	i;
>  	__u32		features;
>  	int		groups_per_block, blocks_per_group, io_flags;
> -	blk_t		group_block, blk;
> +	blk64_t		group_block, blk;
>  	char		*dest, *cp;
>  #ifdef WORDS_BIGENDIAN
>  	struct ext2_group_desc *gdp;
> @@ -310,7 +310,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>  	dest = (char *) fs->group_desc;
>  	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
>  	for (i=0 ; i < fs->desc_blocks; i++) {
> -		blk = ext2fs_descriptor_block_loc(fs, group_block, i);
> +		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
>  		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
>  		if (retval)
>  			goto cleanup;
> 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

