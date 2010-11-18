From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] e2fsck: Discard free data and inode blocks.
Date: Thu, 18 Nov 2010 13:12:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011181302060.18022@dhcp-lab-213.englab.brq.redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-5-git-send-email-lczerner@redhat.com> <4CE2F256.6030601@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@dilger.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0KRMMu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 07:12:50 -0500
In-Reply-To: <4CE2F256.6030601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Nov 2010, Eric Sandeen wrote:

-snip-
> >  
> > +static void e2fsck_should_discard(e2fsck_t ctx, io_manager manager,
> > +				  blk64_t start, blk64_t count)
> > +{
> > +	ext2_filsys fs = ctx->fs;
> > +	int ret = 0;
> > +
> > +	if (ctx->options & E2F_OPT_DISCARD)
> > +		ret = manager->discard(fs->io, start, count, fs);
> 
> as suggested earlier maybe you can just pass in blocksize unless there's
> a real expectation that other OSes might need other fs-> info?
> 
> "e2fsck_should_discard" sounds lke it is a test that would return
> true/false, but this actually does discard and is a void.
> 
> I'd probably rename it to better imply what itdoes, maybe
> just e2fsck_blocks_discard or e2fsck_discard ?
> 
> > +
> > +	if (ret)
> 
> any point to issuing a warning here if we encounter an error and stop?

Right.

> 
> > +		ctx->options &= ~E2F_OPT_DISCARD;
> > +}
> > +
> >  #define NO_BLK ((blk64_t) -1)
> >  
> >  static void print_bitmap_problem(e2fsck_t ctx, int problem,
> > @@ -108,6 +136,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
> >  	int	group = 0;
> >  	int	blocks = 0;
> >  	blk64_t	free_blocks = 0;
> > +	blk64_t first_free = ext2fs_blocks_count(fs->super);
> >  	int	group_free = 0;
> >  	int	actual, bitmap;
> >  	struct problem_context	pctx;
> > @@ -120,6 +149,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
> >  	int	cmp_block = 0;
> >  	int	redo_flag = 0;
> >  	blk64_t	super_blk, old_desc_blk, new_desc_blk;
> > +	io_manager	manager = ctx->fs->io->manager;
> >  
> >  	clear_problem_context(&pctx);
> >  	free_array = (int *) e2fsck_allocate_memory(ctx,
> > @@ -280,11 +310,24 @@ redo_counts:
> >  		}
> >  		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
> >  		had_problem++;
> > +		/*
> > +		 * If there a problem we should turn off the discard so we
> > +		 * do not compromise the filesystem.
> > +		 */
> > +		ctx->options &= ~E2F_OPT_DISCARD;
> 
> Would a warning be reasonable here?

I am not really sure this is necessary.

> 
> Or, maybe rather than trying to catch all the locations where
> you want to turn off the flag, can we just test for a changed
> fs prior to any discard in e2fsck_should_discard()?
> Not sure, just thinking out loud.

Adding test for changed filesystem into e2fsck_should_discard() does
make sence, however it is not sufficient because even in case of fs
error it may hit discard before any changes to filesystem has been made.

> 
> >  	do_counts:
> >  		if (!bitmap && (!skip_group || csum_flag)) {
> >  			group_free++;
> >  			free_blocks++;
> > +			if (first_free > i)
> > +				first_free = i;
> > +		} else {
> > +			if ((i > first_free) &&
> > +			   (ctx->options & E2F_OPT_DISCARD))
> > +				e2fsck_should_discard(ctx, manager, first_free,
> > +						      (i - first_free));
> > +			first_free = ext2fs_blocks_count(fs->super);
> >  		}
> >  		blocks ++;
> >  		if ((blocks == fs->super->s_blocks_per_group) ||
> > @@ -381,6 +424,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
> >  	int		csum_flag;
> >  	int		skip_group = 0;
> >  	int		redo_flag = 0;
> > +	io_manager	manager = ctx->fs->io->manager;
> >  
> >  	clear_problem_context(&pctx);
> >  	free_array = (int *) e2fsck_allocate_memory(ctx,
> > @@ -500,6 +544,11 @@ redo_counts:
> >  		}
> >  		ctx->flags |= E2F_FLAG_PROG_SUPPRESS;
> >  		had_problem++;
> > +		/*
> > +		 * If there is a problem we should turn off the discard so we
> > +		 * do not compromise the filesystem.
> > +		 */
> > +		ctx->options &= ~E2F_OPT_DISCARD;
> >  
> >  do_counts:
> >  		if (bitmap) {
> > @@ -509,11 +558,43 @@ do_counts:
> >  			group_free++;
> >  			free_inodes++;
> >  		}
> > +
> >  		inodes++;
> >  		if ((inodes == fs->super->s_inodes_per_group) ||
> >  		    (i == fs->super->s_inodes_count)) {
> > +
> >  			free_array[group] = group_free;
> >  			dir_array[group] = dirs_count;
> > +
> > +			/* Discard inode table */
> > +			if (ctx->options & E2F_OPT_DISCARD) {
> > +				blk64_t used_blks, blk, num;
> > +
> > +				used_blks = DIV_ROUND_UP(
> > +					(EXT2_INODES_PER_GROUP(fs->super) -
> > +					group_free),
> > +					EXT2_INODES_PER_BLOCK(fs->super));
> > +
> > +				blk = ext2fs_inode_table_loc(fs, group) +
> > +				      used_blks;
> > +				num = fs->inode_blocks_per_group -
> > +				      used_blks;
> > +				e2fsck_should_discard(ctx, manager, blk, num);
> > +			}
> > +
> > +			/*
> > +			 * If discard zeroes data and the group inode table
> > +			 * was not zeroed yet, set itable as zeroed
> > +			 */
> > +			if ((ctx->options & E2F_OPT_DISCARD) &&
> > +			    (manager->discard_zeroes_data) &&
> > +			    !(ext2fs_bg_flags_test(fs, group,
> > +						  EXT2_BG_INODE_ZEROED))) {
> > +				ext2fs_bg_flags_set(fs, group,
> > +						    EXT2_BG_INODE_ZEROED);
> > +				ext2fs_group_desc_csum_set(fs, group);
> > +			}
> 
> Maybe for another patch, but even if we're not discarding, should we
> be manually zeroing out here & setting the flag?  Hm I guess not,
> that'd be slow and defeat the purpose wouldn't it...
> 
> > +
> >  			group ++;
> >  			inodes = 0;
> >  			skip_group = 0;
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index 7eb269c..4cf55a9 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -594,6 +594,12 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
> >  		} else if (strcmp(token, "fragcheck") == 0) {
> >  			ctx->options |= E2F_OPT_FRAGCHECK;
> >  			continue;
> > +		} else if (strcmp(token, "discard") == 0) {
> > +			ctx->options |= E2F_OPT_DISCARD;
> > +			continue;
> > +		} else if (strcmp(token, "nodiscard") == 0) {
> > +			ctx->options &= ~E2F_OPT_DISCARD;
> > +			continue;
> >  		} else {
> >  			fprintf(stderr, _("Unknown extended option: %s\n"),
> >  				token);
> > @@ -609,6 +615,8 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
> >  		       "Valid extended options are:\n"), stderr);
> >  		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
> >  		fputs(("\tfragcheck\n"), stderr);
> > +		fputs(("\tdiscard\n"), stderr);
> > +		fputs(("\tnodiscard\n"), stderr);
> >  		fputc('\n', stderr);
> >  		exit(1);
> >  	}
> > @@ -667,6 +675,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
> >  		ctx->program_name = *argv;
> >  	else
> >  		ctx->program_name = "e2fsck";
> > +
> >  	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
> >  		switch (c) {
> >  		case 'C':
> > @@ -943,7 +952,6 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
> >  	return retval;
> >  }
> >  
> > -
> >  static const char *my_ver_string = E2FSPROGS_VERSION;
> >  static const char *my_ver_date = E2FSPROGS_DATE;
> >  
> 
> 

-- 
