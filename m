From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: fix race between truncate and
 __ext4_journalled_writepage()
Date: Mon, 15 Jun 2015 16:39:07 -0400
Message-ID: <20150615203907.GA2306@localhost.localdomain>
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

* Theodore Ts'o <tytso@mit.edu>:
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
>     ...
> Call Trace:
>  [<c02b2ded>] ? __ext4_journalled_invalidatepage+0x117/0x117
>  [<c02b2de5>] __ext4_journalled_invalidatepage+0x10f/0x117
>  [<c02b2ded>] ? __ext4_journalled_invalidatepage+0x117/0x117
>  [<c027d883>] ? lock_buffer+0x36/0x36
>  [<c02b2dfa>] ext4_journalled_invalidatepage+0xd/0x22
>  [<c0229139>] do_invalidatepage+0x22/0x26
>  [<c0229198>] truncate_inode_page+0x5b/0x85
>  [<c022934b>] truncate_inode_pages_range+0x156/0x38c
>  [<c0229592>] truncate_inode_pages+0x11/0x15
>  [<c022962d>] truncate_pagecache+0x55/0x71
>  [<c02b913b>] ext4_setattr+0x4a9/0x560
>  [<c01ca542>] ? current_kernel_time+0x10/0x44
>  [<c026c4d8>] notify_change+0x1c7/0x2be
>  [<c0256a00>] do_truncate+0x65/0x85
>  [<c0226f31>] ? file_ra_state_init+0x12/0x29
> 
> 	      	      	  - and -
> 
> WARNING: CPU: 1 PID: 1331 at /usr/projects/linux/ext4/fs/jbd2/transaction.c:1396
> irty_metadata+0x14a/0x1ae()
>     ...
> Call Trace:
>  [<c01b879f>] ? console_unlock+0x3a1/0x3ce
>  [<c082cbb4>] dump_stack+0x48/0x60
>  [<c0178b65>] warn_slowpath_common+0x89/0xa0
>  [<c02ef2cf>] ? jbd2_journal_dirty_metadata+0x14a/0x1ae
>  [<c0178bef>] warn_slowpath_null+0x14/0x18
>  [<c02ef2cf>] jbd2_journal_dirty_metadata+0x14a/0x1ae
>  [<c02d8615>] __ext4_handle_dirty_metadata+0xd4/0x19d
>  [<c02b2f44>] write_end_fn+0x40/0x53
>  [<c02b4a16>] ext4_walk_page_buffers+0x4e/0x6a
>  [<c02b59e7>] ext4_writepage+0x354/0x3b8
>  [<c02b2f04>] ? mpage_release_unused_pages+0xd4/0xd4
>  [<c02b1b21>] ? wait_on_buffer+0x2c/0x2c
>  [<c02b5a4b>] ? ext4_writepage+0x3b8/0x3b8
>  [<c02b5a5b>] __writepage+0x10/0x2e
>  [<c0225956>] write_cache_pages+0x22d/0x32c
>  [<c02b5a4b>] ? ext4_writepage+0x3b8/0x3b8
>  [<c02b6ee8>] ext4_writepages+0x102/0x607
>  [<c019adfe>] ? sched_clock_local+0x10/0x10e
>  [<c01a8a7c>] ? __lock_is_held+0x2e/0x44
>  [<c01a8ad5>] ? lock_is_held+0x43/0x51
>  [<c0226dff>] do_writepages+0x1c/0x29
>  [<c0276bed>] __writeback_single_inode+0xc3/0x545
>  [<c0277c07>] writeback_sb_inodes+0x21f/0x36d
>     ...
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
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

This patch looks promising.  I'm running a 1000 trial stress test on a
Pandaboard where I've generally been able to force a couple of manifestations
of this bug to appear within 5 to 10 runs.  Applied to 4.1-rc7, it's passed
135 trials cleanly.  The full series will complete sometime tomorrow.

I was also able to reproduce the problem on x86_64 pretty consistently in
four runs or less on 4.1-rc7;  I'm planning a stress test there as well once
-rc8 regression is complete.

Thanks!
Eric
