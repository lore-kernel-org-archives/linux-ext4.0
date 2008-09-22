From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Enable asynchronous commits by default
Date: Sun, 21 Sep 2008 21:53:32 -0500
Message-ID: <48D708AC.9020608@redhat.com>
References: <E1KhDCt-0004GB-KI@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbYIVCxd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2008 22:53:33 -0400
In-Reply-To: <E1KhDCt-0004GB-KI@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index fb5766e..e6d5af7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -747,8 +747,15 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	 */
>  	seq_puts(seq, ",barrier=");
>  	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
> +	/* journal_async_commit enables journal_checksum internally */
>  	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
>  		seq_puts(seq, ",journal_async_commit");
> +	else {
> +		seq_puts(seq, ",journal_sync_commit");
> +		if (test_opt(sb, JOURNAL_CHECKSUM))
> +			seq_puts(seq, ",journal_checksum");
> +	}
> +

Technically, I guess if async_commit is the default, it doesn't need to
be shown.   But maybe since it's a new default it's fine at least for a
time.

Rest seems good.

Acked-by: Eric Sandeen <sandeen@redhat.com>

-Eric

>  	if (test_opt(sb, NOBH))
>  		seq_puts(seq, ",nobh");
>  	if (!test_opt(sb, EXTENTS))
> @@ -902,6 +909,7 @@ enum {
>  	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
>  	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
>  	Opt_journal_checksum, Opt_journal_async_commit,
> +	Opt_journal_sync_commit,
>  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
> @@ -944,6 +952,7 @@ static match_table_t tokens = {
>  	{Opt_journal_dev, "journal_dev=%u"},
>  	{Opt_journal_checksum, "journal_checksum"},
>  	{Opt_journal_async_commit, "journal_async_commit"},
> +	{Opt_journal_sync_commit, "journal_sync_commit"},
>  	{Opt_abort, "abort"},
>  	{Opt_data_journal, "data=journal"},
>  	{Opt_data_ordered, "data=ordered"},
> @@ -1145,7 +1154,9 @@ static int parse_options(char *options, struct super_block *sb,
>  			break;
>  		case Opt_journal_async_commit:
>  			set_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
> -			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
> +			break;
> +		case Opt_journal_sync_commit:
> +			clear_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
>  			break;
>  		case Opt_noload:
>  			set_opt(sbi->s_mount_opt, NOLOAD);
> @@ -2026,6 +2037,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 */
>  	set_opt(sbi->s_mount_opt, DELALLOC);
>  
> +	/*
> +	 * enable async commit by default
> +	 * Use -o sync_commit to turn it off
> +	 */
> +	set_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
>  
>  	if (!parse_options((char *) data, sb, &journal_inum, &journal_devnum,
>  			   NULL, 0))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

