From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] resize2fs: Add support for lazy itable
 initialization
Date: Mon, 16 May 2011 15:41:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105161541340.3670@dhcp-27-109.brq.redhat.com>
References: <1296580465-28519-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1102161142180.4744@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@MIT.EDU
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab1EPNlt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 09:41:49 -0400
In-Reply-To: <alpine.LFD.2.00.1102161142180.4744@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Feb 2011, Lukas Czerner wrote:

> On Tue, 1 Feb 2011, Lukas Czerner wrote:
> 
> > Lazy inode table initialization speeds up file system resize operation
> > because we can let the inode tables uninitialized. For some time now the
> > mke2fs has similar option and now, when we have in-kernel lazyinit
> > implementation we can add this feature to the resize2fs as well.
> > 
> > This commit adds extended options '-E' to the resize2fs code along with
> > the first extended option lazy_itable_init=n. With lazy_itable_init
> > extended option one can instruct resize2fs to skip inode table
> > initialization to significantly speed-up file system resize. If the
> > option is omitted and the file system supports lazy inode table
> > initialization it defaults to 1.
> 
> ping

ping^2

> 
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  resize/main.c         |   68 +++++++++++++++++++++++++++++++-
> >  resize/online.c       |    2 +-
> >  resize/resize2fs.8.in |   20 +++++++++
> >  resize/resize2fs.c    |  105 +++++++++++++++++++++++++++---------------------
> >  resize/resize2fs.h    |    3 +-
> >  5 files changed, 148 insertions(+), 50 deletions(-)
> > 
> > diff --git a/resize/main.c b/resize/main.c
> > index 28a49ba..0f1a8db 100644
> > --- a/resize/main.c
> > +++ b/resize/main.c
> > @@ -40,7 +40,8 @@ char *program_name, *device_name, *io_options;
> >  static void usage (char *prog)
> >  {
> >  	fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
> > -			   "[-p] device [new_size]\n\n"), prog);
> > +			   "[-p] [-E extended_options] device [new_size]\n\n"),
> > +			   prog);
> >  
> >  	exit (1);
> >  }
> > @@ -146,6 +147,59 @@ static void determine_fs_stride(ext2_filsys fs)
> >  #endif
> >  }
> >  
> > +static void parse_extended_opts(int *flags, const char *opts)
> > +{
> > +	char	*buf, *token, *next, *p, *arg, *badopt = 0;
> > +	int	len;
> > +	int	r_usage = 0;
> > +
> > +	len = strlen(opts);
> > +	buf = malloc(len+1);
> > +	if (!buf) {
> > +		fprintf(stderr,
> > +			_("Couldn't allocate memory to parse options!\n"));
> > +		exit(1);
> > +	}
> > +	strcpy(buf, opts);
> > +	for (token = buf; token && *token; token = next) {
> > +		p = strchr(token, ',');
> > +		next = 0;
> > +		if (p) {
> > +			*p = 0;
> > +			next = p+1;
> > +		}
> > +		arg = strchr(token, '=');
> > +		if (arg) {
> > +			*arg = 0;
> > +			arg++;
> > +		}
> > +		if (!strcmp(token, "lazy_itable_init")) {
> > +			int lazy;
> > +			if (arg)
> > +				lazy = strtoul(arg, &p, 0);
> > +			else
> > +				lazy = 1;
> > +			if (lazy)
> > +				*flags |= RESIZE_LAZY_ITABLE_INIT;
> > +		} else {
> > +			r_usage++;
> > +			badopt = token;
> > +		}
> > +	}
> > +	if (r_usage) {
> > +		fprintf(stderr, _("\nBad option(s) specified: %s\n\n"
> > +			"Extended options are separated by commas, "
> > +			"and may take an argument which\n"
> > +			"\tis set off by an equals ('=') sign.\n\n"
> > +			"Valid extended options are:\n"
> > +			"\tlazy_itable_init=<0 to disable, 1 to enable>\n\n"),
> > +			badopt ? badopt : "");
> > +		free(buf);
> > +		exit(1);
> > +	}
> > +	free(buf);
> > +}
> > +
> >  int main (int argc, char ** argv)
> >  {
> >  	errcode_t	retval;
> > @@ -174,6 +228,7 @@ int main (int argc, char ** argv)
> >  	long		sysval;
> >  	int		len, mount_flags;
> >  	char		*mtpt;
> > +	char *		extended_opts = NULL;
> >  
> >  #ifdef ENABLE_NLS
> >  	setlocale(LC_MESSAGES, "");
> > @@ -189,7 +244,7 @@ int main (int argc, char ** argv)
> >  	if (argc && *argv)
> >  		program_name = *argv;
> >  
> > -	while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
> > +	while ((c = getopt (argc, argv, "d:fFhMPpS:E:")) != EOF) {
> >  		switch (c) {
> >  		case 'h':
> >  			usage(program_name);
> > @@ -215,6 +270,9 @@ int main (int argc, char ** argv)
> >  		case 'S':
> >  			use_stride = atoi(optarg);
> >  			break;
> > +		case 'E':
> > +			extended_opts = optarg;
> > +			break;
> >  		default:
> >  			usage(program_name);
> >  		}
> > @@ -232,6 +290,12 @@ int main (int argc, char ** argv)
> >  	if (io_options)
> >  		*io_options++ = 0;
> >  
> > +	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
> > +		flags |= RESIZE_LAZY_ITABLE_INIT;
> > +
> > +	if (extended_opts)
> > +		parse_extended_opts(&flags, extended_opts);
> > +
> >  	/*
> >  	 * Figure out whether or not the device is mounted, and if it is
> >  	 * where it is mounted.
> > diff --git a/resize/online.c b/resize/online.c
> > index 1d8d4ec..7bc27b3 100644
> > --- a/resize/online.c
> > +++ b/resize/online.c
> > @@ -104,7 +104,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
> >  	 * but at least it allows on-line resizing to function.
> >  	 */
> >  	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
> > -	retval = adjust_fs_info(new_fs, fs, 0, *new_size);
> > +	retval = adjust_fs_info(new_fs, fs, 0, *new_size, 0);
> >  	if (retval)
> >  		return retval;
> >  
> > diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> > index e02345d..448265c 100644
> > --- a/resize/resize2fs.8.in
> > +++ b/resize/resize2fs.8.in
> > @@ -18,6 +18,10 @@ resize2fs \- ext2/ext3/ext4 file system resizer
> >  .B \-S
> >  .I RAID-stride
> >  ]
> > +[
> > +.B \-E
> > +.I extended-options
> > +]
> >  .I device
> >  [
> >  .I size
> > @@ -128,6 +132,22 @@ The
> >  program will heuristically determine the RAID stride that was specified
> >  when the filesystem was created.  This option allows the user to
> >  explicitly specify a RAID stride setting to be used by resize2fs instead.
> > +.TP
> > +.B \-E \fIextended-options
> > +Set extended options for the filesystem.  Extended options are comma
> > +separated, and may take an argument using the equals ('=') sign.
> > +The following extended options are supported:
> > +.RS 1.2i
> > +.TP
> > +.B lazy_itable_init\fR[\fB= \fI<0 to disable, 1 to enable>\fR]
> > +If enabled and the uninit_bg feature is enabled, the inode table will
> > +not be fully initialized by
> > +.BR resize2fs .
> > +This speeds up filesystem
> > +resize noticeably, but it requires the kernel to finish
> > +initializing the filesystem in the background when the filesystem is
> > +mounted.  If the option value is omitted, it defaults to 1 to
> > +enable lazy inode table initialization.
> >  .SH KNOWN BUGS
> >  The minimum size of the filesystem as estimated by resize2fs may be
> >  incorrect, especially for filesystems with 1k and 2k blocksizes.
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index 216a626..1101364 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -41,7 +41,8 @@
> >  #endif
> >  
> >  static void fix_uninit_block_bitmaps(ext2_filsys fs);
> > -static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size);
> > +static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size,
> > +				   int flags);
> >  static errcode_t blocks_to_move(ext2_resize_t rfs);
> >  static errcode_t block_mover(ext2_resize_t rfs);
> >  static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
> > @@ -102,7 +103,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
> >  	if (retval)
> >  		goto errout;
> >  
> > -	retval = adjust_superblock(rfs, *new_size);
> > +	retval = adjust_superblock(rfs, *new_size, flags);
> >  	if (retval)
> >  		goto errout;
> >  
> > @@ -288,7 +289,8 @@ static void free_gdp_blocks(ext2_filsys fs,
> >   * filesystem.
> >   */
> >  errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
> > -			 ext2fs_block_bitmap reserve_blocks, blk64_t new_size)
> > +			 ext2fs_block_bitmap reserve_blocks, blk64_t new_size,
> > +			 int flags)
> >  {
> >  	errcode_t	retval;
> >  	blk64_t		overhead = 0;
> > @@ -497,8 +499,12 @@ retry:
> >  		adjblocks = 0;
> >  
> >  		ext2fs_bg_flags_zap(fs, i);
> > -		if (csum_flag)
> > +		if (csum_flag && (flags & RESIZE_LAZY_ITABLE_INIT))
> > +			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
> > +		else if (csum_flag)
> >  			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
> > +		else
> > +			flags &= ~RESIZE_LAZY_ITABLE_INIT;
> >  		if (i == fs->group_desc_count-1) {
> >  			numblocks = (ext2fs_blocks_count(fs->super) -
> >  				     fs->super->s_first_data_block) %
> > @@ -562,18 +568,57 @@ errout:
> >  	return (retval);
> >  }
> >  
> > +static errcode_t write_inode_tables(ext2_resize_t rfs, ext2_filsys fs)
> > +{
> > +	unsigned long	i, max_group;
> > +	errcode_t	retval;
> > +	int		adj = 0;
> > +
> > +	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group);
> > +	adj = rfs->old_fs->group_desc_count;
> > +	max_group = fs->group_desc_count - adj;
> > +	if (rfs->progress) {
> > +		retval = rfs->progress(rfs, E2_RSZ_EXTEND_ITABLE_PASS,
> > +				       0, max_group);
> > +		if (retval)
> > +			goto out;
> > +	}
> > +
> > +	for (i = rfs->old_fs->group_desc_count;
> > +	     i < fs->group_desc_count; i++) {
> > +		/*
> > +		 * Write out the new inode table
> > +		 */
> > +		retval = io_channel_write_blk64(fs->io,
> > +						ext2fs_inode_table_loc(fs, i),
> > +						fs->inode_blocks_per_group,
> > +						rfs->itable_buf);
> > +		if (retval)
> > +			break;
> > +
> > +		io_channel_flush(fs->io);
> > +		if (rfs->progress) {
> > +			retval = rfs->progress(rfs, E2_RSZ_EXTEND_ITABLE_PASS,
> > +					       i - adj + 1, max_group);
> > +			if (retval)
> > +				break;
> > +		}
> > +	}
> > +	io_channel_flush(fs->io);
> > +out:
> > +	return retval;
> > +}
> > +
> > +
> >  /*
> >   * This routine adjusts the superblock and other data structures, both
> >   * in disk as well as in memory...
> >   */
> > -static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
> > +static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size,
> > +				   int flags)
> >  {
> > -	ext2_filsys fs;
> > -	int		adj = 0;
> > +	ext2_filsys	fs;
> >  	errcode_t	retval;
> > -	blk64_t		group_block;
> > -	unsigned long	i;
> > -	unsigned long	max_group;
> >  
> >  	fs = rfs->new_fs;
> >  	ext2fs_mark_super_dirty(fs);
> > @@ -585,7 +630,8 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
> >  	if (retval)
> >  		return retval;
> >  
> > -	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size);
> > +	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size,
> > +				flags);
> >  	if (retval)
> >  		goto errout;
> >  
> > @@ -626,41 +672,8 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
> >  	if (retval)
> >  		goto errout;
> >  
> > -	memset(rfs->itable_buf, 0, fs->blocksize * fs->inode_blocks_per_group);
> > -	group_block = fs->super->s_first_data_block +
> > -		rfs->old_fs->group_desc_count * fs->super->s_blocks_per_group;
> > -
> > -	adj = rfs->old_fs->group_desc_count;
> > -	max_group = fs->group_desc_count - adj;
> > -	if (rfs->progress) {
> > -		retval = rfs->progress(rfs, E2_RSZ_EXTEND_ITABLE_PASS,
> > -				       0, max_group);
> > -		if (retval)
> > -			goto errout;
> > -	}
> > -	for (i = rfs->old_fs->group_desc_count;
> > -	     i < fs->group_desc_count; i++) {
> > -		/*
> > -		 * Write out the new inode table
> > -		 */
> > -		retval = io_channel_write_blk64(fs->io,
> > -						ext2fs_inode_table_loc(fs, i),
> > -						fs->inode_blocks_per_group,
> > -						rfs->itable_buf);
> > -		if (retval) goto errout;
> > -
> > -		io_channel_flush(fs->io);
> > -		if (rfs->progress) {
> > -			retval = rfs->progress(rfs, E2_RSZ_EXTEND_ITABLE_PASS,
> > -					       i - adj + 1, max_group);
> > -			if (retval)
> > -				goto errout;
> > -		}
> > -		group_block += fs->super->s_blocks_per_group;
> > -	}
> > -	io_channel_flush(fs->io);
> > -	retval = 0;
> > -
> > +	if (!(flags & RESIZE_LAZY_ITABLE_INIT))
> > +		retval = write_inode_tables(rfs, fs);
> >  errout:
> >  	return retval;
> >  }
> > diff --git a/resize/resize2fs.h b/resize/resize2fs.h
> > index 2184759..a968071 100644
> > --- a/resize/resize2fs.h
> > +++ b/resize/resize2fs.h
> > @@ -79,6 +79,7 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
> >  
> >  #define RESIZE_PERCENT_COMPLETE		0x0100
> >  #define RESIZE_VERBOSE			0x0200
> > +#define RESIZE_LAZY_ITABLE_INIT		0x0400	/* Do not initialize inode tables*/
> >  
> >  /*
> >   * The core state structure for the ext2 resizer
> > @@ -129,7 +130,7 @@ extern errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
> >  
> >  extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
> >  				ext2fs_block_bitmap reserve_blocks,
> > -				blk64_t new_size);
> > +				blk64_t new_size, int flags);
> >  extern blk64_t calculate_minimum_resize_size(ext2_filsys fs);
> >  
> >  
> > 
> 
> 

-- 
