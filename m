From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2 v2] e2fsck: Discard only unused parts of inode
 table
Date: Wed, 29 Feb 2012 08:22:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202290812530.4926@dhcp-27-109.brq.redhat.com>
References: <1330014566-2020-1-git-send-email-lczerner@redhat.com> <4F4D0159.1090409@sandeen.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, psusi@ubuntu.com
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030750Ab2B2HWx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 02:22:53 -0500
In-Reply-To: <4F4D0159.1090409@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 28 Feb 2012, Eric Sandeen wrote:

> On 02/23/2012 10:29 AM, Lukas Czerner wrote:
> > When calling e2fsck with '-E discard' option it might happen that
> > valid inodes are discarded accidentally. This is because we just
> > discard the part of inode table which lies past the highest used
> > inode. This is terribly wrong (sorry!).
> > 
> > This patch fixes it so only the free parts of an inode table
> > is discarded, leaving used inodes intact. This was tested with highly
> > fragmented inode tables with block size 4k and 1k.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Reported-by: Phillip Susi <psusi@ubuntu.com>
> 
> Apologies for being so iterative about this review but it's taken a while
> for this function to make sense to me.
> 
> This patch does seem to fix the original bug, but I have a few more
> nitpicks below.
> 
> > ---
> > v2: reworked so that we comply with inode number counting and adjust
> >     start in the e2fsck_discard_inodes(). Add some comments
> 
> >  e2fsck/pass5.c |   82 ++++++++++++++++++++++++++++++++++++++++---------------
> >  1 files changed, 59 insertions(+), 23 deletions(-)
> > 
> > diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> > index 1e836e3..57a207d 100644
> > --- a/e2fsck/pass5.c
> > +++ b/e2fsck/pass5.c
> > @@ -94,6 +94,43 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
> >  		ctx->options &= ~E2F_OPT_DISCARD;
> >  }
> >  
> > +/*
> > + * This will try to discard number 'count' starting at inode
> > + * number 'start'. Note that 'start' is a inode number and hence
> > + * it is counted from 1, it means that we need to adjust it
> > + * by -1 in this function to compute right offset in the
> > + * inode table.
> > + */
> 
> But that's not quite right... a casual reader would assume that we
> pass in the inode number of the starting inode we want to free;
> that's true for the first group, but not the rest:

Well, I thought that this should be obvious since we pass in 'group'
number as well. So what do you think the right comment should be ?

> 
> $ e2fsck/e2fsck -f -E discard fsfile 
> e2fsck 1.42 (29-Nov-2011)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> discard starting at 12
> discard starting at 1
> discard starting at 1
> discard starting at 1
> discard starting at 1
> discard starting at 1
> 
> ...
> 
> we are not discarding inode 1 that many times ;) 
> 
> The comment should reflect that the function expects to receive
> the inode number within this group, i.e. the Nth inode, starting
> with the 1st, i.e. 1-based.  (which is a little weird, but I don't
> see a better way).
> 
> The calling loop _does_ keep track of the actual inode number
> within the system ('i') - but that's not what's passed in here,
> and I don't think ctx->fs has the info we need to be able to
> do it that way.
> 
> > +static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
> > +				  int start, int count)
> > +{
> > +	ext2_filsys fs = ctx->fs;
> > +	blk64_t blk, num;
> > +	int orig = count;
> > +
> > +	if ((ctx->options & E2F_OPT_NO) || !(ctx->options & E2F_OPT_DISCARD))
> > +		return;
> > +
> > +	/*
> > +	 * Start is inode number which starts counting from 1,
> 
> ... inode number within the group ...
> 
> > +	 * so we need to adjust it.
> > +	 */
> > +	start -= 1;
> 
> I wonder if we need defense against programming errors here; if start
> inadvertently comes in at 0, what happens?  I suppose blk goes off the end
> and other checks hopefully catch it... probably not 'til it hits the kernel
> though?

Then blk overflows and would point the start to something like 524287TB,
but I think that we can defense it here.

> 
> > +	/*
> > +	 * We can discard only blocks containing only unused
> > +	 * inodes in the table.
> > +	 */
> > +	blk = DIV_ROUND_UP(start,
> > +		EXT2_INODES_PER_BLOCK(fs->super));
> > +	count -= (blk * EXT2_INODES_PER_BLOCK(fs->super) - start);
> > +	blk += ext2fs_inode_table_loc(fs, group);
> > +	num = count / EXT2_INODES_PER_BLOCK(fs->super);
> > +
> > +	if (num > 0)
> > +		e2fsck_discard_blocks(ctx, fs->io->manager, blk, num);
> > +}
> > +
> >  #define NO_BLK ((blk64_t) -1)
> >  
> >  static void print_bitmap_problem(e2fsck_t ctx, int problem,
> > @@ -435,6 +472,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
> >  	int		skip_group = 0;
> >  	int		redo_flag = 0;
> >  	io_manager	manager = ctx->fs->io->manager;
> > +	unsigned long long	first_free = fs->super->s_inodes_per_group + 1;
> 
> >  
> >  	clear_problem_context(&pctx);
> >  	free_array = (int *) e2fsck_allocate_memory(ctx,
> > @@ -497,6 +535,7 @@ redo_counts:
> >  				 * are 0, count the free inode,
> >  				 * skip the current block group.
> >  				 */
> > +				first_free = 1;
> >  				inodes = fs->super->s_inodes_per_group - 1;
> >  				group_free = inodes;
> >  				free_inodes += inodes;
> > @@ -561,50 +600,47 @@ redo_counts:
> >  		ctx->options &= ~E2F_OPT_DISCARD;
> >  
> >  do_counts:
> > +		inodes++;
> >  		if (bitmap) {
> >  			if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i))
> >  				dirs_count++;
> > +			if (inodes > first_free) {
> > +				e2fsck_discard_inodes(ctx, group, first_free,
> > +						      inodes - first_free);
> > +				first_free = fs->super->s_inodes_per_group + 1;
> > +			}
> >  		} else if (!skip_group || csum_flag) {
> >  			group_free++;
> >  			free_inodes++;
> > +			if (first_free > inodes)
> > +				first_free = inodes;
> >  		}
> >  
> > -		inodes++;
> >  		if ((inodes == fs->super->s_inodes_per_group) ||
> >  		    (i == fs->super->s_inodes_count)) {
> > -
> > -			free_array[group] = group_free;
> > -			dir_array[group] = dirs_count;
> > -
> > -			/* Discard inode table */
> > -			if (ctx->options & E2F_OPT_DISCARD) {
> > -				blk64_t used_blks, blk, num;
> > -
> > -				used_blks = DIV_ROUND_UP(
> > -					(EXT2_INODES_PER_GROUP(fs->super) -
> > -					group_free),
> > -					EXT2_INODES_PER_BLOCK(fs->super));
> > -
> > -				blk = ext2fs_inode_table_loc(fs, group) +
> > -				      used_blks;
> > -				num = fs->inode_blocks_per_group -
> > -				      used_blks;
> > -				e2fsck_discard_blocks(ctx, manager, blk, num);
> > -			}
> > -
> > +			/*
> > +			 * If the last inode is free, we can discard it as well.
> > +			 */
> > +			if (inodes >= first_free)
> > +				e2fsck_discard_inodes(ctx, group, first_free,
> > +						      inodes - first_free + 1);
> 
> This is unrelated to the changelog
> 
> >  			/*
> >  			 * If discard zeroes data and the group inode table
> >  			 * was not zeroed yet, set itable as zeroed
> >  			 */
> >  			if ((ctx->options & E2F_OPT_DISCARD) &&
> > -			    (io_channel_discard_zeroes_data(fs->io)) &&
> > +			    !(ctx->options & E2F_OPT_NO) &&
> 
> This is unrelated as well...

So do you want me to separate those unrelated changes to a separate
patch ? Those are pretty small changes..

> 
> Rather than continuing to check _OPT_NO here and in e2fsck_discard_blocks(), it
> might be better (in a separate patch) ;) to simply turn off OPT_DISCARD right
> after options processing if -n was specified, and not worry about it down here.

Makes sense, I can change it.

Thanks!
-Lukas

> 
> > +			    io_channel_discard_zeroes_data(fs->io) &&
> >  			    !(ext2fs_bg_flags_test(fs, group,
> > -						  EXT2_BG_INODE_ZEROED))) {
> > +						   EXT2_BG_INODE_ZEROED))) {
> >  				ext2fs_bg_flags_set(fs, group,
> >  						    EXT2_BG_INODE_ZEROED);
> >  				ext2fs_group_desc_csum_set(fs, group);
> >  			}
> >  
> > +			first_free = fs->super->s_inodes_per_group + 1;
> > +			free_array[group] = group_free;
> > +			dir_array[group] = dirs_count;
> >  			group ++;
> >  			inodes = 0;
> >  			skip_group = 0;
> 
> 

-- 
