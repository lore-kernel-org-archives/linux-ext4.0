From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [heads-up][RFC] ext4_file_write() breakage
Date: Thu, 3 Apr 2014 22:55:59 -0400
Message-ID: <20140404025558.GB2525@thunk.org>
References: <20140403163739.GR18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140403163739.GR18016@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 03, 2014 at 05:37:39PM +0100, Al Viro wrote:
> 2) simply looking at file size in O_APPEND case instead of pos would not
> close that one - file size is unstable at that point (we don't have any
> locks held here).
> 
> 3) ext4_unaligned_aio() suffers the same problem, but that's *not* the
> only issue with it.

So basically, we'll have to take i_mutex in order to check the file
size, which means there's no point with the ext4_unaligned_aio()
logics.  We can just take the i_mutex and then do the tests based on
i_size in ext4_file_dio_write()

>  It checks that (O_DIRECT) aio write tries to hit
> something aligned only to hw sector and not to block size.  Fine, but...
> think what rlimit will do to us.  generic_write_checks() contains this:
> 
> 	unsigned long limit = rlimit(RLIMIT_FSIZE);
> 	....
> 		if (limit != RLIM_INFINITY) {
> 			if (*pos >= limit) {
> 				send_sig(SIGXFSZ, current, 0);
> 				return -EFBIG;
> 			}
> 			if (*count > limit - (typeof(limit))*pos) {
> 				*count = limit - (typeof(limit))*pos;
> 			}
> 		}
> 
> and it's done only after we'd called ext4_unaligned_aio().  

Can we solve these problem by simply doing these tests in
ext4_file_dio_write(), so we modify pos/couint before we do the
ext4_unaligned_aio() checks?  We don't need i_mutex to do these
particular tests, right?

> So it doesn't
> predict whether the iovec seen by ->direct_IO() will be unaligned - there
> are false negatives.  Even worse, consider an iovec that consists of
> 8 segments, 512 bytes each.  Starting offset in file is a multiple of block
> size.  Everything's fine from ext4_unaligned_aio() POV, right?  And from
> fs/direct-io.c one it's only sector-aligned sucker.  For a good reason,
> since a segment in the middle of that thing might very well point to unmapped
> memory, which will mean short write, with all zeroing issues ext4 is trying
> to avoid here.

I'm not sure I understand the concern here.  The zeroing issues we're
concerned about is when two threads need to work on the same unwritten
block.  So if the pos and size are block aligned, this can't heppen.
What am I missing?

					- Ted
