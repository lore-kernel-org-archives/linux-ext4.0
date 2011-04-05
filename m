From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1] ext4:Allow an active handle to be started when
 freezing.
Date: Wed, 6 Apr 2011 00:26:30 +0200
Message-ID: <20110405222630.GB8531@quack.suse.cz>
References: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab1DEW0e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 18:26:34 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 05-04-11 15:47:25, Yongqiang Yang wrote:
> v0->v1:
>   check s_frozen in nojournal case only if there is no an active handle.
>   get reference to an active handle by jbd2_journal_start().
> 
> ext4_journal_start_sb() should not prevent an active handle from being
> started due to s_frozen.  Otherwise, deadlock is easy to happen, below
> is a situation.
> 
> ================================================
>      freeze         |       truncate
> ================================================
>                     |  ext4_ext_truncate()
>     freeze_super()  |   starts a handle
>     sets s_frozen   |
>                     |  ext4_ext_truncate()
>                     |  holds i_data_sem
>   ext4_freeze()     |
>   waits for updates |
>                     |  ext4_free_blocks()
>                     |  calls dquot_free_block()
>                     |
>                     |  dquot_free_blocks()
>                     |  calls ext4_dirty_inode()
>                     |
>                     |  ext4_dirty_inode()
>                     |  trys to start an active
>                     |  handle
>                     |
>                     |  block due to s_frozen
> ================================================
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Reported-by: Amir Goldstein <amir73il@users.sf.net>
> Reviewed-by: Jan Kara <jack@suse.cz>
  The usual workflow is that you add 'Reviewed-by' tag to the patch only
after you send a version of a patch the person agrees to and explicitely
says you can add a tag - for example I write something like "You can add
Reviewed-by: Jan Kara <jack@suse.cz>"
when I agree to the tag being added.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ccfa686..53920bd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -242,27 +242,45 @@ static void ext4_put_nojournal(handle_t *handle)
>   * journal_end calls result in the superblock being marked dirty, so
>   * that sync() will call the filesystem's write_super callback if
>   * appropriate.
> + *
> + * To avoid j_barrier hold in userspace when a user calls freeze(),
> + * ext4 prevents a new handle from being started by s_frozen, which
> + * is in an upper layer.
>   */
>  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
>  {
>  	journal_t *journal;
> +	handle_t  *handle;
> 
>  	if (sb->s_flags & MS_RDONLY)
>  		return ERR_PTR(-EROFS);
> 
> -	vfs_check_frozen(sb, SB_FREEZE_TRANS);
> -	/* Special case here: if the journal has aborted behind our
> -	 * backs (eg. EIO in the commit thread), then we still need to
> -	 * take the FS itself readonly cleanly. */
>  	journal = EXT4_SB(sb)->s_journal;
> -	if (journal) {
> -		if (is_journal_aborted(journal)) {
> -			ext4_abort(sb, "Detected aborted journal");
> -			return ERR_PTR(-EROFS);
> -		}
> -		return jbd2_journal_start(journal, nblocks);
> +	handle = ext4_journal_current_handle();
> +
> +	/*
> +	 * Before vfs_check_frozen(), the current handle should be allowed
> +	 * to finish, otherwise deadlock would happen when the filesystem
> +	 * is freezed && active handles are not stopped.
> +	 */
> +	if (!journal) {
> +		if (!handle)
> +			vfs_check_frozen(sb, SB_FREEZE_TRANS);
> +		return ext4_get_nojournal();
>  	}
> -	return ext4_get_nojournal();
> +
> +	if (!handle)
> +		vfs_check_frozen(sb, SB_FREEZE_TRANS);
  This test is the same for 'nojournal' case so you can move it before the
!journal test. Otherwise the patch looks OK to me. So now you can add
Reviewed-by: Jan Kara <jack@suse.cz>
line :)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
