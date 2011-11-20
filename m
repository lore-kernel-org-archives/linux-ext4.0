From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes"
Date: Sun, 20 Nov 2011 12:59:10 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1111201121120.1264@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Curt Wohlgemuth <curtw@google.com>, Ted Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1KTU7Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 15:59:24 -0500
Received: by iage36 with SMTP id e36so6386846iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Nov 2011 12:59:24 -0800 (PST)
In-Reply-To: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've seen no response to this, so Cc'ing Ted and linux-kernel,
and I'll fill in some more detail below.

On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
> It appears that there's a bug with this patch:
> 
> -------------------------------------------
> commit 02fac1297eb3f471a27368271aadd285548297b0
> Author: Allison Henderson <achender@linux.vnet.ibm.com>
> Date:   Tue Sep 6 21:53:01 2011 -0400
> 
>     ext4: fix partial page writes
> ...
> -------------------------------------------
> 
> Hugh Dickins found a bug with some nasty testing and lockdep that

It's the tmpfs swapping test that I've been running, with variations,
for years.  System booted with mem=700M and 1.5G swap, two repetitious
make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that because
the balance of built to unbuilt source grows smaller with later kernels),
one directly in a tmpfs (irrelevant in this case, except for the added
pressure it generates), the other in a 1k-block ext2 (that I drive with
ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file.

The first oops I got was indeed down in lockdep, but I've since seen
crashes from the same cause without lockdep configured in.  I've not
bothered to write down the stacks, beyond noting ext4_da_write_end()'s
call to ext4_discard_partial_page_buffers_no_lock() in them, since the
code there is clearly at fault as Curt describes.

> crashed in ext4_da_write_end(), and after looking at the code with
> him, it appears that the call to
> ext4_discard_partial_page_buffers_no_lock() in this routine is
> manipulating an unlocked, and possibly non-existent page:
> 
> 
> -------------------------------------------
> ...
> 	ret2 = generic_write_end(file, mapping, pos, len, copied,
> 							page, fsdata);
> 
> 	page_len = PAGE_CACHE_SIZE -
> 			((pos + copied - 1) & (PAGE_CACHE_SIZE - 1));
> 
> 	if (page_len > 0) {
> 		ret = ext4_discard_partial_page_buffers_no_lock(handle,
> 			inode, page, pos + copied - 1, page_len,
> 			EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
> 	}
> ...
> -------------------------------------------
> 
> Note that generic_write_end() will unlock and release the page before
> it returns.

Exactly.  And clearly the loop-on-tmpfs aspect of the test is
irrelevant, except in generating more pressure to trigger it.

> 
> I've no good answer for how to fix this properly, but I wanted to let
> Allison know about this, if she hadn't already.  I looked but didn't
> see any related email on the linux-ext4 list for this problem.

There was a second problem I was seeing, more elusive and much harder
to attribute: occasionally the build on ext2 would fail with errors
from ld (almost always of the kind "In function `no symbol': multiple
definition of `no symbol'" and "Warning: size of symbol `' changed":
I don't know if there's anything to be deduced from that).  I took
these to indicate an error in filesystem or loop or tmpfs or swap.

First suspect was loop changes from hch in 3.2-rc1, but backing those
out made no difference.  I thought I was facing a week's bisection
(since it would need at least a day to conclude any stage good), but
took a gamble on backing out *both* parts of 02fac1297eb3: page_len
additions to ext4_da_write_begin() as well as page_len additions to
ext4_da_write_end().

That gamble paid off: the test then showed no problems in several
days running on two machines.  So, both parts of 02fac1297eb3 are
bad, but it's not so easy to see what's wrong with the write_begin.

My *guess* is that the partial page fixes have interfered with the
subtle page-dirty buffer-dirty protocol in some way, which manifests
only under memory pressure.

It's conceivable that loop and tmpfs and swap play a part in this
further error, but I don't think so: I have no evidence for that,
and no such problem was seen before 3.2-rc1.

---

I wanted to find you an easier way to reproduce the problem, so I
tried fsx (I'm still using a pretty old fsx, no fallocate or punch
hole), run in ext2 on a kernel booted with mem=700M.  Sorry, I did
this a week ago, then didn't find time to write it up, and failed to
note when my ext2 was in /dev/loop0 and when it was directly on disk.

fsx foo -q -c 100 -l 100000000 &
while :
do	# memory hog mmaps and touches each page of 800MB private area
	swapout 800
done

I did not reproduce either problem above with that.  Instead I found
that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few minutes.
But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an hour.
On 3.1, fsx failed in a few minutes.  On 3.0, fsx failed in half an hour.
On 2.6.39, fsx failed in a few minutes.  I had to go back to 2.6.38 for
fsx to run successfully under memory pressure for more than two hours.

It looks as if ext4 testing has not been running fsx under memory
pressure recently.  And although I didn't reproduce my main problems
that way, it could well be that getting fsx to run reliably again
under memory pressure will be the way to fix those problems.

Thanks,
Hugh
