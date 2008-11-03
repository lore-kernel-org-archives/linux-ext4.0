From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 11:33:18 -0800
Message-ID: <20081103113318.35b0c266.akpm@linux-foundation.org>
References: <4908C951.2000309@redhat.com>
	<20081103184426.GA31894@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org, sct@redhat.com,
	linux-kernel@vger.kernel.org
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbYKCTeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 14:34:09 -0500
In-Reply-To: <20081103184426.GA31894@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Nov 2008 10:44:26 -0800
Arthur Jones <ajones@riverbed.com> wrote:

> Hi Eric,   This patch fixes the problem for me, and
> seems to put the buffers on the dirty list at the
> place where they are put on the list during the working
> case.  Despite having rooted around in the innards of
> ext3 for the last few days, I cannot say that I have
> any sense of whether this patch will cause problems
> elsewhere or even if this is the best place to
> intercede.
> 
> I post the complete patch not because I think it
> should be committed as is, but rather to try
> to explain the logic that brought it about.  At the
> very least, this should be reviewed by the experts
> here to make sure there is no collateral damage.
> 
> Arthur
> 
> -------------------
> In ext3_sync_fs, we only wait for a commit to
> finish if we started it, but there may be one
> already in progress which will not be synced.

argh.

> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2392,7 +2392,13 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
>  	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
>  		if (wait)
>  			log_wait_commit(EXT3_SB(sb)->s_journal, target);
> -	}
> +	} else if (wait)
> +		/*
> +		 * We may have a commit in progress, clear it out
> +		 * before we go on...
> +		 */
> +		ext3_force_commit(sb);
> +
>  	return 0;
>  }

Can we do

	sb->s_dirt = 0;
	if (wait)
		ext3_force_commit(...);
	else
		journal_start_commit(...);

?


Also, I wonder if that `sb->s_dirt = 0' is correct if
journal_start_commit() didn't start a commit?

