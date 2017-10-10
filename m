From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] cgroup, writeback: replace SB_I_CGROUPWB with
 per-inode S_CGROUPWB
Date: Tue, 10 Oct 2017 10:56:21 +0200
Message-ID: <20171010085621.GE775@quack2.suse.cz>
References: <20171009212911.473208-1-tj@kernel.org>
 <20171009212911.473208-2-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009212911.473208-2-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-10-17 14:29:09, Tejun Heo wrote:
> Currently, filesystem can indiate cgroup writeback support per
> superblock; however, depending on the filesystem, especially if inodes
> are used to carry metadata, it can be useful to indicate cgroup
> writeback support per inode.
> 
> This patch replaces the superblock flag SB_I_CGROUPWB with per-inode
> S_CGROUPWB, so that cgroup writeback can be enabled selectively.
> 
> * block_dev sets the new flag in bdget() when initializing new inode.
> 
> * ext2/4 set the new flag in ext?_set_inode_flags() function.
> 
> * btrfs sets the new flag in btrfs_update_iflags() function.  Note
>   that this automatically excludes btree_inode which doesn't use
>   btrfs_update_iflags() during initialization.  This is an intended
>   behavior change.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org

...

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 31db875..344f12b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4591,8 +4591,11 @@ void ext4_set_inode_flags(struct inode *inode)
>  	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
>  	    !ext4_encrypted_inode(inode))
>  		new_fl |= S_DAX;
> +	if (test_opt(inode->i_sb, DATA_FLAGS) != EXT4_MOUNT_JOURNAL_DATA)
> +		new_fl |= S_CGROUPWB;

Use ext4_should_journal_data(inode) here? Ext4 can be journalling data also
because of per-inode flag.

Otherwise the patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
