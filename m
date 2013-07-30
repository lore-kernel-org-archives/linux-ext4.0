From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH -v2] ext4: avoid reusing recently deleted inodes in no
 journal mode
Date: Tue, 30 Jul 2013 10:33:30 +0800
Message-ID: <20130730023330.GA663@gmail.com>
References: <1374809631-5258-1-git-send-email-tytso@mit.edu>
 <1374867164-21942-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38554 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3G3Cda (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 22:33:30 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so6142155pdi.16
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 19:33:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1374867164-21942-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 26, 2013 at 03:32:43PM -0400, Theodore Ts'o wrote:
> In no journal mode, if an inode has recently been deleted, we
> shouldn't reuse it right away.  Otherwise it's possible, after an
> unclean shutdown, to hit a situation where a recently deleted inode
> gets reused for some other purpose before the inode table block has
> been written to disk.  However, if the directory entry has been
> updated, then the directory entry will be pointing at the old inode
> contents.
> 
> E2fsck will make sure the file system is consistent after the
> unclean shutdown.  However, if the recently deleted inode is a
> character mode device, or an inode with the immutable bit set, even
> after the file system has been fixed up by e2fsck, it can be
> possible for a *.pyc file to be pointing at a character mode
> device, and when python tries to open the *.pyc file, Hilarity
> Ensues.  We could change all of userspace to be very suspicious
> about stat'ing files before opening them, and clearing the
> immutable flag if necessary --- or we can just avoid reusing an
> inode number if it has been recently deleted.
> 
> Google-Bug-Id: 10017573
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ialloc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 5b8e22e..7d5ac66 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -625,6 +625,51 @@ static int find_group_other(struct super_block *sb, struct inode *parent,
>  }
>  
>  /*
> + * In no journal mode, if an inode has recently been deleted, we want
> + * to avoid reusing it until we're reasonably sure the inode table
> + * block has been written back to disk.
> + */
> +int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
> +{
> +	struct ext4_group_desc	*gdp;
> +	struct ext4_inode	*raw_inode;
> +	struct buffer_head	*bh;
> +	unsigned long		dtime, now;
> +	int	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
> +	int	offset, ret = 0, recentcy = 30;
> +
> +	gdp = ext4_get_group_desc(sb, group, NULL);
> +	if (unlikely(!gdp))
> +		return 0;
> +
> +	bh = sb_getblk(sb, ext4_inode_table(sb, gdp) +
> +		       (ino / inodes_per_block));
> +	if (unlikely(!bh) || !buffer_uptodate(bh))
> +		/*
> +		 * If the block is not in the buffer head, then it
> +		 * must have been written out.
> +		 */
> +		goto out;
> +
> +	offset = (ino % inodes_per_block) * EXT4_INODE_SIZE(sb);
> +	raw_inode = (struct ext4_inode *) (bh->b_data + offset);
> +	dtime = le32_to_cpu(raw_inode->i_dtime);
> +	now = get_seconds();
> +	if (!buffer_dirty(bh))
> +		/*
> +		 * Five seconds should be enough time for a block to be
> +		 * committed to the platter once it is sent to the HDD
> +		 */
> +		recentcy = 5;
> +
> +	if (dtime && (dtime < now) && (now < dtime + recentcy))
> +		ret = 1;
> +out:
> +	brelse(bh);
> +	return ret;
> +}
> +
> +/*
>   * There are two policies for allocating an inode.  If the new inode is
>   * a directory, then a forward search is made for a block group with both
>   * free space and a low directory-to-inode ratio; if that fails, then of
> @@ -741,6 +786,11 @@ repeat_in_this_group:
>  				   "inode=%lu", ino + 1);
>  			continue;
>  		}
> +		if ((EXT4_SB(sb)->s_journal == NULL) &&
> +		    recently_deleted(sb, group, ino)) {
> +			ino++;
> +			goto next_inode;
                             ^^^^^^^^^^^
                             next_ino;

                                                - Zheng
> +		}
>  		if (!handle) {
>  			BUG_ON(nblocks <= 0);
>  			handle = __ext4_journal_start_sb(dir->i_sb, line_no,
> @@ -764,6 +814,7 @@ repeat_in_this_group:
>  		ino++;		/* the inode bitmap is zero-based */
>  		if (!ret2)
>  			goto got; /* we grabbed the inode! */
> +	next_ino:
>  		if (ino < EXT4_INODES_PER_GROUP(sb))
>  			goto repeat_in_this_group;
>  	next_group:
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
