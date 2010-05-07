From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RESEND] ext4: Show journal_checksum option
Date: Fri, 7 May 2010 18:09:55 +0200
Message-ID: <20100507160955.GC3265@atrey.karlin.mff.cuni.cz>
References: <1272881709-4973-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sheridan@shezza.org,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755083Ab0EGQJ4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 12:09:56 -0400
Content-Disposition: inline
In-Reply-To: <1272881709-4973-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> We failed to show journal_checksum option in /proc/mounts. Fix it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
  Ted, could you please pick this patch? Thanks.

								Honza

> ---
>  fs/ext4/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8f4f079..04fdaf1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -846,6 +846,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
>  	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
>  		seq_puts(seq, ",journal_async_commit");
> +	else if (test_opt(sb, JOURNAL_CHECKSUM))
> +		seq_puts(seq, ",journal_checksum");
>  	if (test_opt(sb, NOBH))
>  		seq_puts(seq, ",nobh");
>  	if (test_opt(sb, I_VERSION))
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
