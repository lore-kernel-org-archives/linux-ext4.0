From: Bill Fink <bill@wizard.sci.gsfc.nasa.gov>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 16:49:58 -0400
Message-ID: <20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
	<20100830174000.GA6647@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Bill Fink <billfink@mindspring.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wizin.sci.gsfc.nasa.gov ([169.154.216.33]:55906 "EHLO
	wizin.sci.gsfc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0H3UuF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2010 16:50:05 -0400
In-Reply-To: <20100830174000.GA6647@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Aug 2010, Ted Ts'o wrote:

> On Sun, Aug 29, 2010 at 11:11:26PM -0400, Bill Fink wrote:
> > A 50% ext4 disk write performance regression was introduced
> > in 2.6.32 and still exists in 2.6.35, although somewhat improved
> > from 2.6.32.  Read performance was not affected).
> 
> Thanks for reporting it.  I'm going to have to take a closer look at
> why this makes a difference.  I'm going to guess though that what's
> going on is that we're posting writes in such a way that they're no
> longer aligned or ending at the end of a RAID5 stripe, causing a
> read-modify-write pass.  That would easily explain the write
> performance regression.

I'm not sure I understand.  How could calling or not calling
ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
affect the write alignment?

I was wondering if the locking being done in ext4_num_dirty_pages()
could somehow be affecting the performance.  I did notice from top
that in the patched 2.6.35 kernel, the I/O wait time was generally
in the 60-65% range, while in the unpatched 2.6.35 kernel, it was
at a higher 75-80% range.  However, I don't know if that's just a
result of the lower performance, or a possible clue to its cause.

> The interesting thing is that we don't actually do anything in
> ext4_da_writepages() to assure that we are making our writes are
> appropriate aligned and sized.  We do pay attention to make sure they
> are alligned correctly in the allocator, but _not_ in the writepages
> code.  So the fact that apparently things were well aligned in 2.6.32
> seems to be luck... (or maybe the writes are perfectly aligned in
> 2.6.32; they're just much worse with 2.6.35, and with explicit
> attention paid to the RAID stripe size, we could do even better :-)

It was 2.6.31 that was good.  The regression was in 2.6.32.  And again
how does the write alignment get modified simply by whether or not
ext4_num_dirty_pages() is called?

> If you could run blktraces on 2.6.32, 2.6.35 stock, and 2.6.35 with
> your patch, that would be really helpful to confirm my hypothesis.  Is
> that something that wouldn't be too much trouble?

I'd be glad to if you explain how one runs blktraces.

						-Thanks

						-Bill
