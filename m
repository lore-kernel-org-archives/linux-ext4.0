From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 15:44:23 +0200
Message-ID: <20090420134423.GE14699@duck.suse.cz>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZDTNo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 09:44:26 -0400
Content-Disposition: inline
In-Reply-To: <1239910921.21233.98.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Chris,

On Thu 16-04-09 15:42:01, Chris Mason wrote:
> 
> ext3 data=ordered mode makes sure that data blocks are on disk before
> the metadata that references them, which avoids files full of garbage
> or previously deleted data after a crash.  It does this by adding every dirty
> buffer onto a list of things that must be written before a commit.
> 
> This makes every fsync write out all the dirty data on the entire FS, which
> has high latencies and is generally much more expensive than it needs to be.
> 
> Another way to avoid exposing stale data after a crash is to wait until
> after the data buffers are written before updating the on-disk record
> of the file's size.  If we crash before the data IO is done, i_size
> doesn't yet include the new blocks and no stale data is exposed.
> 
> This patch adds the delayed i_size update to ext3, along with a new
> mount option (data=guarded) to enable it.  The basic mechanism works like
> this:
> 
> * Change block_write_full_page to take an end_io handler as a parameter.
> This allows us to make an end_io handler that queues buffer heads for
> a workqueue where the real work of updating the on disk i_size is done.
> 
> * Add an rbtree to the in-memory ext3 inode for tracking data=guarded
> buffer heads that are waiting to be sent to disk.
> 
> * Add an ext3 guarded write_end call to add buffer heads for newly
> allocated blocks into the rbtree.  If we have a newly allocated block that is
> filling a hole inside i_size, this is done as an old style data=ordered write
> instead.
> 
> * Add an ext3 guarded writepage call that uses a special buffer head
> end_io handler for buffers that are marked as guarded.  Again, if we find
> newly allocated blocks filling holes, they are sent through data=ordered
> instead of data=guarded.
> 
> * When a guarded IO finishes, kick a per-FS workqueue to do the
> on disk i_size updates.  The workqueue function must be very careful.  We
> only update the on disk i_size if all of the IO between the old on
> disk i_size and the new on disk i_size is complete.  This is why an
> rbtree is used to track the pending buffers, that way we can verify all
> of the IO is actually done.  The on disk i_size is incrementally updated to
> the largest safe value every time an IO completes.
> 
> * When we start tracking guarded buffers on a given inode, we put the
> inode into ext3's orphan list.  This way if we do crash, the file will
> be truncated back down to the on disk i_size and we'll free any blocks that
> were not completely written.  The inode is removed from the orphan list
> only after all the guarded buffers are done.
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
  I've read the patch. I don't think I've got all the subtleties but before
diving into it more I'd like to ask why do we do the things in so
complicated way? Maybe I'm missing some issues so let's see:
  1) If I got it right, hole filling goes through standard ordered mode so
we can ignore such writes. So why do we have special writepage? I should
look just like writepage for ordered mode and we could just tweak
ext3_ordered_writepage() (probably renamed) to do:
	if (ext3_should_order_data(inode))
		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
                                        NULL, journal_dirty_data_fn);
	else
		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
                                        NULL, journal_dirty_guarded_data_fn);
  2) Why is there any RB tree after all? Since guarded are just extending
writes, we can have a linked list of guarded buffers. We always append
at the end, we update i_size if the current buffer has no predecestor in the
list.
  3) Currently truncate() does filemap_write_and_wait() - is it really
needed? Each guarded bh could carry with itself i_disksize it should update
to when IO is finished. Extending truncate will just update this i_disksize
at the last member of the list (or update i_disksize when the list is
empty). Shortening truncate will walk the list of guarded bh's, removing from
the list those beyond new i_size, then it will behave like the extending
truncate (it works even if current i_disksize is larger than new i_size).
Note, that before we get to ext3_truncate() mm walks all the pages beyond
i_size and waits for page writeback so by the time ext3_truncate() is
called, all the IO is finished and dirty pages are canceled.
  IO finished callback will update i_disksize to carried value if the
buffer is the first in the list, otherwise it will copy it's value to the
previous member of the list.
  4) Do we have to call end_page_writeback() from the work queue? That
could make IO completion times significantly longer on a good disk array,
couldn't it? There is a way how to solve this I believe although it might
be too hacky / complicated. We have to update i_disksize before calling
end_page_writeback() because of truncate races and generally for
filemap_fdatawrite() to work. So what we could do is:
  guarded_end_io():
    update i_disksize
    call something like __mark_inode_dirty(inode, I_DIRTY_DATASYNC) but
      avoid calling ext3_dirty_inode() or somehow make that we immediately
      return from it.
    call end_buffer_async_write()
    queue addition of inode to the transaction / removal from orphan list

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
