From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: dir inode reservation V3
Date: Tue, 20 Nov 2007 17:44:43 +0100
Message-ID: <20071120164443.GE27252@duck.suse.cz>
References: <4739B0C0.3060907@suse.de> <20071120155826.GB31177@atrey.karlin.mff.cuni.cz> <47430DF1.8090808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54179 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756451AbXKTQop (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2007 11:44:45 -0500
Content-Disposition: inline
In-Reply-To: <47430DF1.8090808@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 21-11-07 00:40:17, Coly Li wrote:
> Jan Kara wrote:
> >> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> >> index 17b5df1..f838a72 100644
> >> --- a/fs/ext4/ialloc.c
> >> +++ b/fs/ext4/ialloc.c
> >> @@ -10,6 +10,8 @@
> >>   *  Stephen Tweedie (sct@redhat.com), 1993
> >>   *  Big-endian to little-endian byte-swapping/bitmaps by
> >>   *        David S. Miller (davem@caip.rutgers.edu), 1995
> >> + *  Directory inodes reservation by
> >> + *        Coly Li (coyli@suse.de), 2007
> >>   */
> >>
> >>  #include <linux/time.h>
> >> @@ -478,6 +480,75 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
> >>  	return -1;
> >>  }
> >>
> >> +static int ext4_ino_from_ireserve(handle_t *handle, struct inode *dir,
> >> +			  int mode, ext4_group_t *group, unsigned long *ino)
> >> +{
> >> +	struct super_block *sb;
> >> +	struct ext4_sb_info *sbi;
> >> +	struct ext4_group_desc *gdp = NULL;
> >> +	struct buffer_head *gdp_bh = NULL, *bitmap_bh = NULL;
> >> +	ext4_group_t ires_group = *group;
> >> +	unsigned long ires_ino;
> >> +	int i, bit;
> >> +
> >> +	sb = dir->i_sb;
> >> +	sbi = EXT4_SB(sb);
> >> +
> >> +	/* if the inode number is not for directory,
> >> +	 * only try to allocate after directory's inode
> >> +	 */
> >> +	if (!S_ISDIR(mode)) {
> >> +		*ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
> >> +		return 0;
> >> +	}
> >   ^^^ You don't set a group here - is this intentional? It means we get
> > the group from find_group_other() and there we start searching at a
> > place corresponding to parent's inode number... That would be an
> > interesting heuristic but I'm not sure if that's what you want.
> Yes, if allocating a file inode, just return first inode offset in the reserved area of parent
> directory. In this case, group is decided by find_group_other() or find_group_orlov(),
> ext4_ino_from_ireserve() just tries to persuade linear inode allocator to search free inode slot
> after parent's inode.
  But what I mean is: Parent directory is in group 1, with inode number 10, now
find_group_other will set group to 2 and you set inode number to 10 so
linear allocator will start searching in group 2, inode number 10 which is
*not* just after directory inode....

> >> +
> >> +	/* reserve inodes for new directory */
> >> +	for (i = 0; i < sbi->s_groups_count; i++) {
> >> +		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
> >> +		if (!gdp)
> >> +			goto fail;
> >> +		bit = 0;
> >> +try_same_group:
> >> +		if (bit < EXT4_INODES_PER_GROUP(sb)) {
> >> +			brelse(bitmap_bh);
> >> +			bitmap_bh = read_inode_bitmap(sb, ires_group);
> >> +			if (!bitmap_bh)
> >> +				goto fail;
> >> +
> >> +			BUFFER_TRACE(bitmap_bh, "get_write_access");
> >> +			if (ext4_journal_get_write_access(
> >> +				handle, bitmap_bh) != 0)
> >> +				goto fail;
> >> +			if (!ext4_set_bit_atomic(sb_bgl_lock(sbi, ires_group),
> >> +					bit, bitmap_bh->b_data)) {
> >> +				/* we won it */
> >> +				BUFFER_TRACE(bitmap_bh,
> >> +					"call ext4_journal_dirty_metadata");
> >> +				if (ext4_journal_dirty_metadata(handle,
> >> +							bitmap_bh) != 0)
> >> +					goto fail;
> >> +				ires_ino = bit;
> >> +				goto find;
> >> +			}
> >> +			/* we lost it */
> >> +			jbd2_journal_release_buffer(handle, bitmap_bh);
> >> +			bit += sbi->s_dir_ireserve_nr;
> >> +			goto try_same_group;
> >> +		}
> >      So this above is just a while loop coded with goto... While loop
> > would be IMO better.
> 
> The only reason for me to use a goto, is 80 column limitation :) BTW,
> goto does not hurt performance and readability here. IMHO, it's
> acceptable :-)
  But you could just remove goto try_same_group; and change 'if' to 'while'.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
