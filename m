From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4 mballoc: fix tail allocation
Date: Tue, 7 Apr 2015 22:44:39 -0400
Message-ID: <20150408024439.GA21171@thunk.org>
References: <1428348701-47574-1-git-send-email-jhe@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jun He <jhe@cs.wisc.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428348701-47574-1-git-send-email-jhe@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 06, 2015 at 01:31:41PM -0600, Jun He wrote:
> This patch addresses the tail allocation problem found at paper "Reducing File System Tail Latencies with Chopper". https://www.usenix.org/system/files/conference/fast15/fast15-paper-he.pdf . The paper refers the tail allocation problem as the Special End problem.

Hi Jun He,

Kernel patches should have the commit body line-wrapped at 72 columns
(more or less).  The idea is that the commit should be easily readable
on an 80 column screen, with some extra space left for identation (git
log will ident the commit body by 4 characters).

> A tail extent is the last extent of a file. The last block of the
> tail extent corresponds to the last logical block of the file. When
> a file is closed and the tail extent is being allocated, ext4 marks
> the allocation request with the hint EXT4_MB_HINT_NOPREALLOC. The
> intention is to avoid preallocation when we know the file is final
> (it won't change until the next open.). But the implementation leads
> to some problems. The following program attacks the problem.

I think you mean "the following program _demonstrates_ the problem".


> EXT4_MB_HINT_NOPREALLOC is not the right hint for special end. If we
> remove current check for tail in ext4_mb_group_or_file() , 1, 3, 4
> will be satisfied. Now, we only need to handle the tail of large
> file (2) by checking tail when normalizing. If it is a tail of large
> file, we simply do not normalize it.

The problem with skipping the normalization is this also by passes the
goal block optimizations based on pleft, pright, lleft, and lright.
In the case of a small file, it's not always true that you want to
allocate from a LG preallocation.  If there is free space immediately
adjacent to file, we want to use that in preference to the LG
preallocation --- since that would result in a contiguous file.

> +
> +	/* don't normalize tail of large files */
> +	if ((size == isize) &&
> +	    !ext4_fs_is_busy(sbi) &&
> +	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
> +		return;
> +	}

The comment is a bit misleading; it's not checking for large files at
all.  It also looks like that you copied the ext4_fs_is_busy(sbi) from
the original check.

Perhaps it would be helpful to explain the design goal of the original
code.  As originally conceived, the problem we were trying to fix was
that in the case of unpacking a tar file with a large number of small
files, we wanted to make sure all of the files would be packed
togehter, without extra space reserved (caused by the normalization).
This was achieved by disabing the use of the locality group.  The
problem is that if there are a large number of processes writing into
the same block group, this would cause contention, and so in the case
where we had contention, we would use the locality group (since the
whole point was to eliminate the need to constantly take the block
group lock while allocaitng out of the block group; that's why the
locality groups are per-cpu).  That's what the ext4_fs_is_busy() is
all about.  We try to measure contention and disable the optimization
if that was the case.

I suspect we may want to take a step back and what's the best way of
handling all of the high level goals, and refomulate a better strategy:

1) If the file doesn't have any blocks allocated yet, and it is closed
by the time we need to allocate all of its blocks (thanks to delayed
allocation), we should allocate exactly the number of blocks needed,
and try to avoid fragmenting free space.

2) In the case where we are doing any tails at all, it's a different
optimization altogether, and the main goal should be to make sure the
tail is connected the previous blocks if at all possible.  To the
extent that we have per-CPU LG groups, this can be... problematic.

3) The primary goal of the per-group locality group is to avoid lock
contention when multiple CPU's are trying to access the blocks at the
same time.  Depending on why we are doing block allocation, this may
not be an issue.  We should probably into account why it is we re
doing block allocation at particular moment:

   *) In the case of delayed allocation w/o fsync(2), the writeback
      will be taking place from the writeback daemon.  In that case,
      all of allocations will be issued from a writeback thread, so
      contention is much less of an issue.  In addition, in the case
      where the entire file has been written within 30 seconds, we
      will be allocating the entire file at once, as described in (1).
      This is a fairly common case, so we should optimize for it.

   *) In the case of block allocations resulting from an fallocate(2),
      we should assume userspace knew what it was doing, and we
      shouldn't try to do any kind of size normalization.  Also,
      fallocate() calls generally don't happen with high frequency, so
      worrying about CPU scalability is probalby not a major issue.

   *) In the case of nodelalloc (or ext3 compatibility mode).  In that
      case, we will be doing lots of singleton allocation, and it's in
      this case where normalization and preallocation is most important.

   *) The Lustre file calls ext4_map_blocks() directly.  We'll need to
      check with Andreas, but the user is writing a lot of small files
      over Lustre, it may be that lock contention will be an issue,
      and we might want to use LG preallocation groups.

   *) Writes caused by fsync(2).  (For example, from SQLite files.)
      In this case, lock contention might very well be an issue, and
      use of the LG preallocation group some kind of file
      normalization may very well be a good idea.  In fact, we might
      want to have a hueristic which notices files which are written
      using either a slow append or an append followed by an fsync
      workload, and make sure we use an inode perallocation group, and
      in the case of a slow append workload, we might want to hold the
      preallocation over a file close (with some way of releasing
      blocks in an ENOSPC situation).

Some of the mballoc failure modes which you found in the Chopper paper
was specifically we weren't taking these various different scenarios
into account, and so we used an optimization that worked well when we
were allocating the whole file at a time (thanks to delalloc and
writebacks), and tht hueristic failed miserably in the case of large
files where we happened to be writing a tail.

So before we start playing with changing hueristics, it would be a
good idea if we make sure the block allocator has enough context so it
understands how it is being called and by whom, and make sure we that
we don't use the wrong hueristic by accident.

Does this make sense?

					- Ted
