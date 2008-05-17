From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sat, 17 May 2008 09:43:44 -0400
Message-ID: <20080517134344.GA7411@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080516173552.e88183d9.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 16, 2008 at 05:35:52PM -0700, Andrew Morton wrote:
> Journal wrapping could cause the commit block to get written before its
> data blocks.  We could improve that by changing the journal layout a bit:
> wrap the entire commit rather than just its tail.  Such a change might
> be intrusive though.

Or we backport jbd2's checksum support in the commit block to jbd;
with the checksum support, if the commit block is written out-of-order
with the rest of the blocks in the commit, the commit will simply not
be recognized as valid, and we'll use the previous commit block as the
last valid commit.

So with ext4, the only problems we should actually have w/o a barrier
are:

	* Writes that were supposed to happen only *after* the journal
          commit is written get reordered *before* the journal commit.
          (But normally these writes, while _allowed_ after a journal
          commit are not forced by the kernel.)

	* In data=ordered mode, data blocks that *should* have been
          written out before the journal commit, get reordered until
          *after* the journal commit.

And in both cases, where the crash has to happen sometime *very*
shortly after commit record has been forced out.

Thinking about this some more, the most likely way I can think of some
problems happening would be an unexpected power failure that happened
exactly right as an unmount (or filesystem snapshot) was taking place.
That's one of the few cases I can think of where, a journal commit
write is followed immediately by the metadata writes.  And in
data=ordered more, that sequence would be data writes, followed
immediately by journal writes, followed immediately by metadata
writes.


So if you want to demonstrate that this really *could* happen in real
life, without an artificially contrived, horribly fragmented journal
inode, here's a worst case scenario I would try to arrange.

(1) Pre-fill the disk 100% with some string, such as "my secret love
letters".

(2) In data=ordered mode, unpack a very large tarball, ideally with
the files ad directory ordered maximally pessimized so that files are
created in directory #1, then directory #6, then directory #4, then
directory #1, then directory #2, etc.  (AKA the anti-Reiser4 benchmark
tarball, because Hans would do kernel unpack benchmarks using
specially prepared tarballs that were in an optimal order for a
particular reiser4 filesystem hash; this is the exact opposite.  :-)

(3) With lots of dirty files in the page cache, (and for extra fun,
try this with ext4's unstable patch queue with delayed allocation
enabled), unmount the filesystem ---- and crash the system in the
middle of the unmount.

(4) Check to see if the filesystem metadata checks out cleanly using
e2fsck -f.

(5) Check all of the files on the disk to see if any of them contain
the string, "my secret love letters".


So all of this is not to argue one way or another about whether or not
barriers are a good idea.  It's really so we (and system
administrators) can make some informed decisions about choices.


One thing which we *can* definitely do is add a flag in the superblock
to change the default mount option to enable barriers on a
per-filesystem basis, settable by tune2fs/mke2fs.


Another question is whether we can do better in our implementation of
a barrier, and the way the jbd layer uses barriers.  The way we do it
in the jbd layer is actually pretty bad:

	if (journal->j_flags & JFS_BARRIER) {
		set_buffer_ordered(bh);
		barrier_done = 1;
	}
	ret = sync_dirty_buffer(bh);
	if (barrier_done)
		clear_buffer_ordered(bh);

This means that while we are waiting for commit record to be written
out, any other writes that are happening via buffer heads (which
includes directory operations) are getting done with strict ordering.
All set_buffer_ordered() does is change make the submit_bh() done in
sync_dirty_buffer() actually be submitted with WRITE_BARRIER instead
of WRITE.  So fixing sync_dirty_buffer() so that there is an
_sync_dirty_buffer() which takes two arguments, so we can do something
like this instead:

	ret = _sync_dirty_buffer(bh, WRITE_BARRIER);

Should hopefully reduce the hit on the benchmarks.

On disks with real tagged command queuing it might be possible to do
even better by sending the hard drives the real data dependencies,
since in fact a barrier is a stronger guarantee than what we really
need.  Unfortunatelly, TCQ seems to be getting obsoleted by the dumber
NCQ, where we don't get to make explicit write ordering requests to
the drive (and my drives ignored the ordering requests anyway).

    	       	  	 	     	      - Ted
