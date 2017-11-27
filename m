From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Mon, 27 Nov 2017 08:31:07 -0600
Message-ID: <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:37013 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdK0ObJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 09:31:09 -0500
Received: by mail-ua0-f181.google.com with SMTP id s28so19121437uag.4
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 06:31:08 -0800 (PST)
In-Reply-To: <20171122180317.nvymp7eedhswga7l@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Thank you very much for taking the time to lay all of this out for me
(and throwing some humor and youtube links to boot), despite how busy
you were (I hope everything is alright!). I see now why the fix works
and what was going wrong. It appears I was confused about the order of
operations being performed in the test based on what I read in another
email. I believe in another email somewhere I read that the fallocate
was before a delayed write so I was thinking something like fallocate
then write. I see now that it is write with delayed allocation
(resolved after fallocate) and then fallocate. With that piece of
information everything else about the test, delayed allocation, and
the fix make sense.

On Wed, Nov 22, 2017 at 12:03 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> [ Sorry for not getting back to you earlier.  I've been dealing with a
>   family medical emergency and hanging out at an intensive care unit
>   in Chicago for the past four days.  ]
>
> OK, let's start with the high-level explanation of how Delayed
> Allocation works.  When a userspace application does a buffered write,
> and delayed allocation is not enabled, then ext4 acts like ext3
> historically did.  That is, when a buffered write first touches a
> logical block which is not yet mapped to a physical block, the file
> system performs block allocation at the time of the write(2) system
> call.  At the next journal commit, the inode's extent tree (or inode
> structure or indirect blocks) are updated, along with the inode's
> i_size field (if necessary).  In order to avoid stale data writes,
> ext3 and ext4 in data=ordered mode, will write the data from the page
> cache to disk before the journal commit is allowed to be finalized.
>
> What are the implications of this?  If the application does a series
> of 4k writes, ext4 will allocate each 4k block one at a time.  And it
> will do that with no knowledge of how big the file will end up being.
>
> When delayed allocation is enabled[1], we do *not* make block
> allocation decisions at the time of the buffered write(2) call.
> Instead, we wait until the writeback timer expires, which by default
> is 30 seconds after the inode is first dirtied.  In many cases, the
> application is finished writing the file within 30 seconds, and now
> instead of doing N individual 4k block allocations, with delayed
> allocation we make a single block decision based on how many pages
> have been newly modified.  This makes it much easier to make much more
> intelligent allocation decisions.
>
> [1] It can get disabled via a mount option, or when the file system is
> almost full; in the latter case, it is temporary and delalloc will be
> automatically re-enabled when files are deleted and the file system
> has more free space.
>
>
> But what happens if we crash before the delayed allocation has been
> resolved?  As James Earl Jones might say, "I was never here[2]".  That
> is, it's as if never happened.
>
> [2] https://www.youtube.com/watch?v=-fPtmRZQVHo&feature=youtu.be&t=1m5s
>
> But immediately after the buffered write returns, if the program calls
> stat(2), the i_size returned by the stat(2) system call must reflect
> the results of the buffered write.  This is why we have i_size versus
> i_disksize.  The i_size value reflects the size of the file as it
> exists in the page cache.  The i_disksize value reflects the size of
> the file as it exists on disk.
>
> So i_disksize will lag i_size by up to 30 seconds.  But, by default,
> the journal commits happen every five seconds.  The other key thing to
> understand is that fallocate(2)'s ZERO_RANGE operation modifies both
> metadata *and* data blocks.
>
> Let's review xfstests generic/256.  The calls fsx --replay-ops with
> the following:
>
> 1.      write 0x137dd 0xdc69 0x0
> 2.      fallocate 0xb531 0xb5ad 0x21446
> 3.      collapse_range 0x1c000 0x4000 0x21446
> 4.      write 0x3e5ec 0x1a14 0x21446
> 5.      zero_range 0x20fac 0x6d9c 0x40000 keep_size
> 6.      mapwrite 0x216ad 0x274f 0x40000
>
> (I added the line numbers to make it clearer what I'm referring to.
>
> In the FSX replay log, the first argument is the starting offset, the
> second argument is the length, and the third is the i_size before the
> operation in question.  (The 3rd argument does not actually make any
> difference to the system call operation executed by fsx; it does make
> a difference to some of the explanatory messages printed by fsx, though.)
>
> Lines 1-3, just set up the inode's extent tree, and aren't really
> important.  Linux 6 isn't terribly important, either.  The important
> operations for the repro is lines 4 and 5.
>
> Line 4 does a buffered write, which done subject to the delayed
> allocation rules.  So it modifies the values in the page cache, but it
> not do any block allocation.  After the buffered write in line 4,
> i_size is 0x40000 but and i_disksize is 0x21446.
>
> Line 5 performs a FALLOC_FL_ZERO_RANGE from offset 0x20FAC to 0x27D48.
> What the zero_range operation will do is to change the file so that
> specified byte range will return zeroes if read.  If it is optimal to
> do so, the system MAY do this by not actually writing to the data
> blocks, but instead, by manipulating the extent tree.  So these two
> low-level actions are both valid ways of implementing the zero_range:
>
> 1.  (a) Read blocks 0x20 and 0x27 into page cache if necessary, (b)
>     zero offsets 0xFAC to 0xFFF of block 0x20, (c) zero offsets 0x000
>     to 0xD48 of block 0x27, (d) allocate blocks 0x21 to 0x26 if
>     necessary, marking blocks 0x21 to 0x26 as unitialized.
>
> 2.  (a) Read blocks 0x20 and 0x27 into page cache if necessary, (b)
>     zero offsets 0xFAC to 0xFFF of block 0x20, (c) zero offsets 0x000
>     to 0xD48 of block 0x27, (d) allocate blocks 0x21 to 0x26 if
>     necessary, marking blocks 0x21 to 0x26 as initialized, and write
>     zeros to blocks 0x21 to 0x26.
>
> Both 1 and 2 are perfectly valid, and ext4 will do both.  In #1, the
> system needs to do two 4k writes.  In #2, the system needs to do a 32k
> sequential write (blocks 20 through 27).  By default, if the size of
> the write needed to initialize the blocks is 32k or less, ext4 will
> choose #2, since eliminates the need to manipulate the extent tree to
> mark blocks as initialized later, and it tends to leave the extent
> tree in a less fragmented state.  On the other hand, if the userspace
> program requests a zero_range operation on several megabytes, and
> better yet, the starting and ending offsets are 4k aligned, then there
> is no need to do the two 4k random writes at the beginning and the end
> of the range, then just manipulating the extent tree (as in #1) is the
> better way to go.
>
> In the case of xfstests generic/456, we are doing #2, and within five
> seconds of zero_range operation being issued, the system will journal
> commit, so all of the actions in #2 needs to be committed after a
> crash.  The last offset of the zero_range, 0x27D48 is beyond the
> current on-disk i_size of 0x21446.  So if we crash at this point, it's
> important that after journal replay, i_size is updated to be 0x27D48.
>
> However, since the delayed allocation write has not been resolved.
> i_size is 0x40000, which is beyond 0x27D46.  Due to the missing check,
> the buggy code would see that i_size is beyond the last byte of the
> last offset of the zero_range, and skip updating the on_disk size.
> And this is what causes the bug.
>
> The fix is to change the code to update the on-disk size if the end
> offset of zero_range is beyond i_size *or* beyond i_disksize.  And
> this is what commit 51e3ae81ec58: "ext4: fix interaction between
> i_size, fallocate, and delalloc after a crash" does.
>
> Hope this helps,
>
>                                                 - Ted
