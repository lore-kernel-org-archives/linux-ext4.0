From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Tue, 16 Nov 2010 12:32:52 -0800
Message-ID: <20101116123252.4cc66f13.akpm@linux-foundation.org>
References: <20101116110058.GA4298@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab0KPUdY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 15:33:24 -0500
In-Reply-To: <20101116110058.GA4298@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 16 Nov 2010 22:00:58 +1100
Nick Piggin <npiggin@kernel.dk> wrote:

> I saw a lock order warning on ext4 trigger. This should solve it.

Send us the trace, please.

The code comment implies that someone is calling down_read() under
i_lock?  That would be bad, and I'd expect it to have produced a
might_sleep() warning, not a lockdep trace.  

And I don't see how we can call writeback_inodes_sb() under i_lock
anyway, so I don't really have a clue what's going on here!

> Raciness shouldn't matter much, because writeback can stop just
> after we make the test and return anyway (so the API is racy anyway).
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-11-16 21:44:32.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c	2010-11-16 21:49:37.000000000 +1100
> @@ -1125,16 +1125,20 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * May be called inside i_lock. May not start writeback if locks cannot
> + * be acquired.
>   */
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
> -		down_read(&sb->s_umount);
> -		writeback_inodes_sb(sb);
> -		up_read(&sb->s_umount);
> -		return 1;
> -	} else
> -		return 0;
> +		if (down_read_trylock(&sb->s_umount)) {
> +			writeback_inodes_sb(sb);
> +			up_read(&sb->s_umount);
> +			return 1;
> +		}
> +	}
> +	return 0;

And it's pretty generous to describe a s/down_read/down_read_trylock/
as a "fix".  Terms like "bandaid" and "workaround" come to mind.

