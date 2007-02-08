From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Thu, 8 Feb 2007 01:45:29 -0800
Message-ID: <20070208014529.d990b502.akpm@linux-foundation.org>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
	<20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
	<20070206173520.7719a7de.akpm@linux-foundation.org>
	<20070207204657.GC6565@schatzie.adilger.int>
	<20070207125659.bc27404d.akpm@linux-foundation.org>
	<20070208092945.GA10973@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, sho@tnes.nec.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070208092945.GA10973@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 8 Feb 2007 10:29:45 +0100 Jan Kara <jack@suse.cz> wrote:

> On Wed 07-02-07 12:56:59, Andrew Morton wrote:
> > On Wed, 7 Feb 2007 13:46:57 -0700
> > Andreas Dilger <adilger@clusterfs.com> wrote:
> > 
> > > On Feb 06, 2007  17:35 -0800, Andrew Morton wrote:
> > > > On Mon, 5 Feb 2007 14:12:04 +0100
> > > > Jan Kara <jack@suse.cz> wrote:
> > > > > > Move the blocks on the temporary inode to the original inode
> > > > > > by a page.
> > > > > > 1. Read the file data from the old blocks to the page
> > > > > > 2. Move the block on the temporary inode to the original inode
> > > > > > 3. Write the file data on the page into the new blocks
> > > > >   I have one thing - it's probably not good to use page cache for
> > > > > defragmentation.
> > > > 
> > > > Then it is no longer online defragmentation.  The issues with maintaining
> > > > correctness and coherency with ongoing VFS activity would be truly ghastly.
> > > > 
> > > > If we're worried about pagecache pollution then it would be better to control
> > > > that from userspace via fadvise().
> > > 
> > > It should be possible to have the online defrag tool lock the inode against
> > > any changes,
> > 
> > Sounds easy when you say it fast.  But how do we "lock" against, say, a
> > read pagefault?  Only by writing back then removing the pagecache page then
> > reinstantiating it as a locked, not-uptodate page and then removing it from
> > pagecache afterwards prior to unlocking it.  Or something.
> > 
> > I don't think we want to go there.
>   I though Andreas meant "any write changes" - i.e. you check that noone
> has open file descriptor for writing and block any new open for writing.
> That can be done quite easily.
>   Anyway, I agree with you that userspace solution to a possible page
> cache pollution is preferable after thinking about it for a while.
> As I've been thinking about it, we could actually do the copying
> from user space. We could do something like:
>   block any writes to file (as I described above)
>   craft new inode with blocks allocated as we want (using preallocation,
>     we should mostly have the kernel infrastructure we need)
>   copy data using splice syscall
>   call the kernel to switch data
> 

I don't think we need to block any writes to any file or anything.

To move a page within a file:

	fd = open(file);
	p = mmap(fd);
	the_page_was_in_core = mincore(p, offset);
	munmap(p);
	ioctl(fd, ..., new_block);

			<kernel>
			read_cache_page(inode, offset);
			lock_page(page);
			if (try_to_free_buffers(page)) {
				<relocate the page>
				set_page_dirty(page);
			}
			unlock_page(page);

	if (the_page_was_in_core) {
		sync_file_range(fd, offset SYNC_FILE_RANGE_WAIT_BEFORE|
						SYNC_FILE_RANGE_WRITE|
						SYNC_FILE_RANGE_WAIT_AFTER);
		fadvise(fd, offset, FADV_DONTNEED);
	}

completely coherent with pagecache, quite safe in the presence of mmap,
mlock, O_DIRECT, everything else.  Also fully journallable in-kernel.

