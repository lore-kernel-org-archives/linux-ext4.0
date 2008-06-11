From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
	buffers
Date: Wed, 11 Jun 2008 14:35:57 +0200
Message-ID: <20080611123556.GA8121@duck.suse.cz>
References: <20080604111911.c1fe09c6.akpm@linux-foundation.org> <20080604212202.GA8727@mit.edu> <20080604145848.e3da6f20.akpm@linux-foundation.org> <20080604225155.GB8727@mit.edu> <20080605093536.GE27370@duck.suse.cz> <4847CF07.1020904@hitachi.com> <20080605142948.GA25477@mit.edu> <20080605092006.ba7dceef.akpm@linux-foundation.org> <20080605184941.GX2961@webber.adilger.int> <484D0155.4040701@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	sct@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46768 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbYFKMf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 08:35:59 -0400
Content-Disposition: inline
In-Reply-To: <484D0155.4040701@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-06-08 19:09:25, Hidehiro Kawai wrote:
> Andreas Dilger wrote:
> > On Jun 05, 2008  09:20 -0700, Andrew Morton wrote:
> 
> >>I guess we need to undo this.  And yes, propagating errors into AS_EIO
> >>is the way.  I guess that's safe without holding lock_page(), as long
> >>as the bh is pinned.
> > 
> > Something like the following instead if -EIO and journal abort:
> > 
> > 		if (!buffer_uptodate(bh)) {
> > 			set_bit(AS_EIO, &bh->b_page->mapping->flags);
> > 			SetPageError(bh->b_page);
> > 		}
> > 
> > It seems end_buffer_async_write() does this already, but
> > journal_do_submit_data() uses end_buffer_write_sync() and it does not
> > do either of those operations.
> 
> Thank you for your suggestion.  I wrote an additional patch to do
> that below.  Please apply it as the 6th patch of this patch series.
> 
> BTW, I'm developing a patch which makes "abort the journal if a file
> data buffer has an error" tunable.  I'll send it in another thread
> because it's not a bug fix patch.
> 
> -- 
> Hidehiro Kawai
> Hitachi, Systems Development Laboratory
> Linux Technology Center
> 
> 
> Subject: JBD: don't abort if flushing file data failed
> 
> In ordered mode, it is not appropriate behavior to abort the journal
> when we failed to write file data.  This patch calls printk()
> instead of aborting the journal.  Additionally, set AS_EIO into
> the address_space object of the buffer which is written out by
> journal_do_submit_data() and failed so that fsync() can get -EIO.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/jbd/commit.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc4/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/jbd/commit.c
> +++ linux-2.6.26-rc4/fs/jbd/commit.c
> @@ -432,8 +432,11 @@ void journal_commit_transaction(journal_
>  			wait_on_buffer(bh);
>  			spin_lock(&journal->j_list_lock);
>  		}
> -		if (unlikely(!buffer_uptodate(bh)))
> +		if (unlikely(!buffer_uptodate(bh))) {
> +			set_bit(AS_EIO, &bh->b_page->mapping->flags);
> +			SetPageError(bh->b_page);
>  			err = -EIO;
> +		}
  Actually, you should be more careful here because if the data buffer has
been truncated in the currently running transaction, it can happen that
b_page->mapping is NULL. It is a question how to safely access
page->mapping - probably you'll need page lock for that...

>  		if (!inverted_lock(journal, bh)) {
>  			put_bh(bh);
>  			spin_lock(&journal->j_list_lock);
> @@ -452,8 +455,11 @@ void journal_commit_transaction(journal_
>  	}
>  	spin_unlock(&journal->j_list_lock);
>  
> -	if (err)
> -		journal_abort(journal, err);
> +	if (err) {
> +		printk(KERN_WARNING
> +		       "JBD: Detected IO errors during flushing file data\n");
> +		err = 0;
> +	}
>  
>  	journal_write_revoke_records(journal, commit_transaction);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
