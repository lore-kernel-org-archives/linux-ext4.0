From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Mon, 15 Jun 2015 14:33:52 +0200
Message-ID: <20150615123352.GD4368@quack.suse.cz>
References: <20150615011433.GA15793@thunk.org>
 <1434331430-23125-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	enwlinux@gmail.com, jack@suse.cz, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434331430-23125-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 14-06-15 21:23:50, Ted Tso wrote:
> The commit cf108bca465d: "ext4: Invert the locking order of page_lock
> and transaction start" caused __ext4_journalled_writepage() to drop
> the page lock before the page was written back, as part of changing
> the locking order to jbd2_journal_start -> page_lock.  However, this
> introduced a potential race if there was a truncate racing with the
> data=journalled writeback mode.
> 
> Fix this by grabbing the page lock after starting the journal handle,
> and then checking to see if page had gotten truncated out from under
> us.
> 
> This fixes a number of different crashes or BUG_ON's when running
> xfstests generic/086 in data=journalled mode, including:
> 
> jbd2_journal_dirty_metadata: vdc-8: bad jh for block 84434: transaction (ec90434
> ransaction (  (null), 0), jh->b_next_transaction (  (null), 0), jlist 0
> 
> 	      	      	  - and -
> 
> kernel BUG at /usr/projects/linux/ext4/fs/jbd2/transaction.c:2200!
  Yeah, that's nasty. Thanks for debugging this! However I think your fix
reintroduces the original deadlock issues. do_journal_get_write_access()
can end up blocking waiting for jbd2 thread to finish a commit while jbd2
thread may be blocked waiting for the page to be unlocked.

After some thought I don't think the deadlock is real since
do_journal_get_write_access() will currently only block if a buffer is
under writeout to the journal and at that point we don't wait for page
locks anymore. Also ext4_write_begin() does the same in data=journal mode
and we haven't observed deadlocks so far. But still things look really
fragile here.

A clean fix for these problems would be to implement
ext4_journalled_writepages() which will start a transaction and then
writeback a bunch of pages. Similarly for write_begin() case we could start
the transaction in ext4_write() (and loop there since a single write may
need to be split among several transactions). However this is relatively
extensive work given how rarely the code is used...

So for now, feel free to add:
Acked-by: Jan Kara <jack@suse.cz>

to the patch.

								Honza

> ---
>  fs/ext4/inode.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0554b0b..263a46c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1701,19 +1701,32 @@ static int __ext4_journalled_writepage(struct page *page,
>  		ext4_walk_page_buffers(handle, page_bufs, 0, len,
>  				       NULL, bget_one);
>  	}
> -	/* As soon as we unlock the page, it can go away, but we have
> -	 * references to buffers so we are safe */
> +	/*
> +	 * We need to release the page lock before we start the
> +	 * journal, so grab a reference so the page won't disappear
> +	 * out from under us.
> +	 */
> +	get_page(page);
>  	unlock_page(page);
>  
>  	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
>  				    ext4_writepage_trans_blocks(inode));
>  	if (IS_ERR(handle)) {
>  		ret = PTR_ERR(handle);
> -		goto out;
> +		put_page(page);
> +		goto out_no_pagelock;
>  	}
> -
>  	BUG_ON(!ext4_handle_valid(handle));
>  
> +	lock_page(page);
> +	put_page(page);
> +	if (page->mapping != mapping) {
> +		/* The page got truncated from under us */
> +		ext4_journal_stop(handle);
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	if (inline_data) {
>  		BUFFER_TRACE(inode_bh, "get write access");
>  		ret = ext4_journal_get_write_access(handle, inode_bh);
> @@ -1739,6 +1752,8 @@ static int __ext4_journalled_writepage(struct page *page,
>  				       NULL, bput_one);
>  	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
>  out:
> +	unlock_page(page);
> +out_no_pagelock:
>  	brelse(inode_bh);
>  	return ret;
>  }
> -- 
> 2.3.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
