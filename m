From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [heads-up][RFC] ext4_file_write() breakage
Date: Thu, 3 Apr 2014 17:37:39 +0100
Message-ID: <20140403163739.GR18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

	There's a bunch of fun problems with ext4_file_write():

1) check for non-extent file trying to grow past the old size limit is
looking at position we say we'll be writing to.  generic_file_aio_write()
might have a different idea, though - just open with O_APPEND and watch
the sucker grow the file across the limit.

2) simply looking at file size in O_APPEND case instead of pos would not
close that one - file size is unstable at that point (we don't have any
locks held here).

3) ext4_unaligned_aio() suffers the same problem, but that's *not* the
only issue with it.  It checks that (O_DIRECT) aio write tries to hit
something aligned only to hw sector and not to block size.  Fine, but...
think what rlimit will do to us.  generic_write_checks() contains this:

	unsigned long limit = rlimit(RLIMIT_FSIZE);
	....
		if (limit != RLIM_INFINITY) {
			if (*pos >= limit) {
				send_sig(SIGXFSZ, current, 0);
				return -EFBIG;
			}
			if (*count > limit - (typeof(limit))*pos) {
				*count = limit - (typeof(limit))*pos;
			}
		}

and it's done only after we'd called ext4_unaligned_aio().  So it doesn't
predict whether the iovec seen by ->direct_IO() will be unaligned - there
are false negatives.  Even worse, consider an iovec that consists of
8 segments, 512 bytes each.  Starting offset in file is a multiple of block
size.  Everything's fine from ext4_unaligned_aio() POV, right?  And from
fs/direct-io.c one it's only sector-aligned sucker.  For a good reason,
since a segment in the middle of that thing might very well point to unmapped
memory, which will mean short write, with all zeroing issues ext4 is trying
to avoid here.

TBH, I'm seriously tempted to have ext4 ->direct_IO() to bail out on any
iovec that isn't block-aligned, and scratch the whole ext4_unaligned_aio()
logics.  It still leaves (1) and (2), but then we'll be able to lambda-expand
the call of generic_file_aio_write() and shift taking i_mutex up to the point
prior to checking for non-extent files trying to grow too much.

There might be kinder ways to deal with that mess, but I don't know the code
in ext4 dealing with unwritten extents anywhere near well enough to tell what's
feasible in that area.

Comments?
