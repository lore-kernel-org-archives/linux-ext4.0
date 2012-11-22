From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 2/2] jbd: Stabilize pages during writes when in
 ordered mode
Date: Thu, 22 Nov 2012 10:19:31 +0100
Message-ID: <20121122091931.GB11154@quack.suse.cz>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
 <20121121211319.GA32202@blackbox.djwong.org>
 <20121121213333.GF30250@quack.suse.cz>
 <20121122084713.69e5b1fc@notabene.brown>
 <20121122014755.GH8740@blackbox.djwong.org>
 <20121122023645.GB32182@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>,
	axboe@kernel.dk, lucho@ionkov.net, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121122023645.GB32182@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 21-11-12 18:36:45, Darrick J. Wong wrote:
> When writing buffers out to disk ahead of committing a transaction, set the
> Stable bit on the page to prevent others from wandering in and modifying the
> page.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/jbd/commit.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 86b39b1..b1f0eed 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -155,13 +155,29 @@ static int journal_write_commit_record(journal_t *journal,
>  	return (ret == -EIO);
>  }
>  
> +static void end_stable_write_sync(struct buffer_head *bh, int uptodate)
> +{
> +	clear_page_stable(bh->b_page);
> +	end_buffer_write_sync(bh, uptodate);
> +}
  This doesn't work when blocksize < pagesize... There can be more buffers
in one page under IO so you can clear the stable bit only after the last of
them is done. See how PageWriteback bit is handled in
end_buffer_async_write().

> +
>  static void journal_do_submit_data(struct buffer_head **wbuf, int bufs,
>  				   int write_op)
>  {
>  	int i;
>  
>  	for (i = 0; i < bufs; i++) {
> -		wbuf[i]->b_end_io = end_buffer_write_sync;
> +		struct page *p = wbuf[i]->b_page;
> +		if (TestSetPageStable(p))
> +			wbuf[i]->b_end_io = end_buffer_write_sync;
> +		else
> +			wbuf[i]->b_end_io = end_stable_write_sync;
  Umm, why is this? It presume it is some attempt to handle blocksize <
page size?

> +
> +		if (trylock_page(p)) {
> +			clear_page_dirty_for_io(p);
> +			unlock_page(p);
> +		}
> +
  And this is wrong again for blocksize < pagesize. There can be other
dirty buffers under the page...

>  		/* We use-up our safety reference in submit_bh() */
>  		submit_bh(write_op, wbuf[i]);
>  	}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
