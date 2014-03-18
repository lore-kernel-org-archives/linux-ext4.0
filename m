From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 37/49] e2fsck: read-ahead metadata during passes 1, 2,
 and 4
Date: Mon, 17 Mar 2014 21:42:31 -0700
Message-ID: <20140318044231.GA20038@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065757.30585.46729.stgit@birch.djwong.org>
 <8715537A-D22B-4CDC-B76B-75B62FDBC1D7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46108 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaCREmi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Mar 2014 00:42:38 -0400
Content-Disposition: inline
In-Reply-To: <8715537A-D22B-4CDC-B76B-75B62FDBC1D7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 05:10:22PM -0600, Andreas Dilger wrote:
> 
> On Mar 11, 2014, at 12:57 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > e2fsck pass1 is modified to use the block group data prefetch function
> > to try to fetch the inode tables into the pagecache before it is
> > needed.  In order to avoid cache thrashing, we limit ourselves to
> > prefetching at most half the available memory.
> 
> It looks like the prefetching is done in huge chunks, and not incrementally?
> It makes more sense to have a steady amount of prefetch happening instead
> of waiting for it to all be consumed before starting a new batch.  See in
> e2fsck_pass1() below.

I agree that prefetch ought not to wait until the entire inode table is
consumed.

> > pass2 is modified to use the dirblock prefetching function to prefetch
> > the list of directory blocks that are assembled in pass1.  So long as
> > we don't anticipate rehashing the dirs (pass 3a), we can release the
> > dirblocks as soon as we're done checking them.
> > 
> > pass4 is modified to prefetch the block and inode bitmaps in
> > anticipation of pass 5, because pass4 is entirely CPU bound.
> > 
> > In general, these mechanisms can halve fsck time, if the host system
> > has sufficient memory and the storage system can provide a lot of
> > IOPs.  SSDs and multi-spindle RAIDs see the most speedup; single disks
> > experience a modest speedup, and single-spindle USB mass storage
> > devices see hardly any benefit.
> > 
> > By default, readahead will try to fill half the physical memory in the
> > system.  The -R option can be given to specify the amount of memory to
> > use for readahead, or zero to disable it entirely; or an option can be
> > given in e2fsck.conf.
> > 
> > 
> > +static void *pass1_readahead(void *p)
> > +{
> > +	struct pass1ra_ctx *c = p;
> > +	errcode_t err;
> > +
> > +	ext2fs_readahead(c->fs, EXT2_READA_ITABLE, c->group, c->ngroups);
> > +	return NULL;
> > +}
> > +
> > +static errcode_t initiate_readahead(e2fsck_t ctx, dgrp_t group, dgrp_t ngroups)
> > +{
> > +	struct pass1ra_ctx *ractx;
> > +	errcode_t err;
> > +
> > +	err = ext2fs_get_mem(sizeof(*ractx), &ractx);
> > +	if (err)
> > +		return err;
> > +
> > +	ractx->fs = ctx->fs;
> > +	ractx->group = group;
> > +	ractx->ngroups = ngroups;
> > +
> > +	err = e2fsck_run_thread(&ctx->ra_thread, pass1_readahead,
> > +				pass1_readahead_cleanup, ractx);
> > +	if (err)
> > +		ext2fs_free_mem(&ractx);
> > +
> > +	return err;
> > +}
> > +
> >  void e2fsck_pass1(e2fsck_t ctx)
> >  {
> > 	int	i;
> > @@ -611,10 +654,37 @@ void e2fsck_pass1(e2fsck_t ctx)
> > 	int		busted_fs_time = 0;
> > 	int		inode_size;
> > 	int		failed_csum = 0;
> > +	dgrp_t		grp;
> > +	ext2_ino_t	ra_threshold = 0;
> > +	dgrp_t		ra_groups = 0;
> > +	errcode_t	err;
> > 
> > 	init_resource_track(&rtrack, ctx->fs->io);
> > 	clear_problem_context(&pctx);
> > 
> > +	/* If we can do readahead, figure out how many groups to pull in. */
> > +	if (!ext2fs_can_readahead(ctx->fs))
> > +		ctx->readahead_mem_kb = 0;
> > +	if (ctx->readahead_mem_kb) {
> > +		ra_groups = ctx->readahead_mem_kb /
> > +			    (fs->inode_blocks_per_group * fs->blocksize /
> > +			     1024);
> > +		if (ra_groups < 16)
> > +			ra_groups = 0;
> 
> It probably always makes sense to prefetch one group if possible?

I was intending to skip pass1 RA if there wasn't a lot of memory around.  Not
that I did a lot of work to figure out if < 16 groups really was a "lowmem"
situation.

> > +		else if (ra_groups > fs->group_desc_count)
> > +			ra_groups = fs->group_desc_count;
> > +		if (ra_groups) {
> > +			err = initiate_readahead(ctx, grp, ra_groups);
> 
> Looks like "grp" is used uninitialized here.  Should be "grp = 0" to start.

Oops, good catch.

> > +			if (err) {
> > +				com_err(ctx->program_name, err, "%s",
> > +					_("while starting pass1 readahead"));
> > +				ra_groups = 0;
> > +			}
> > +			ra_threshold = ra_groups *
> > +				       fs->super->s_inodes_per_group;
> 
> This is the threshold of the last inode to be prefetched.

Yes.

> > +		}
> > +	}
> > +
> > 	if (!(ctx->options & E2F_OPT_PREEN))
> > 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
> > 
> > @@ -778,6 +848,19 @@ void e2fsck_pass1(e2fsck_t ctx)
> > 			if (e2fsck_mmp_update(fs))
> > 				fatal_error(ctx, 0);
> > 		}
> > +		if (ra_groups && ino > ra_threshold) {
> 
> This doesn't start prefetching again until the last inode is checked.
> It probably makes sense to have a sliding window to start readahead
> again once half of the memory has been consumed or so.  Otherwise,
> the scanning will block here until the next inode table is read from
> disk, instead of the readahead being started earlier and it is in RAM.

You're right, it would be even faster if ra_threshold were to start RA a couple
of block groups *before* we run out of prefetched data.

> > +			grp = (ino - 1) / fs->super->s_inodes_per_group;
> > +			ra_threshold = (grp + ra_groups) *
> > +				       fs->super->s_inodes_per_group;
> 
> > +			err = initiate_readahead(ctx, grp, ra_groups);
> > +			if (err == EAGAIN) {
> > +				printf("Disabling slow readahead.\n");
> > +				ra_groups = 0;
> 
> I see that EAGAIN comes from e2fsck_run_thread(), if there is still a
> readahead thread running.  Does it make sense to stop readahead in
> that case?  It would seem to me that if readahead is taking a long
> time and the inode processing is catching up to it (i.e. IO bound)
> then it is even more important to do readahead in that case.

This is tricky -- POSIX_FADV_WILLNEED starts a non-blocking readahead, so there
really isn't any good way to tell if the inode checker has caught up to RA.
Here I'm interpreting "RA thread still running" as a warning that soon the
inode checker will be ahead of the RA, so we might as well stop the RA.
However, there still isn't really much good way to find out exactly where RA
is.

> Something like the following to readahead half of the inode tables once
> half of them have been processed, and shrink the readahead window if the
> readahead is being called too often:

Hmm.  I will give this a shot and report back; this seems like it ought to
produce a better result than "two before" as I suggested above.

> 	if (ra_groups != 0 && ino > ra_threshold - (ra_groups + 1) / 2 *
> 					fs->super->s_inodes_per_group) {
>		if (ra_threshold < ino)
> 			ra_threshold = ino;
> 		grp = (ra_threshold -1) / fs->super->s_inodes_per_group;
> 		err = initiate_readahead(ctx, grp, (ra_groups + 1) / 2);
> 		if (err == EAGAIN)
> 			ra_groups = (ra_groups + 1) / 2;
> 		else if (err)
> 			com_err(ctx->program_name, err, "%s",
> 				_("while starting pass1 readahead"));
> 		else
> 			ra_threshold += (ra_groups + 1) / 2 *
> 				fs->super->s_inodes_per_group;
> 	}
> 
> > +			} else if (err) {
> > +				com_err(ctx->program_name, err, "%s",
> > +					_("while starting pass1 readahead"));
> > +			}
> > +		}
> > 		old_op = ehandler_operation(_("getting next inode from scan"));
> > 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
> > 							  inode, inode_size);
> > diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> > index 80ebdb1..d6ef8c5 100644
> > --- a/e2fsck/unix.c
> > +++ b/e2fsck/unix.c
> > @@ -74,7 +74,7 @@ static void usage(e2fsck_t ctx)
> > 		_("Usage: %s [-panyrcdfvtDFV] [-b superblock] [-B blocksize]\n"
> > 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
> > 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
> > -		"\t\t[-E extended-options] device\n"),
> > +		"\t\t[-E extended-options] [-R readahead_kb] device\n"),
> 
> Note that "-R" is only recently deprecated for raid options, why not make
> this an option under "-E"?

Ok.

--D
> 
> > 		ctx->program_name);
> > 
> > 	fprintf(stderr, "%s", _("\nEmergency help:\n"
> > @@ -90,6 +90,7 @@ static void usage(e2fsck_t ctx)
> > 		" -j external_journal  Set location of the external journal\n"
> > 		" -l bad_blocks_file   Add to badblocks list\n"
> > 		" -L bad_blocks_file   Set badblocks list\n"
> > +		" -R readahead_kb      Allow this much readahead.\n"
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


