From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v1] ext4:Allow an active handle to be started when freezing.
Date: Mon, 4 Apr 2011 22:31:40 -1000
Message-ID: <C844B01E-FFBA-4D92-8587-1FE81B630863@dilger.ca>
References: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39002 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1DEIbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 04:31:42 -0400
In-Reply-To: <BANLkTikqLrAyVaULk5UQsM7TzGk73ihsKg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-04, at 9:47 PM, Yongqiang Yang wrote:
> handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
> {
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
> 	}
> +
> +	if (!handle)
> +		vfs_check_frozen(sb, SB_FREEZE_TRANS);

This is probably easier to read by putting the !handle check/code together,
with a minor fixup to the comment as well:

	/*
	 * If a handle has already been started, it should be allowed to
	 * finish, otherwise deadlock could happen between freeze and
	 * truncate due to the restart of the journal handle if the
	 * filesystem is frozen and active handles are not stopped.
	 */
	if (!handle) {
		vfs_check_frozen(sb, SB_FREEZE_TRANS);
		if (!journal)
			return ext4_get_nojournal();
	}

	/*
	 * Special case here: if the journal has aborted behind our
	 * backs (eg. EIO in the commit thread), then we still need to
	 * take the FS itself readonly cleanly.
	 */
	if (is_journal_aborted(journal)) {
		ext4_abort(sb, "Detected aborted journal");
		return ERR_PTR(-EROFS);
	}
	return jbd2_journal_start(journal, nblocks);
}

> /*
> @@ -4131,6 +4149,11 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
> /*
> * LVM calls this function before a (read-only) snapshot is created.  This
> * gives us a chance to flush the journal completely and mark the fs clean.
> + *
> + * Note that only this function cannot bring a filesystem to be in a clean
> + * state independently, because ext4 prevents a new handle from being started
> + * by @sb->s_frozen, which stays in an upper layer.  It thus needs help from
> + * the upper layer.
> */
> static int ext4_freeze(struct super_block *sb)
> {
> -- 
> 1.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





