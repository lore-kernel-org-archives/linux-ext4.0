From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct
 journal_head from type unsigned to tid_t
Date: Mon, 25 Jul 2011 17:31:15 +0200
Message-ID: <20110725153115.GD6107@quack.suse.cz>
References: <4E2D6961.9000909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1GYPbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 11:31:16 -0400
Content-Disposition: inline
In-Reply-To: <4E2D6961.9000909@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 25-07-11 21:02:25, Wang Sheng-Hui wrote:
> The patch is against 3.0
> 
> In the definition of struct journal_head, the comment for
> the field "unsigned b_cow_tid" says the field tracks the
> last transaction id in which this buffer has been cowed.
> 
> In the header part of file journal-head.h, it defines
>    typedef unsigned int  tid_t;
> We should use type tid_t to define transaction id fields.
> 
> Change the field "b_cow_tid" of struct journal_head from
> type unsigned to tid_t.
  Hmm, I didn't notice Ted merged this from ext4cow patch series. Looking
at struct journal_head, I'm thinking we might split jbd and jbd2 version of
this structure. jbd one could be 16 bytes shorter. Anyway, I've merged your
patch. Thanks.

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  include/linux/journal-head.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index 44e95d0..423cb6d 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -45,7 +45,7 @@ struct journal_head {
>  	 * has been cowed
>  	 * [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_cow_tid;
> +	tid_t b_cow_tid;
>  
>  	/*
>  	 * Copy of the buffer data frozen for writing to the log.
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
