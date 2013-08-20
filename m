From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
Date: Tue, 20 Aug 2013 12:36:15 +1000
Message-ID: <20130820023615.GE6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 16, 2013 at 04:22:10PM -0700, Andy Lutomirski wrote:
> Filesystems that defer cmtime updates should update cmtime when any
> of these events happen after a write via a mapping:
> 
>  - The mapping is written back to disk.  This happens from all kinds
>    of places, all of which eventually call ->writepages.
> 
>  - munmap is called or the mapping is removed when the process exits
> 
>  - msync(MS_ASYNC) is called.  Linux currently does nothing for
>    msync(MS_ASYNC), but POSIX says that cmtime should be updated some
>    time between an mmaped write and the subsequent msync call.
>    MS_SYNC calls ->writepages, but MS_ASYNC needs special handling.
> 
> Filesystmes that defer cmtime updates should flush them on munmap or
> exit.  Finding out that this happened through vm_ops is messy, so
> add a new address space op for this.
> 
> It's not strictly necessary to call ->flush_cmtime after ->writepages,
> but it simplifies the fs code.  As an optional optimization,
> filesystems can call mapping_test_clear_cmtime themselves in
> ->writepages (as long as they're careful to scan all the pages first
> -- the cmtime bit may not be set when ->writepages is entered).

.flush_cmtime is effectively a duplicate method.  We already have
.update_time to notify filesystems that they need to update the
timestamp in the inode transactionally.

Indeed:

> +	/*
> +	 * Userspace expects certain system calls to update cmtime if
> +	 * a file has been recently written using a shared vma.  In
> +	 * cases where cmtime may need to be updated but writepages is
> +	 * not called, this is called instead.  (Implementations
> +	 * should call mapping_test_clear_cmtime.)
> +	 */
> +	void (*flush_cmtime)(struct address_space *);

You say it can be implemented in the ->writepage(s) method, and all
filesystems provide ->writepage(s) in some form. Therefore I would
have thought it be best to simply require filesystems to check that
mapping flag during those methods and update the inode directly when
that is set?

Indeed, the way you've set up the infrastructure, we'll have to
rewrite the cmtime update code to enable writepages to update this
within some other transaction. Perhaps you should just implement it
that way first?

> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1928,6 +1928,18 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  		ret = mapping->a_ops->writepages(mapping, wbc);
>  	else
>  		ret = generic_writepages(mapping, wbc);
> +
> +	/*
> +	 * ->writepages will call clear_page_dirty_for_io, which may, in turn,
> +	 * mark the mapping for deferred cmtime update.  As an optimization,
> +	 * a filesystem can flush the update at the end of ->writepages
> +	 * (possibly avoiding a journal transaction, for example), but,
> +	 * for simplicity, let filesystems skip that part and just implement
> +	 * ->flush_cmtime.
> +	 */
> +	if (mapping->a_ops->flush_cmtime)
> +		mapping->a_ops->flush_cmtime(mapping);

And that's where you cannot call sb_pagefault_start/end....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
