From: Jan Kara <jack@suse.cz>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 15:18:09 +0200
Message-ID: <20130513131809.GG400@quack.suse.cz>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: EUNBONG SONG <eunb.song@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3EMNSN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 09:18:13 -0400
Content-Disposition: inline
In-Reply-To: <31302271.2821368363898561.JavaMail.weblogic@epml17>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 12-05-13 13:04:59, EUNBONG SONG wrote:
> 
> 
> >> Since at this point it's safer to rollback the change and we can
> >> investigate more deeply how to fix it correctly for the next
> >> development cycle, this is the patch which I'm testing.
> 
> >>                     - Ted
> 
> > Hello, I've tested with your patch. But the same problem was reproduced.
> > Currently, I'm trying to git bisect. If i done git bisect, i will let you know.
> 
> Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head() is caused by 
> ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head size."
> I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f06b99f66 because
> I don't know the root cause. 
  This is really strange. I've verified the code and all the places
modifying b_jlist or b_modified are holding bh_state lock so we should be
safe...

Hum, but I remember I was debugging similar problems with bit fields in
btrfs on ia64 as well (see http://lwn.net/Articles/478657/). So I think what
has happened is that your compiler compiled bitfield access as 64-bit and
updates to b_jcount and b_jlist / b_modified crashed into one another. I
didn't hit it because my compiler was not so "clever".

Grumble. In this case I think bitfields are not worth the trouble with gcc.
It's a pitty we have to spend additional 8 bytes for every journal_head but
we'll survive... I'll send Ted a partial revert and add a comment so that
we won't repeat this mistake in future.

								Honza
 
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  include/linux/journal-head.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index 13a3da2..c18b46f 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -31,14 +31,21 @@ struct journal_head {
>  	/*
>  	 * Journalling list for this buffer [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_jlist:4;
> +	unsigned b_jlist;
>  
>  	/*
>  	 * This flag signals the buffer has been modified by
>  	 * the currently running transaction
>  	 * [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_modified:1;
> +	unsigned b_modified;
> +
> +	/*
> +	 * This feild tracks the last transaction id in which this buffer
> +	 * has been cowed
> +	 * [jbd_lock_bh_state()]
> +	 */
> +	tid_t b_cow_tid;
>  
>  	/*
>  	 * Copy of the buffer data frozen for writing to the log.
> -- 
> 1.7.0.4
> 
> 
> Thanks. 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
