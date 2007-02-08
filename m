From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Thu, 8 Feb 2007 02:32:13 -0800
Message-ID: <20070208023213.902eed32.akpm@linux-foundation.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
	<20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
	<20070206173520.7719a7de.akpm@linux-foundation.org>
	<20070207204657.GC6565@schatzie.adilger.int>
	<20070207125659.bc27404d.akpm@linux-foundation.org>
	<20070208092945.GA10973@duck.suse.cz>
	<20070208014529.d990b502.akpm@linux-foundation.org>
	<20070208102102.GC10973@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, sho@tnes.nec.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423110AbXBHKcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Feb 2007 05:32:54 -0500
In-Reply-To: <20070208102102.GC10973@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 8 Feb 2007 11:21:02 +0100 Jan Kara <jack@suse.cz> wrote:

> On Thu 08-02-07 01:45:29, Andrew Morton wrote:
>  <snip>
> > >   I though Andreas meant "any write changes" - i.e. you check that noone
> > > has open file descriptor for writing and block any new open for writing.
> > > That can be done quite easily.
> > >   Anyway, I agree with you that userspace solution to a possible page
> > > cache pollution is preferable after thinking about it for a while.
> > > As I've been thinking about it, we could actually do the copying
> > > from user space. We could do something like:
> > >   block any writes to file (as I described above)
> > >   craft new inode with blocks allocated as we want (using preallocation,
> > >     we should mostly have the kernel infrastructure we need)
> > >   copy data using splice syscall
> > >   call the kernel to switch data
> > > 
> > 
> > I don't think we need to block any writes to any file or anything.
> > 
> > To move a page within a file:
> > 
> > 	fd = open(file);
> > 	p = mmap(fd);
> > 	the_page_was_in_core = mincore(p, offset);
> > 	munmap(p);
> > 	ioctl(fd, ..., new_block);
> > 
> > 			<kernel>
> > 			read_cache_page(inode, offset);
> > 			lock_page(page);
> > 			if (try_to_free_buffers(page)) {
> > 				<relocate the page>
> > 				set_page_dirty(page);
> > 			}
> > 			unlock_page(page);
> > 
> > 	if (the_page_was_in_core) {
> > 		sync_file_range(fd, offset SYNC_FILE_RANGE_WAIT_BEFORE|
> > 						SYNC_FILE_RANGE_WRITE|
> > 						SYNC_FILE_RANGE_WAIT_AFTER);
> > 		fadvise(fd, offset, FADV_DONTNEED);
> > 	}
> > 
> > completely coherent with pagecache, quite safe in the presence of mmap,
> > mlock, O_DIRECT, everything else.  Also fully journallable in-kernel.
>   Yes, this is the simple way. But I see two disadvantages:
> 1) You'd like to relocate metadata (indirect blocks) too.

Well.  Do we really?  Are we looking for a 100% solution here, or a 90% one?

Relocating data is the main thing.  After that, yeah, relocating metadata,
inodes and directories is probably a second-order thing.

> For that you need
>    a different mechanism.

I suspect a similar approach will work there: load and lock the
buffer_heads (or maybe just the top-level buffer_head) and then alter their
contents.  It could be that verify_chain() will just magically do the right
thing there, but some changes might be needed.

> In my approach, you can mostly assume you've got
>    sanely laid out metadata and so the existence of such mechanism is not
>    so important.
> 2) You'd like to allocate new blocks in big chunks. So your kernel function
>    should rather take a range. Also when you fail in the middle of
>    relocating a file (for example the block you'd like to use is already
>    taken by someone else), I find it nice if you can return at least to the
>    original state. But that's probably not important.

Well yes, that was a minimal sketch.
