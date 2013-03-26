From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/7] ext4: add mutex_is_locked() assertion to
 ext4_truncate()
Date: Tue, 26 Mar 2013 10:31:29 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303261021290.23176@localhost>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu> <1364170014-10295-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174Ab3CZJbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 05:31:34 -0400
In-Reply-To: <1364170014-10295-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 24 Mar 2013, Theodore Ts'o wrote:

> Date: Sun, 24 Mar 2013 20:06:53 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 6/7] ext4: add mutex_is_locked() assertion to ext4_truncate()
> 

Hi Ted,

I have to admit I do not necessarily understand the reason for this.
Have you seen any specific problem with mutex not being locked in
the truncation path ? I understand that it should be locked, but
there are lot of places where thing should be locked and we do not
usually check them, especially since we need special hook to "fool"
the check. Also there are not a lot of places we call truncate from.

I am not necessarily against the check, defensive programming is
proven to be very useful, but I would like to know why this one ?
Also, having mutex not locked in the truncation path is a bug so I
am not sure why we only do WARN_ON_ONCE() which can be easily missed
? Can we do WARN_ON(), or WARN_ON_ONCE() + ext4_warning() ?

Thanks!
-Lukas

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/inode.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ab20015..eb9a5a9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -258,8 +258,21 @@ void ext4_evict_inode(struct inode *inode)
>  			     "couldn't mark inode dirty (err %d)", err);
>  		goto stop_handle;
>  	}
> -	if (inode->i_blocks)
> +	if (inode->i_blocks) {
> +		/*
> +		 * Since we are evicting the inode, it shouldn't be
> +		 * locked.  We've added a warning which triggers if
> +		 * the mutex is not locked, so take the lock even
> +		 * though it's not strictly necessary.  However,
> +		 * taking the lock using a simple mutex_lock() will
> +		 * trigger a (false positive) lockdep warning, so take
> +		 * it using a trylock.
> +		 */
> +		int locked = mutex_trylock(&inode->i_mutex);
>  		ext4_truncate(inode);
> +		if (likely(locked))
> +			mutex_unlock(&inode->i_mutex);
> +	}
>  
>  	/*
>  	 * ext4_ext_truncate() doesn't reserve any slop when it
> @@ -3789,6 +3802,7 @@ void ext4_truncate(struct inode *inode)
>  	struct address_space *mapping = inode->i_mapping;
>  	loff_t page_len;
>  
> +	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
>  	trace_ext4_truncate_enter(inode);
>  
>  	if (!ext4_can_truncate(inode))
> 
