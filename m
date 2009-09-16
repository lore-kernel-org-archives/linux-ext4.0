From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Wed, 16 Sep 2009 15:22:50 -0600
Message-ID: <20090916212250.GL2537@webber.adilger.int>
References: <20090916162457.GA84213@freezingfog.local>
 <20090916190831.GH2537@webber.adilger.int>
 <20090916204225.GB84213@freezingfog.local>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Will Drewry <redpig@dataspill.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38236 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZIPVWx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Sep 2009 17:22:53 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8GLMrFM027466
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2009 14:22:53 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ300F001ULB100@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 16 Sep 2009 14:22:52 -0700 (PDT)
In-reply-to: <20090916204225.GB84213@freezingfog.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 16, 2009  15:42 -0500, Will Drewry wrote:
> I'm interested in it for a few reasons:
> 1. it undermines the use of uninit_bg on large filesystems as
>    e2fsck -f will go back to normal speed, even without those block
>    groups being 'used'.  In my local example, it goes from 14s to 2m24s.

Ah, my bad...  It definitely makes sense to mark new groups added
during online resize as {BLOCK,INODE}_UNINIT if that feature is
enabled for the filesystem.  The e2fsck slowdown after a resize is
only a one-time event (that e2fsck would mark the unused groups as
UNINIT again) but it makes sense to do it correctly the first time.

> 2. it will spread the I/O cost out over time.  Online resizing often
>    means that you don't want to/can't unmount the fs.  However, a
>    large filesystem increase might result in gigabytes of 0s being
>    written to the backing store which could result in I/O throttling
>    that makes doing it online less useful.  It'd be nice to be able to
>    optionally amortize that cost as is done if the fs had been mke2fs -O
>    lazy_itable_init=1 at full size initially.

While this is true, there is a non-zero risk of problems if the inode
table isn't zeroed, which is why lazy_itable_init isn't the default.
The risk is that if the group descriptor is invalid for some reason
(found by bad checksum, or some inode in use beyond itable_unused)
then the UNINIT and itable_unused fields will be ignored and a full
inode table scan for that group is done.

If the itable isn't zeroed, then any old inodes (from a previous
filesystem, or garbage) will be "reattached" to the filesystem in
lost+found, and may cause a LOT of duplicate blocks processing (slow!).

If you had the time to work on the solution, it would be very useful,
and we could make lazy_itable_init the default.  What needs to be done
is have a thread that is created at filesystem mount that walks all the
groups and validates the GDT checksum, and zeroes inode tables and
bitmaps that are marked UNINIT w/o ZEROED.  For bonus points it could
check bitmap validity (later that might validate a bitmap checksum),
compute buddy bitmaps for groups that have free space, etc.

The thread would exit once all of the groups have had the inode tables
zeroed, or if the filesystem is unmounted.  In the common case (i.e.
once all inode tables are zeroed), it would just walk the already-loaded
group descriptor table looking for the ZEROED flag and no IO is done,
assuming we don't check the on-disk bitmaps on each mount (that could
be done only periodically, with a timestamp in the superblock).

> 3. dm/sparse-file-backed ext4 filesystems end up having the file size
>    expanded quite early as init'ing the itables force extra non-sparse
>    bytes to be written.  Otherwise, ext4+uninit_bg is a really nice fs
>    type for this purpose.

If you know the backing storage is always zero-filled (e.g. a new sparse
loop device), or you don't care about rare corruption bugs (i.e. for
test filesystems) then using lazy_itable_init is very useful for sure.

> Would it seriously raise the risk of corruption if uninit_bg is already
> in use? Alternately, would a patch to that effect stand a chance of ever
> making it upstream?

If the filesystem is already formatted with lazy_itable_init, then
doing further resizing w/o inode table zeroing is fine.

> I've attached a version with it being flagged by a "-l" for lazy.

It might make sense to avoid requiring the user to specify this,
rather remembering the option supplied at mke2fs time?  There is
the COMPAT_LAZY_BG superblock flag that might be usable for this,
though Ted might have some comments about any potential compatibility
issues.

Other than that, the patch looks reasonable at first glance.

> diff --git a/resize/main.c b/resize/main.c
> index 220c192..f04a939 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -39,7 +39,7 @@ char *program_name, *device_name, *io_options;
>  
>  static void usage (char *prog)
>  {
> -	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
> +	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-l] [-M] [-P] "
>  			   "[-p] device [new_size]\n\n"), prog);
>  
>  	exit (1);
> @@ -189,7 +189,7 @@ int main (int argc, char ** argv)
>  	if (argc && *argv)
>  		program_name = *argv;
>  
> -	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
> +	while ((c = getopt (argc, argv, "d:fFhlMPpS:")) != EOF) {
>  		switch (c) {
>  		case 'h':
>  			usage(program_name);
> @@ -209,6 +209,9 @@ int main (int argc, char ** argv)
>  		case 'd':
>  			flags |= atoi(optarg);
>  			break;
> +		case 'l':
> +			flags |= RESIZE_LAZY_INIT;
> +			break;
>  		case 'p':
>  			flags |= RESIZE_PERCENT_COMPLETE;
>  			break;
> diff --git a/resize/online.c b/resize/online.c
> index 4bc5451..f0b0569 100644
> --- a/resize/online.c
> +++ b/resize/online.c
> @@ -104,7 +104,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
>  	 * but at least it allows on-line resizing to function.
>  	 */
>  	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
> -	retval = adjust_fs_info(new_fs, fs, 0, *new_size);
> +	retval = adjust_fs_info(new_fs, fs, 0, *new_size, flags);
>  	if (retval)
>  		return retval;
>  
> diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> index 3ea7a63..020393e 100644
> --- a/resize/resize2fs.8.in
> +++ b/resize/resize2fs.8.in
> @@ -102,6 +102,9 @@ really useful for doing
>  .B resize2fs
>  time trials.
>  .TP
> +.B \-l
> +Lazily initialize new inode tables if supported (uninit_bg).
> +.TP
>  .B \-M
>  Shrink the filesystem to the minimum size.
>  .TP
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index 1a5d910..fee2e3f 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -41,7 +41,8 @@
>  #endif
>  
>  static void fix_uninit_block_bitmaps(ext2_filsys fs);
> -static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size);
> +static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size,
> +                                   int flags);
>  static errcode_t blocks_to_move(ext2_resize_t rfs);
>  static errcode_t block_mover(ext2_resize_t rfs);
>  static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
> @@ -106,7 +107,7 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
>  	if (retval)
>  		goto errout;
>  
> -	retval = adjust_superblock(rfs, *new_size);
> +	retval = adjust_superblock(rfs, *new_size, flags);
>  	if (retval)
>  		goto errout;
>  
> @@ -292,7 +293,7 @@ static void free_gdp_blocks(ext2_filsys fs,
>   * filesystem.
>   */
>  errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
> -			 ext2fs_block_bitmap reserve_blocks, blk_t new_size)
> +			 ext2fs_block_bitmap reserve_blocks, blk_t new_size, int flags)
>  {
>  	errcode_t	retval;
>  	int		overhead = 0;
> @@ -496,9 +497,11 @@ retry:
>  		adjblocks = 0;
>  
>  		fs->group_desc[i].bg_flags = 0;
> -		if (csum_flag)
> -			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT |
> -				EXT2_BG_INODE_ZEROED;
> +		if (csum_flag) {
> +			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT;
> +			if (!(flags & RESIZE_LAZY_INIT))
> +				fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
> +		}
>  		if (i == fs->group_desc_count-1) {
>  			numblocks = (fs->super->s_blocks_count -
>  				     fs->super->s_first_data_block) %
> @@ -565,10 +568,10 @@ errout:
>   * This routine adjusts the superblock and other data structures, both
>   * in disk as well as in memory...
>   */
> -static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
> +static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size, int flags)
>  {
>  	ext2_filsys fs;
> -	int		adj = 0;
> +	int		adj = 0, csum_flag = 0, num = 0;
>  	errcode_t	retval;
>  	blk_t		group_block;
>  	unsigned long	i;
> @@ -584,7 +587,7 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
>  	if (retval)
>  		return retval;
>  
> -	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size);
> +	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size, flags);
>  	if (retval)
>  		goto errout;
>  
> @@ -624,6 +627,9 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
>  				&rfs->itable_buf);
>  	if (retval)
>  		goto errout;
> +	/* Track if we can get by with a lazy init */
> +	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
>  
>  	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group);
>  	group_block = fs->super->s_first_data_block +
> @@ -642,10 +648,21 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk_t new_size)
>  		/*
>  		 * Write out the new inode table
>  		 */
> +		if (csum_flag && (flags & RESIZE_LAZY_INIT)) {
> +			/* These are _new_ inode tables. No inodes should be in use. */
> +			fs->group_desc[i].bg_itable_unused = fs->super->s_inodes_per_group;
> +			num = ((((fs->super->s_inodes_per_group -
> +				  fs->group_desc[i].bg_itable_unused) *
> +				 EXT2_INODE_SIZE(fs->super)) +
> +				EXT2_BLOCK_SIZE(fs->super) - 1) /
> +			       EXT2_BLOCK_SIZE(fs->super));
> +		} else {
> +			num = fs->inode_blocks_per_group;
> +		}
>  		retval = io_channel_write_blk(fs->io,
> -					      fs->group_desc[i].bg_inode_table,
> -					      fs->inode_blocks_per_group,
> -					      rfs->itable_buf);
> +					      fs->group_desc[i].bg_inode_table, /* blk */
> +					      num,  /* count */
> +					      rfs->itable_buf);  /* contents */
>  		if (retval) goto errout;
>  
>  		io_channel_flush(fs->io);
> diff --git a/resize/resize2fs.h b/resize/resize2fs.h
> index fab7290..d4c862c 100644
> --- a/resize/resize2fs.h
> +++ b/resize/resize2fs.h
> @@ -77,6 +77,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
>  #define RESIZE_DEBUG_INODEMAP		0x0004
>  #define RESIZE_DEBUG_ITABLEMOVE		0x0008
>  
> +#define RESIZE_LAZY_INIT		0x0010
> +
>  #define RESIZE_PERCENT_COMPLETE		0x0100
>  #define RESIZE_VERBOSE			0x0200
>  
> @@ -129,7 +131,8 @@ extern errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
>  
>  extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
>  				ext2fs_block_bitmap reserve_blocks,
> -				blk_t new_size);
> +				blk_t new_size,
> +				int flags);
>  extern blk_t calculate_minimum_resize_size(ext2_filsys fs);
>  
>  

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

