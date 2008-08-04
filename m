From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd jbd2: fix dio write returning EIO when
 try_to_release_page fails
Date: Mon, 4 Aug 2008 14:50:47 -0700
Message-ID: <20080804145047.04794bf3.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 04 Aug 2008 20:10:33 +0900
Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Hi
> 
> Dio write returns EIO when try_to_release_page fails because bh is
> still referenced.
> The patch 
> "commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91
> Author: Mingming Cao <cmm@us.ibm.com>
> Date:   Fri Jul 25 01:46:22 2008 -0700
> 
>     jbd: fix race between free buffer and commit transaction
> " 
> was merged into 2.6.27-rc1, but I noticed that this patch is not enough
> to fix the race.
> I did fsstress test heavily to 2.6.27-rc1, and found that dio write still 
> sometimes got EIO through this test.
> The patch above fixed race between freeing buffer(dio) and committing 
> transaction(jbd) but I discovered that there is another race, 
> freeing buffer(dio) and ext3/4_ordered_writepage.
> : background_writeout()
>      ->write_cache_pages()
>        ->ext3_ordered_writepage()
>      	   walk_page_buffers() <- take a bh ref
>  	   block_write_full_page() <- unlock_page
> 		: <- end_page_writeback
>                 : <- race! (dio write->try_to_release_page fails)
>       	   walk_page_buffers() <-release a bh ref
> 
> ext3_ordered_writepage holds bh ref and does unlock_page remaining 
> taking a bh ref, so this causes the race and failure of 
> try_to_release_page.
> 
> Following patch fixes this race.

Please don't patch both filesystems in a single patch - they go into
the tree via different routes.

> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

"Signed-off-by: ", please.

> 
> diff -Nrup linux-2.6.27-rc1.org/fs/jbd/transaction.c linux-2.6.27-rc1/fs/jbd/transaction.c
> --- linux-2.6.27-rc1.org/fs/jbd/transaction.c	2008-07-29 19:28:47.000000000 +0900
> +++ linux-2.6.27-rc1/fs/jbd/transaction.c	2008-07-29 20:40:12.000000000 +0900
> @@ -1764,6 +1764,12 @@ int journal_try_to_free_buffers(journal_
>  	*/
>  	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
>  		journal_wait_for_transaction_sync_data(journal);
> +
> +		bh = head;
> +		do {
> +			while (atomic_read(&bh->b_count))
> +				schedule();
> +		} while ((bh = bh->b_this_page) != head);
>  		ret = try_to_free_buffers(page);
>  	}

The loop is problematic.  If the scheduler decides to keep running this
task then we have a busy loop.  If this task has realtime policy then
it might even lock up the kernel.

Perhaps we can use wait_on_page_writeback()?

