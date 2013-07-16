From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: block direct I/O writes during ext4_truncate
Date: Tue, 16 Jul 2013 17:46:58 +0200
Message-ID: <20130716154658.GE25632@quack.suse.cz>
References: <1373861479-15136-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373861479-15136-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 15-07-13 00:11:19, Ted Tso wrote:
> Just as in ext4_punch_hole() it is important that we block DIO writes
> while the truncate is proceeding, since during the overwriting DIO
> write, we drop i_mutex, which means a truncate could start while the
> Direct I/O operation is still in progress.
  Do you have an actual test case? Because what you describe shouldn't be
possible even now.

Unlock DIO overwrite does (under i_mutex):
       if (rw == WRITE)
                atomic_inc(&inode->i_dio_count);

        /* If we do a overwrite dio, i_mutex locking can be released */
        overwrite = *((int *)iocb->private);

        if (overwrite) {
                down_read(&EXT4_I(inode)->i_data_sem);
                mutex_unlock(&inode->i_mutex);
        }


and ext4_setattr() does (again under i_mutex):
                                        ext4_inode_block_unlocked_dio(inode);
                                        inode_dio_wait(inode);
                                        ext4_inode_resume_unlocked_dio(inode);

So either DIO gets i_mutex first and then ext4_setattr() waits for it to
complete, or truncate completes before unlocked DIO is able to get & drop
i_mutex.

OTOH unlocked DIO *read* might be vulnerable to a race with truncate. That
never acquires i_mutex so if the DIO read arrives after ext4_setattr() goes
through inode_dio_wait(), we can have the read and truncate racing and read
possibly submitting read of a just truncated block (which can get
reallocated in theory while the IO is running).

So something like what you do in the patch is likely needed, just the
justification is somewhat different and you should also rip out / adjust
the other synchronizations we have in ext4_setattr(), ext4_ext_direct_IO()
and ext4_ind_direct_IO().

								Honza

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 98b9bff..3c5edf2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3659,12 +3659,16 @@ void ext4_truncate(struct inode *inode)
>  	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
>  		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
>  
> +	/* Wait all existing dio workers, newcomers will block on i_mutex */
> +	ext4_inode_block_unlocked_dio(inode);
> +	inode_dio_wait(inode);
> +
>  	if (ext4_has_inline_data(inode)) {
>  		int has_inline = 1;
>  
>  		ext4_inline_data_truncate(inode, &has_inline);
>  		if (has_inline)
> -			return;
> +			goto out_resume;
>  	}
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> @@ -3675,7 +3679,7 @@ void ext4_truncate(struct inode *inode)
>  	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
>  	if (IS_ERR(handle)) {
>  		ext4_std_error(inode->i_sb, PTR_ERR(handle));
> -		return;
> +		goto out_resume;
>  	}
>  
>  	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
> @@ -3722,6 +3726,8 @@ out_stop:
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
>  
> +out_resume:
> +	ext4_inode_resume_unlocked_dio(inode);
>  	trace_ext4_truncate_exit(inode);
>  }
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
