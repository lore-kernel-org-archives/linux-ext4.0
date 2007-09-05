From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] System calls for online defrag
Date: Wed, 5 Sep 2007 16:24:38 +0200
Message-ID: <20070905142438.GB24462@duck.suse.cz>
References: <20070903180329.GK7524@duck.suse.cz> <20070904180153.GF5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>
To: linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51781 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756327AbXIEOFA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Sep 2007 10:05:00 -0400
Content-Disposition: inline
In-Reply-To: <20070904180153.GF5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 04-09-07 12:01:53, Andreas Dilger wrote:
> On Sep 03, 2007  20:03 +0200, Jan Kara wrote:
> >   I've finally got to writing up some proposal how could look system calls
> > allowing for online filesystem defragmentation and generally moving file
> > blocks around for improving performance. Comments are welcome.
> > 
> > int sys_movedata(int datafd, int spacefd, loff_t from, size_t len)
> >    The call takes blocks used to carry data starting at offset @from of length
> > @len in @spacefd and places them instead of corresponding blocks in @datafd.
> 
> Calling these "@spacefd" and "@datafd" is a bit confusing.  How about "@srcfd"
> and "@tgtfd" instead?  For defragmentation, are you planning to have @datafd
> be the "real" inode and "@spacefd" be the temporary inode with defragged data,
> or the reverse?  It isn't really clear.
  The idea behind the names was that you move data from @datafd into blocks
provided by @spacefd. Calling it @srcfd and @tgtfd has the problem whether
you mean source of data or source of blocks...

> > Data is copied from @datafd to newly spliced data blocks. If @spacefd contains
> > a hole in the specified interval, a hole is created also in @datafd in the
> > corresponding place. A data block from @spacefd and also replace a hole in
> > @datafd - zeros are copied to such data block. @from and @len should be
> > multiples of filesystem block size (otherwise EINVAL is returned). Data blocks
> > from @datafd in the interval are released, a hole is created in @spacefd.
> 
> This is mostly clear except the last sentence.  I would think that the data
> blocks in @datafd are kept, getting a copy of the data, while those in
> @spacefd are released?
  Original blocks from @datafd are replaced by the blocks from @spacefd. So
I guess you've understood the purpose of the fd's the other way around :).

> >   Another possibility would be to just replace data blocks without any copying
> > of data (that would have to be done by the caller to before calling
> > sys_movedata()). The problem here is how to avoid data loss if someone writes
> > to the file after userspace has copied the data and before sys_movedata() is
> > called.
> Isn't that true in any case?
  No, I don't think so. The call should be completely safe. The idea is that
we lock the i_mutex before we start swapping data blocks and unlock it after
everything is done. Maybe we could even just change the mapping information
inside the buffer heads?

> > ssize_t sys_allocate(int fd, int mode, loff_t goal, ssize_t len)
> >   Allocate new space to file @fd at offset defined by file position.  Both file
> > offset and @len should be a multiple of filesystem block size. The whole
> > interval must not contain any allocated blocks. If the interval extends past
> > EOF, the file size is changed accordingly.  @mode defines a way the filesystem
> > will search for blocks. @mode is a bitwise OR of the following flags:
> >   ALLOC_FIXED_START - allocation must start at @goal; if not specified, @goal
> > is just a hint where to start an allocation
> >   ALLOC_FIXED_LEN - allocate exactly space for @len; if not specified, upto
> > @len bytes may be allocated.
> >   ALLOC_CONTINGUOUS - allocation must be one continguous run of blocks
> 
> How is this much different than sys_fallocate()?
  It's not much different. The point is we'd like to have a better control
of where and how the data is really allocated (for example to be able to
create a non-linear file layout). And that is impossible with fallocate
interface AFAIK...

> > int sys_get_free_blocks(const char *fs, loff_t start, loff_t end, int count,
> >   struct alloc_extent *space)
> 
> One alternate possibility is to call the proposed FIEMAP on the block device,
> to return lists of free/used extents?  We have a version of that patch for
> ext4 and integration into filefrag, so it would be nice to avoid making up
> yet another API/tool if that one is sufficient.
  Yes, that would be sufficient and looks like a good plan :). BTW: shouldn't
we make it a syscall rather than ioctl? IMHO it would look much cleaner.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
