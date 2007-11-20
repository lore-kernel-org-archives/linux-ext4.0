From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Tue, 20 Nov 2007 16:58:26 +0100
Message-ID: <20071120155826.GB31177@atrey.karlin.mff.cuni.cz>
References: <4739B0C0.3060907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37019 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbXKTP61 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2007 10:58:27 -0500
Content-Disposition: inline
In-Reply-To: <4739B0C0.3060907@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi Coly,

  finally I've found some time to have a look at a new version of your
patch.

> 5, Performance number
> On a Core-Duo, 2MB DDM memory, 7200 RPM SATA PC, I built a 50GB ext4
> partition, and tried to create 50000 directories, and create 15 (1KB)
> files in each directory alternatively. After a remount, I tried to
> remove all the directories and files recursively by a 'rm -rf'. Bellow
> is the benchmark result,
> 			normal ext4			ext4 with dir inode reservation
> 	mount options:	-o data=writeback		-o data=writeback,dir_ireserve=low
> 	Create dirs:	real    0m49.101s		real    2m59.703s
> 	Create files:	real    24m17.962s		real    21m8.161s
> 	Unlink all:	real    24m43.788s		real    17m29.862s
> Creating dirs with dir inode reservation is slower than normal ext4 as
> predicted, because allocating directory inodes in non-linear order
> will cause extra hard disk seeking and block I/O. Creating files with
> dir inode reservation is 13% faster than normal ext4. Unlink all the
> directories and files is 29.2% faster as expected.  When number of
> directories is increased, the performance improvement will be more
> considerable. More benchmark result will be posted here if necessary,
> because I need more time to run more test cases.
  Maybe to get some better idea - could you compare how long does take
untar of a kernel tree, find through the whole kernel tree and removal
of the tree? Also measuring CPU load during your benchmarks would be
useful so that we can see whether we don't increase too much the cost of
searching in bitmaps...

  The patch is nicely short ;)

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 17b5df1..f838a72 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -10,6 +10,8 @@
>   *  Stephen Tweedie (sct@redhat.com), 1993
>   *  Big-endian to little-endian byte-swapping/bitmaps by
>   *        David S. Miller (davem@caip.rutgers.edu), 1995
> + *  Directory inodes reservation by
> + *        Coly Li (coyli@suse.de), 2007
>   */
> 
>  #include <linux/time.h>
> @@ -478,6 +480,75 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
>  	return -1;
>  }
> 
> +static int ext4_ino_from_ireserve(handle_t *handle, struct inode *dir,
> +			  int mode, ext4_group_t *group, unsigned long *ino)
> +{
> +	struct super_block *sb;
> +	struct ext4_sb_info *sbi;
> +	struct ext4_group_desc *gdp = NULL;
> +	struct buffer_head *gdp_bh = NULL, *bitmap_bh = NULL;
> +	ext4_group_t ires_group = *group;
> +	unsigned long ires_ino;
> +	int i, bit;
> +
> +	sb = dir->i_sb;
> +	sbi = EXT4_SB(sb);
> +
> +	/* if the inode number is not for directory,
> +	 * only try to allocate after directory's inode
> +	 */
> +	if (!S_ISDIR(mode)) {
> +		*ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
> +		return 0;
> +	}
  ^^^ You don't set a group here - is this intentional? It means we get
the group from find_group_other() and there we start searching at a
place corresponding to parent's inode number... That would be an
interesting heuristic but I'm not sure if that's what you want.

> +
> +	/* reserve inodes for new directory */
> +	for (i = 0; i < sbi->s_groups_count; i++) {
> +		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
> +		if (!gdp)
> +			goto fail;
> +		bit = 0;
> +try_same_group:
> +		if (bit < EXT4_INODES_PER_GROUP(sb)) {
> +			brelse(bitmap_bh);
> +			bitmap_bh = read_inode_bitmap(sb, ires_group);
> +			if (!bitmap_bh)
> +				goto fail;
> +
> +			BUFFER_TRACE(bitmap_bh, "get_write_access");
> +			if (ext4_journal_get_write_access(
> +				handle, bitmap_bh) != 0)
> +				goto fail;
> +			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, ires_group),
> +					bit, bitmap_bh->b_data)) {
> +				/* we won it */
> +				BUFFER_TRACE(bitmap_bh,
> +					"call ext4_journal_dirty_metadata");
> +				if (ext4_journal_dirty_metadata(handle,
> +							bitmap_bh) != 0)
> +					goto fail;
> +				ires_ino = bit;
> +				goto find;
> +			}
> +			/* we lost it */
> +			jbd2_journal_release_buffer(handle, bitmap_bh);
> +			bit += sbi->s_dir_ireserve_nr;
> +			goto try_same_group;
> +		}
     So this above is just a while loop coded with goto... While loop
would be IMO better.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
