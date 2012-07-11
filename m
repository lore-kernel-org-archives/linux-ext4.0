From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv6 3/5] ext4: remove unnecessary superblock dirtying
Date: Wed, 11 Jul 2012 12:07:26 +0200
Message-ID: <20120711100726.GE1316@quack.suse.cz>
References: <1342000698-13556-1-git-send-email-dedekind1@gmail.com>
 <1342000698-13556-4-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1342000698-13556-4-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 11-07-12 12:58:16, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> This patch changes the '__ext4_handle_dirty_super()' function which submits
> the superblock for I/O in the following cases:
> 
> 1. When creating the first large file on a file system without
>    EXT4_FEATURE_RO_COMPAT_LARGE_FILE feature.
> 2. When re-sizing the file-system.
> 3. When creating an xattr on a file-system without the
>    EXT4_FEATURE_COMPAT_EXT_ATTR feature.
> 4. When adding or deleting an orphan which happens on every delete operation
>    (because we update the 's_last_orphan' superblock field).
> 
> If the file-system has journal enabled, the superblock is written via the
> journal. We do not modify this path.
> 
> If the file-system has no journal, this function, falls back to just marking
> the superblock as dirty using the 's_dirt' superblock flag. This means that it
> delays the actual superblock I/O submission by 5 seconds (default setting).
> Namely, the 'sync_supers()' kernel thread will call 'ext4_write_super()' later
> and will actually submit the superblock for I/O.
> 
> And this is the behavior this patch modifies: we stop using 's_dirt' and just
> mark the superblock buffer as dirty right away. Indeed:
> 
> 1. It does not add any value to delay the I/O submission for cases 1-3 above.
>    They are rare.
> 2. Case number 4 above depends on whether we have file-system checksumming
>    enabled or disables.
>    a) If it is disabled (most common scenario), then it is all-right to just
>       mark the superblock buffer as dirty right away and it should affect
>       performance.
>    b) If it is enabled, then we'll end up doing a bit more work on deletion
>       because we'll re-calculate superblock checksum every time.
> 
> So case 2.b is a bit controversial, but I think it is acceptable. After all, by
> enabling checksumming we already sign up for paying the price of calculating
> it. The way to improve checksumming performance globally would be to calculate
> it just before sending buffers to the I/O queue. We'd need some kind of
> call-back which could be registered by file-systems.
> 
> This patch also removes 's_dirt' condition on the unmount path because we never
> set it anymore, so we should not test it.
> 
> Tested using xfstests for both journalled and non-journalled ext4.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
  Looks good. Thanks for doing this work! You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/ext4_jbd2.c |    5 ++---
>  fs/ext4/super.c     |    2 +-
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 90f7c2e..c19ab6a 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -151,11 +151,10 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
>  		if (err)
>  			ext4_journal_abort_handle(where, line, __func__,
>  						  bh, handle, err);
> -	} else if (now) {
> +	} else {
>  		ext4_superblock_csum_set(sb,
>  				(struct ext4_super_block *)bh->b_data);
>  		mark_buffer_dirty(bh);
> -	} else
> -		sb->s_dirt = 1;
> +	}
>  	return err;
>  }
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index eb7aa3e..a391c53 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -896,7 +896,7 @@ static void ext4_put_super(struct super_block *sb)
>  		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  		es->s_state = cpu_to_le16(sbi->s_mount_state);
>  	}
> -	if (sb->s_dirt || !(sb->s_flags & MS_RDONLY))
> +	if (!(sb->s_flags & MS_RDONLY))
>  		ext4_commit_super(sb, 1);
>  
>  	if (sbi->s_proc) {
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
