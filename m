From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5 resend] VFS: Fix s_umount thaw/write deadlock
Date: Tue, 6 Dec 2011 06:35:44 -0500
Message-ID: <20111206113544.GA21589@infradead.org>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
 <1323118489-16326-4-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Kamal Mostafa <kamal@canonical.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1323118489-16326-4-git-send-email-kamal@canonical.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 05, 2011 at 12:54:47PM -0800, Kamal Mostafa wrote:
> +	/*
> +	 * Any file-system specific routines eventually called by
> +	 * drop_pagecache_sb() and drop_slab() ought to check for a
> +	 * frozen file system before writing to the disk.  Most file
> +	 * systems won't write in this case but XFS is a notable
> +	 * exception in certain cases.
> +	 */

Instead of adding a comment like this please fix whatever issue you
found or at least report it to the the people that might be able to
fix if you don't understand the code well enough.

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 73c3992..dbeaede 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -554,6 +554,14 @@ static long writeback_sb_inodes(struct super_block *sb,
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
>  
> +		if (inode->i_sb == sb && vfs_is_frozen(sb)) {
> +			/*
> +			 * Inode is on a frozen superblock; skip it for now.
> +			 */
> +			redirty_tail(inode, wb);
> +			continue;
> +		}
> +

We make sure to not dirty any new inodes after the first phase of the
freeze, so this should be a BUG_ON/WARN_ON.

> +		/*
> +		 * Trylock also avoids read-write deadlocks that could be
> +		 * triggered by freeze.
> +		 */
> +		if (down_read_trylock(&sb->s_umount)) {
> +			writeback_inodes_sb(sb, reason);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}

What exactly deadlock?  The comment as-is really doesn't tell the reader
anything interesting.  Note that switching it to a trylock really should
be a separate patch.  We've been through it a while ago and it got lost,
and now Miao Xie is looking into the general issue again.

Also as mentioned to Miao Xie a little elarier
writeback_inodes_if_idle should be rewritten to be a trivial wrapper
around writeback_inodes_sb_nr_if_idle instead of duplicating the logic.

While we're at it:  can anyway suggest a less cumbersome name than
writeback_inodes_sb_if_idle?  I'd go for
try_to_writeback_inodes_sb(_nr).

> index 35f4b0e..47983d9 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -47,7 +47,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
>  
>  static void quota_sync_one(struct super_block *sb, void *arg)
>  {
> -	if (sb->s_qcop && sb->s_qcop->quota_sync)
> +	if (sb->s_qcop && sb->s_qcop->quota_sync && !vfs_is_frozen(sb))
>  		sb->s_qcop->quota_sync(sb, *(int *)arg, 1);
>  }

Again, this should be a BUG_ON/WARN_ON.  We shouldn't redirty quotas
after the freeze.

> @@ -368,8 +368,18 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
>  		goto out;
>  	}
>  
> +	/*
> +	 * It's not clear which quota functions may write to the file
> +	 * system (all?).  Check for a frozen fs and bail out now.
> +	 */
> +	if (vfs_is_frozen(sb)) {
> +		ret = -EBUSY;
> +		goto out_drop_super;
> +	}

How about spending the three minutes to figure it out?
Q_GETFMT/Q_GETINFO/Q_XGETQSTAT and Q_GETQUOTA are the obvious read-only
candidates.

> + *	Note: If @f is going to write to the file system, it must first
> + *	check if the file system is frozen (via vfs_is_frozen(sb)) and
> + *	refuse to write if so.

That's an overgeneralization.

> + * During this function, sb->s_frozen goes through these values:
> + *
> + * SB_UNFROZEN: File system is normal, all writes progress as usual.
> + *
> + * SB_FREEZE_WRITE: The file system is in the process of being frozen
> + * and any remaining out-standing writes are being synced.  Writes
> + * that complete in-process writes should be permitted but new ones
> + * should be blocked.
> + *
> + * SB_FREEZE_TRANS: The file system is frozen.  The ->freeze_fs and
> + * ->unfreeze_fs ops are the only operations permitted to write to the
> + * file system in this state.
> + *
> + * sb->s_frozen is protected by sb->s_umount.  Additionally,
> + * SB_FREEZE_WRITE is only temporarily set during freeze/thaw while
> + * holding sb->s_umount for writing, so any other callers holding
> + * sb->s_umount will never see this state.
>   */

Please split adding this useful documentation into a separate patch.

> index 101b8ef..f497be8 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -68,7 +68,7 @@ int sync_filesystem(struct super_block *sb)
>  	/*
>  	 * No point in syncing out anything if the filesystem is read-only.
>  	 */
> -	if (sb->s_flags & MS_RDONLY)
> +	if ((sb->s_flags & MS_RDONLY) || vfs_is_frozen(sb))

Again, BUG_ON/WARN_ON.

>  static void sync_one_sb(struct super_block *sb, void *arg)
>  {
> -	if (!(sb->s_flags & MS_RDONLY))
> +	if (!(sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
>  		__sync_filesystem(sb, *(int *)arg);

Same here.

> +	if (!(sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
> +		ret = sync_filesystem(sb);

Same here.

> +static inline int vfs_is_frozen(struct super_block *sb) {
> +	return sb->s_frozen == SB_FREEZE_TRANS;
> +}

wrong brace placement.

