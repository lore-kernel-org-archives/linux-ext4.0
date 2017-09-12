From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 2/5] ext4: prevent data corruption with journaling +
 DAX
Date: Tue, 12 Sep 2017 08:41:44 +0200
Message-ID: <20170912064144.GB16554@quack2.suse.cz>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
 <20170912050526.7627-3-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        linux-nvdimm@lists.01.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912050526.7627-3-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 11-09-17 23:05:23, Ross Zwisler wrote:
> The current code has the potential for data corruption when changing an
> inode's journaling mode, as that can result in a subsequent unsafe change
> in S_DAX.
> 
> I've captured an instance of this data corruption in the following fstest:
> 
> https://patchwork.kernel.org/patch/9948377/
> 
> Prevent this data corruption from happening by disallowing changes to the
> journaling mode if the '-o dax' mount option was used.  This means that for
> a given filesystem we could have a mix of inodes using either DAX or
> data journaling, but whatever state the inodes are in will be held for the
> duration of the mount.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Jan Kara <jack@suse.cz>

I guess this is fine for now to stop corrupting data so:

Reviewed-by: Jan Kara <jack@suse.cz>

But I think we should work on more user friendly (i.e., permissive)
version.

								Honza

> ---
>  fs/ext4/inode.c |  5 -----
>  fs/ext4/ioctl.c | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e963508..3207333 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5971,11 +5971,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
>  	}
>  	ext4_set_aops(inode);
> -	/*
> -	 * Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was updated.
> -	 * E.g. S_DAX may get cleared / set.
> -	 */
> -	ext4_set_inode_flags(inode);
>  
>  	jbd2_journal_unlock_updates(journal);
>  	percpu_up_write(&sbi->s_journal_flag_rwsem);
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index afb66d4..b0b754b 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -290,10 +290,20 @@ static int ext4_ioctl_setflags(struct inode *inode,
>  	if (err)
>  		goto flags_out;
>  
> -	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
> +	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
> +		/*
> +		 * Changes to the journaling mode can cause unsafe changes to
> +		 * S_DAX if we are using the DAX mount option.
> +		 */
> +		if (test_opt(inode->i_sb, DAX)) {
> +			err = -EBUSY;
> +			goto flags_out;
> +		}
> +
>  		err = ext4_change_inode_journal_flag(inode, jflag);
> -	if (err)
> -		goto flags_out;
> +		if (err)
> +			goto flags_out;
> +	}
>  	if (migrate) {
>  		if (flags & EXT4_EXTENTS_FL)
>  			err = ext4_ext_migrate(inode);
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
