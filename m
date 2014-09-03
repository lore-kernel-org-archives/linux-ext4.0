From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd2: don't call get_bh() before calling
 __jbd2_journal_remove_checkpoint()
Date: Wed, 3 Sep 2014 18:08:37 +0200
Message-ID: <20140903160837.GC17066@quack.suse.cz>
References: <20140902215930.GJ6232@thunk.org>
 <1409698000-18126-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaICQIj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 12:08:39 -0400
Content-Disposition: inline
In-Reply-To: <1409698000-18126-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-09-14 18:46:39, Ted Tso wrote:
> The __jbd2_journal_remove_checkpoint() doesn't require an elevated
> b_count; indeed, until the jh structure gets released by the call to
> jbd2_journal_put_journal_head(), the bh's b_count is elevated by
> virtue of the existence of the jh structure.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
  Looks good so you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  Just we can do a bit more as I mentioned in my other email:

> @@ -359,8 +354,9 @@ restart2:
>  		 * know that it has been written out and so we can
>  		 * drop it from the list
>  		 */
> -		done = __jbd2_journal_remove_checkpoint(jh);
>  		__brelse(bh);
  Here we don't need to grab bh reference unless we are going to call
wait_on_buffer(). Which moves get_bh / __brelse out of fast path.

> +		if (__jbd2_journal_remove_checkpoint(jh))
> +			break;
>  	}
>  out:
>  	spin_unlock(&journal->j_list_lock);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
