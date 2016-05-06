From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] direct-io: fix stale data exposure from concurrent
 buffered read
Date: Fri, 6 May 2016 18:46:22 +0800
Message-ID: <20160506104622.GB10350@eguan.usersys.redhat.com>
References: <1462033162-21837-1-git-send-email-guaneryu@gmail.com>
 <x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore T'so <tytso@google.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33214 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbcEFKqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 May 2016 06:46:32 -0400
Content-Disposition: inline
In-Reply-To: <x49twic5m6m.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 05, 2016 at 03:39:29PM -0400, Jeff Moyer wrote:
> Hi, Eryu,
> 
> Thanks for the great description of the problem!  I have some comments
> below.
> 
> Eryu Guan <guaneryu@gmail.com> writes:
> 
> > Direct writes inside i_size on a DIO_SKIP_HOLES filesystem are not
> > allowed to allocate blocks(get_more_blocks() sets 'create' to 0 before
> > calling get_bkicl() callback), if it's a sparse file, direct writes fall
> > back to buffered writes to avoid stale data exposure from concurrent
> > buffered read.
> >
> > But the detection for "writing inside i_size" is not correct, writes can
> > be treated as "extending writes" wrongly, which results in block
> > allocation for holes and could expose stale data. This is because we're
> > checking on the fs blocks not the actual offset and i_size in bytes.
> >
> > For example, direct write 1FSB to a 1FSB(or smaller) sparse file on
> > ext2/3/4, starting from offset 0, in this case it's writing inside
> > i_size, but 'create' is non-zero, because 'sdio->block_in_file' and
> > '(i_size_read(dio->inode) >> sdio->blkbits' are both zero.
> >
> > This can be demonstrated by running ltp-aiodio test ADSP045 many times.
> > When testing on extN filesystems, I see test failures occasionally,
> > buffered read could read non-zero (stale) data.
> >
> > ADSP045: dio_sparse -a 4k -w 4k -s 2k -n 2
> >
> > dio_sparse    0  TINFO  :  Dirtying free blocks
> > dio_sparse    0  TINFO  :  Starting I/O tests
> > non zero buffer at buf[0] => 0xffffffaa,ffffffaa,ffffffaa,ffffffaa
> > non-zero read at offset 0
> > dio_sparse    0  TINFO  :  Killing childrens(s)
> > dio_sparse    1  TFAIL  :  dio_sparse.c:191: 1 children(s) exited abnormally
> 
> OK, so in this case, block_in_file is 0, i_size_read(inode) is 2048, and
> i_blkbits is 12.
> 
> > Fix it by checking on the actual offset and i_size in bytes, not the fs
> > blocks where offset and i_size are in, to make sure it's really writing
> > into the file.
> 
> I think this code operates on blocks for a reason: we're trying to
> determine if we'll trigger block allocation, right?  For example,
> consider a sparse file with i_size of 2k, and a write to offset 2k into
> the file, with a file system block size of 4k.  Should that have create
> set or not?

Thanks for pointing this out! I think 'create' should be 0 in this case,
my test failed in this case, with both 4.6-rc6 stock kernel and my
patched kernel.

I'm testing an updated patch now, hopefully it's doing the right thing.
It's basiclly something like:

if (offset < i_size)
	create = 0;
else if ((block_in_file >> blkfactor) == (i_size >> (blkbits + blkfactor)) &&
	 (i_size & ((1 << (blkbits + blkfactor)) - 1)))
	create = 0;

So in addition to the (offset < i_size) check, it also checks that
block_in_file and i_size are falling into the same fs block && i_size is
not fs block size aligned.

> 
> Ted or Jan, can you answer that question?
> 
> > Also introduce some local variables to make the code
> > easier to read a little bit.
> 
> Please don't do this.  You're only making the change harder to review.
> Just submit the minimal fix.  You can submit cleanups as a follow-on.

I think it's not a pure cleanup, it's needed as things like
'sdio->block_in_file' are referenced multiple times in the function, and
they are making the lines too long to read/write. Maybe I should have
made it clear in the first place.

Thanks for the review!

Eryu
