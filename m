From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Fri, 11 Sep 2009 14:08:27 -0400
Message-ID: <20090911180827.GC19707@mit.edu>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com> <20090909225429.GB24951@mit.edu> <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com> <20090910013540.GF24951@mit.edu> <20090910065401.GB8690@skywalker.linux.vnet.ibm.com> <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com> <20090910162435.GA5321@skywalker.linux.vnet.ibm.com> <20090910185826.GC23700@mit.edu> <20090911172125.GA10155@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55576 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZIKSI3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 14:08:29 -0400
Content-Disposition: inline
In-Reply-To: <20090911172125.GA10155@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2009 at 10:51:25PM +0530, Aneesh Kumar K.V wrote:
> 
> But the patch you posted is using bforget which is removing the
> buffer_head from the inode->mapping->private_list. What i am
> trying to figure out is where does the buffer_head getting added
> to the private_list. ?
> 

bforget() does three things; 1) it clears the buffer dirty flag, 2) it
drops the buffer from inode->mapping->private_list (if it is on such a
list), and 3) it drops the refcount (when it calls __brelse()).  (n.b.
brelse() doesn't actually "release" or "free" a buffer; the name is a
holdover from the days when buffer cache was a stand-alone entity,
instead of being implemented in the page cache.)

The bug that Curt and I was chasing was related to (1) not happening,
and the fix that I proposed to fix it is "ext4: Use bforget() in no
journal mode for ext4_journal_{forget,revoke}()".  This bug was caused
by the fact that brelse() never releases the bh which is part of the
problem.  Even if bh->b_count is zero, the page in the buffer cache is
still present, and the buffer head will still be marked dirty.  So if
you don't want a dirty buffer to be written out to disk (because its
inode has been deleted and the block might be reallocated for some
other purpose), it's not enough to brelse() it; you have to explicitly
call clear_buffer_dirty() or bforget().

Your question about where does the buffer_head is getting added to
private_list is reltaed to (2), and the answer (at least before my
proposed patch, "ext4: Assure that metadata blocks are written during
fsync in no journal mode" is 'nowhere'.  So that was an entirely
separate problem, albeit one that I'm not sure Curt cares about for
his workloads.  (Why take the performance hit of fsync() in your
applications if your recovery strategy in case of a crash is mke2fs
and copy from one of the other two redundant servers?)

Does that help clarify matters?  Basically, there are three separate
bugs related to no journal mode that are being addressed by patches in
the ext4 patch queue:

ext4: Make non-journal fsync work properly
      (Found and fixed by Frank; we need to explicitly write out the 
      inode structure to disk during an fsync since we can't depend 
      on the journal doing this for us in no-journal mode.  So this is 
      an issue of the inode itself not getting written out by
      ext4_write_inode, which is called by pdflush and fsync.  
      Since the inode table buffer is marked dirty, the inode will 
      *eventually* be written out, but on a much greater time scale.  
      This caused the increased fragility of ext4 in no-journal mode
      after a power failure.)

ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
      (Pointed out by Aneesh, fixed by Ted; this fix makes sure that
      fsync will write out an inode's extent tree and/or indirect blocks,
      which is kinda important.  :-)

ext4: Assure that metadata blocks are written during fsync in no journal mode
      (Found by Curt, with an initial fix that worked by forcing 
      the dirty buffer to be written to disk, and fixed in a better way 
      by Ted by using bforget.  The problem here relates to an inode that
      is being deleted, which is why there's no reason to write the 
      dirty block to disk; when we were about to deallocate the block ---
      the better fix is to drop the dirty bit by using bforget.)

Hopefully this quick Cliff Notes(tm) summary of the ext4 no-journal
patches in the ext4 patch queue is helpful.

Regards,

					- Ted
