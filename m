From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Fix data corruption for racing writes
Date: Mon, 6 Apr 2009 12:23:29 +0200
Message-ID: <20090406102329.GD31189@duck.suse.cz>
References: <1238715399-22172-1-git-send-email-jack@suse.cz> <a4a7801d0904031738h68bf6218lfd3349ca50f46642@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ying Han <yinghan@google.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Ying Han <yinghan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35247 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZDFKXe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 06:23:34 -0400
Content-Disposition: inline
In-Reply-To: <a4a7801d0904031738h68bf6218lfd3349ca50f46642@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 03-04-09 17:38:33, Ying Han wrote:
> On Thu, Apr 2, 2009 at 4:36 PM, Jan Kara <jack@suse.cz> wrote:
> >
> > If two writers allocating blocks to file race with each other (e.g. because
> > writepages races with ordinary write or two writepages race with each other),
> > ext2_getblock() can be called on the same inode in parallel.  Before we are
> > going to allocate new blocks, we have to recheck the block chain we have
> > obtained so far without holding truncate_mutex. Otherwise we could overwrite
> > the indirect block pointer set by the other writer leading to data loss.
> >
> > The below test program by Ying is able to reproduce the data loss with ext2
> > on in BRD in a few minutes if the machine is under memory pressure:
> >
> > long kMemSize  = 50 << 20;
> > int kPageSize = 4096;
> >
> > int main(int argc, char **argv) {
> >        int status;
> >        int count = 0;
> >        int i;
> >        char *fname = "/mnt/test.mmap";
> >        char *mem;
> >        unlink(fname);
> >        int fd = open(fname, O_CREAT | O_EXCL | O_RDWR, 0600);
> >        status = ftruncate(fd, kMemSize);
> >        mem = mmap(0, kMemSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> >        // Fill the memory with 1s.
> >        memset(mem, 1, kMemSize);
> >        sleep(2);
> >        for (i = 0; i < kMemSize; i++) {
> >                int byte_good = mem[i] != 0;
> >                if (!byte_good && ((i % kPageSize) == 0)) {
> >                        //printf("%d ", i / kPageSize);
> >                        count++;
> >                }
> >        }
> >        munmap(mem, kMemSize);
> >        close(fd);
> >        unlink(fname);
> >
> >        if (count > 0) {
> >                printf("Running %d bad page\n", count);
> >                return 1;
> >        }
> >        return 0;
> > }
> >
> > CC: Ying Han <yinghan@google.com>
> > CC: Nick Piggin <nickpiggin@yahoo.com.au>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext2/inode.c |   44 +++++++++++++++++++++++++++++++++-----------
> >  1 files changed, 33 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index b43b955..acf6788 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -590,9 +590,8 @@ static int ext2_get_blocks(struct inode *inode,
> >
> >        if (depth == 0)
> >                return (err);
> > -reread:
> > -       partial = ext2_get_branch(inode, depth, offsets, chain, &err);
> >
> > +       partial = ext2_get_branch(inode, depth, offsets, chain, &err);
> >        /* Simplest case - block found, no allocation needed */
> >        if (!partial) {
> >                first_block = le32_to_cpu(chain[depth - 1].key);
> > @@ -602,15 +601,16 @@ reread:
> >                while (count < maxblocks && count <= blocks_to_boundary) {
> >                        ext2_fsblk_t blk;
> >
> > -                       if (!verify_chain(chain, partial)) {
> > +                       if (!verify_chain(chain, chain + depth - 1)) {
> >                                /*
> >                                 * Indirect block might be removed by
> >                                 * truncate while we were reading it.
> >                                 * Handling of that case: forget what we've
> >                                 * got now, go to reread.
> >                                 */
> > +                               err = -EAGAIN;
> >                                count = 0;
> > -                               goto changed;
> > +                               break;
> >                        }
> >                        blk = le32_to_cpu(*(chain[depth-1].p + count));
> >                        if (blk == first_block + count)
> > @@ -618,7 +618,8 @@ reread:
> >                        else
> >                                break;
> >                }
> > -               goto got_it;
> > +               if (err != -EAGAIN)
> > +                       goto got_it;
> >        }
> >
> >        /* Next simple case - plain lookup or failed read of indirect block */
> > @@ -626,6 +627,33 @@ reread:
> >                goto cleanup;
> >
> >        mutex_lock(&ei->truncate_mutex);
> > +       /*
> > +        * If the indirect block is missing while we are reading
> > +        * the chain(ext3_get_branch() returns -EAGAIN err), or
> > +        * if the chain has been changed after we grab the semaphore,
> > +        * (either because another process truncated this branch, or
> > +        * another get_block allocated this branch) re-grab the chain to see if
> > +        * the request block has been allocated or not.
> > +        *
> > +        * Since we already block the truncate/other get_block
> > +        * at this point, we will have the current copy of the chain when we
> > +        * splice the branch into the tree.
> > +        */
> > +       if (err == -EAGAIN || !verify_chain(chain, partial)) {
> > +               while (partial > chain) {
> > +                       brelse(partial->bh);
> > +                       partial--;
> > +               }
> > +               partial = ext2_get_branch(inode, depth, offsets, chain, &err);
> > +               if (!partial) {
> > +                       count++;
> > +                       mutex_unlock(&ei->truncate_mutex);
> > +                       if (err)
> > +                               goto cleanup;
> > +                       clear_buffer_new(bh_result);
> > +                       goto got_it;
> > +               }
> > +       }
> >
> >        /*
> >         * Okay, we need to do block allocation.  Lazily initialize the block
> > @@ -683,12 +711,6 @@ cleanup:
> >                partial--;
> >        }
> >        return err;
> > -changed:
> > -       while (partial > chain) {
> > -               brelse(partial->bh);
> > -               partial--;
> > -       }
> > -       goto reread;
> >  }
> >
> >  int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
> 
> I tried this patch and seems i got deadlock on the truncate_mutex.
> Here is the message after enabling lockdep. I pasted the same message
> on the origianal thread.
> 
> kernel: 1 lock held by kswapd1/264:
> kernel: #0:  (&ei->truncate_mutex){--..}, at: [<ffffffff8031d529>]
> ext2_get_block+0x109/0x960
> kernel: INFO: task ftruncate_mmap:2950 blocked for more than 120 seconds.
> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message.
> kernel: ftruncate_mma D ffff81047e733a80     0  2950   2858
> kernel: ffff8101798516f8 0000000000000092 0000000000000000 0000000000000046
> kernel: ffff81047e0a1260 ffff81047f070000 ffff81047e0a15c0 0000000100130c66
> kernel: 00000000ffffffff ffffffff8025740d 0000000000000000 0000000000000000
> kernel: Call Trace:
> kernel: [<ffffffff8025740d>] mark_held_locks+0x3d/0x80
> kernel: [<ffffffff804d78bd>] mutex_lock_nested+0x14d/0x280
> kernel: [<ffffffff804d7855>] mutex_lock_nested+0xe5/0x280
> kernel: [<ffffffff8031d529>] ext2_get_block+0x109/0x960
> kernel: [<ffffffff802ca2e3>] create_empty_buffers+0x43/0xb0
> kernel: [<ffffffff802ca2e3>] create_empty_buffers+0x43/0xb0
> kernel: [<ffffffff802ca217>] alloc_page_buffers+0x97/0x120
> kernel: [<ffffffff802cbfb6>] __block_write_full_page+0x206/0x320
> kernel: [<ffffffff802cbe70>] __block_write_full_page+0xc0/0x320
> kernel: [<ffffffff8031d420>] ext2_get_block+0x0/0x960
> kernel: [<ffffffff8027c74e>] shrink_page_list+0x4fe/0x650
> kernel: [<ffffffff80257ee8>] __lock_acquire+0x3b8/0x1080
> kernel: [<ffffffff8027be18>] isolate_lru_pages+0x88/0x230
> kernel: [<ffffffff8027c9ea>] shrink_inactive_list+0x14a/0x3f0
> kernel: [<ffffffff8027cd43>] shrink_zone+0xb3/0x130
> kernel: [<ffffffff80249e90>] autoremove_wake_function+0x0/0x30
> kernel: [<ffffffff8027d1a8>] try_to_free_pages+0x268/0x3e0
> kernel: [<ffffffff8027bfc0>] isolate_pages_global+0x0/0x40
> kernel: [<ffffffff802774f7>] __alloc_pages_internal+0x1d7/0x4a0
> kernel: [<ffffffff80279b94>] __do_page_cache_readahead+0x124/0x270
> kernel: [<ffffffff8027314f>] filemap_fault+0x18f/0x400
> kernel: [<ffffffff80280925>] __do_fault+0x65/0x450
> kernel: [<ffffffff80257ee8>] __lock_acquire+0x3b8/0x1080
> kernel: [<ffffffff803475dd>] __down_read_trylock+0x1d/0x60
> kernel: [<ffffffff8028389a>] handle_mm_fault+0x18a/0x7a0
> kernel: [<ffffffff804dba1c>] do_page_fault+0x29c/0x930
> kernel: [<ffffffff804d8b46>] trace_hardirqs_on_thunk+0x35/0x3a
> kernel: [<ffffffff804d94dd>] error_exit+0x0/0xa9
> kernel:
> kernel: 2 locks held by ftruncate_mmap/2950:
> kernel: #0:  (&mm->mmap_sem){----}, at: [<ffffffff804db9af>]
> do_page_fault+0x22f/0x930
> kernel: #1:  (&ei->truncate_mutex){--..}, at: [<ffffffff8031d529>]
> ext2_get_block+0x109/0x960
  I don't think this is a deadlock (or is the machine hung?). The thread
was just waiting for a long time. I'd think that you'll occasionally get
exactly the same message even without my patch if you stress the machine
like you do.
 
> Besides than that, does this patch fix the problem while moving the
> mutex up to the beginning of ext_get_blocks() does too? Like the
> following one
  Yes, moving truncate_mutex also fixes the problem but it would then
synchronize readers of one file and we definitely don't want to do that.

> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 384fc0d..bef3ef7 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -586,11 +586,13 @@ static int ext2_get_blocks(struct inode *inode,
>  	int count = 0;
>  	ext2_fsblk_t first_block = 0;
> 
> +	mutex_lock(&ei->truncate_mutex);
>  	depth = ext2_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
> 
> -	if (depth == 0)
> +	if (depth == 0) {
> +		mutex_unlock(&ei->truncate_mutex);
>  		return (err);
> -reread:
> +	}
>  	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
> 
>  	/* Simplest case - block found, no allocation needed */
> @@ -602,16 +604,6 @@ reread:
>  		while (count < maxblocks && count <= blocks_to_boundary) {
>  			ext2_fsblk_t blk;
> 
> -			if (!verify_chain(chain, partial)) {
> -				/*
> -				 * Indirect block might be removed by
> -				 * truncate while we were reading it.
> -				 * Handling of that case: forget what we've
> -				 * got now, go to reread.
> -				 */
> -				count = 0;
> -				goto changed;
> -			}
>  			blk = le32_to_cpu(*(chain[depth-1].p + count));
>  			if (blk == first_block + count)
>  				count++;
> @@ -625,7 +617,6 @@ reread:
>  	if (!create || err == -EIO)
>  		goto cleanup;
> 
> -	mutex_lock(&ei->truncate_mutex);
> 
>  	/*
>  	 * Okay, we need to do block allocation.  Lazily initialize the block
> @@ -651,7 +642,6 @@ reread:
>  				offsets + (partial - chain), partial);
> 
>  	if (err) {
> -		mutex_unlock(&ei->truncate_mutex);
>  		goto cleanup;
>  	}
> 
> @@ -662,13 +652,11 @@ reread:
>  		err = ext2_clear_xip_target (inode,
>  			le32_to_cpu(chain[depth-1].key));
>  		if (err) {
> -			mutex_unlock(&ei->truncate_mutex);
>  			goto cleanup;
>  		}
>  	}
> 
>  	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
> -	mutex_unlock(&ei->truncate_mutex);
>  	set_buffer_new(bh_result);
>  got_it:
>  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> @@ -678,17 +666,12 @@ got_it:
>  	/* Clean up and exit */
>  	partial = chain + depth - 1;	/* the whole chain */
>  cleanup:
> +	mutex_unlock(&ei->truncate_mutex);
>  	while (partial > chain) {
>  		brelse(partial->bh);
>  		partial--;
>  	}
>  	return err;
> -changed:
> -	while (partial > chain) {
> -		brelse(partial->bh);
> -		partial--;
> -	}
> -	goto reread;
>  }
> 
>  int ext2_get_block(struct inode *inode, sector_t iblock, struct
> buffer_head *bh_result, int create)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
